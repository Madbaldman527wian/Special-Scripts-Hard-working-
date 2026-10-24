local LP = game:GetService("Players").LocalPlayer
local G = game:GetObjects("rbxassetid://89879398457854")[1]
local rem
local M = {}
local C = {}
local ST = {}
local function req(k)
	if ST[k] == 2 then
		return C[k]
	end
	if ST[k] == 1 then
		error("Requested module was required recursively")
	end
	ST[k] = 1
	local ok, v = pcall(M[k])
	if not ok then
		ST[k] = nil
		error(v, 0)
	end
	C[k] = v
	ST[k] = 2
	return v
end

M.assertType = function()
	local typeof = typeof
	local ipairs = ipairs
	local error = error
	local tableConcat = table.concat
	local function assertType(methodName, value, types, argNum)
		local t = typeof(value)
		for _, expectedType in types do
			if t == expectedType then
				return
			end
		end
		error(`invalid argument #{argNum} to '{methodName}' ({tableConcat(types, " or ")} expected, got {t})`)
	end
	local function assertClass(methodName, instance, classes, argNum)
		assertType(methodName, instance, {"Instance"}, argNum)
		if type(classes) == "string" then
			classes = {classes}
		end
		local class = instance.ClassName
		for _, className in classes do
			if class == className then
				return
			end
		end
		error(`invalid argument #{argNum} to '{methodName}' ({table.concat(classes, ", or ")} expected, got {class})`)
	end
	return {
		assertType = assertType,
		assertClass = assertClass
	}
end
M.Signal = function()
	local Signal = {}
	local Connection = {}
	Signal.__index = Signal
	Connection.__index = Connection
	Signal.__tostring = function(self)
		if self._name then
			return `Signal {self._name}`
		end
		return "Signal"
	end
	Connection.__tostring = function()
		return "RBXScriptConnection"
	end
	function Connection:Disconnect()
		self.Connected = false
		table.remove(self._parent._connections, table.find(self._parent._connections, self))
	end
	Connection.disconnect = Connection.Disconnect
	function Connection.new(parent, callback)
		local self = setmetatable({}, Connection)
		self.Connected = true
		self._callback = callback
		self._parent = parent
		self._once = false
		table.insert(parent._connections, self)
		return self
	end
	function Signal:Connect(callback)
		assert(type(callback) == "function", "callback must be a function")
		return Connection.new(self, callback)
	end
	function Signal:Once(callback)
		assert(type(callback) == "function", "callback must be a function")
		local connection = Connection.new(self, callback)
		connection._once = true
		return callback
	end
	function Signal:Wait()
		local thread = coroutine.running()
		table.insert(self._waitingThreads, thread)
		return coroutine.yield()
	end
	function Signal:Fire(...)
		for _, connection in self._connections do
			task.spawn(connection._callback, ...)
			if connection._once then
				connection:Disconnect()
			end
		end
		for _, thread in self._waitingThreads do
			task.spawn(thread, ...)
		end
		table.clear(self._waitingThreads)
	end
	function Signal:Destroy()
		for _, connection in self._connections do
			connection:Disconnect()
		end
		for _, thread in self._waitingThreads do
			coroutine.resume(thread)
		end
		table.clear(self._waitingThreads)
	end
	Signal.connect = Signal.Connect
	Signal.wait = Signal.Wait
	Signal.fire = Signal.Fire
	Signal.destroy = Signal.Destroy
	function Signal.new(name)
		local self = setmetatable({}, Signal)
		self._waitingThreads = {}
		self._connections = {}
		self._name = name
		return self
	end
	return Signal
end
M.easing = function()
	local TweenService = game:GetService("TweenService")
	local round = math.round
	local getValue = TweenService.GetValue
	local easingDirections = Enum.EasingDirection:GetEnumItems()
	local easingFuncs = {}
	for _, poseEasingStyle in Enum.PoseEasingStyle:GetEnumItems() do
		if poseEasingStyle == Enum.PoseEasingStyle.Constant or poseEasingStyle == Enum.PoseEasingStyle.CubicV2 then
			continue
		end
		local success, easingStyle = pcall(function()
			return Enum.EasingStyle[poseEasingStyle.Name]
		end)
		if not success then
			warn(`unable to process {poseEasingStyle.Name} easing style, some animations may cause the animator to error`)
			continue
		end
		local directions = {}
		for _, direction in easingDirections do
			directions[direction.Value] = function(a)
				return getValue(TweenService, a, easingStyle, direction)
			end
		end
		easingFuncs[poseEasingStyle.Value] = directions
	end
	easingFuncs[Enum.PoseEasingStyle.Constant.Value] = {
		[0] = round,
		[1] = round,
		[2] = round,
	}
	local cubic = easingFuncs[Enum.PoseEasingStyle.Cubic.Value]
	easingFuncs[Enum.PoseEasingStyle.CubicV2.Value] = table.clone(cubic)
	cubic[0], cubic[1] = cubic[1], cubic[0]
	local function getLerpAlpha(a, poseEasingStyleValue, poseEasingDirectionValue)
		return easingFuncs[poseEasingStyleValue][poseEasingDirectionValue](a)
	end
	return getLerpAlpha
end
M.AnimationTrack = function()
	local TweenService = game:GetService("TweenService")
	local Signal = req("Signal")
	local getLerpAlpha = req("easing")
	local assertType = req("assertType").assertType
	local AnimationTrack = {}
	AnimationTrack.__index = AnimationTrack
	function AnimationTrack:AdjustSpeed(speed)
		assertType("AdjustSpeed", speed, {"number"}, 2)
		self.Speed = speed
	end
	function AnimationTrack:AdjustWeight(weight, fadeTime)
		assertType("AdjustWeight", weight, {"number"}, 2)
		assertType("AdjustWeight", fadeTime, {"number", "nil"}, 3)
		self.Weight = weight
		if self._setWeight then
			self._setWeight(weight, fadeTime)
		end
	end
	function AnimationTrack:GetMarkerReachedSignal(name)
		assertType("GetMarkerReachedSignal", name, {"string"}, 2)
		local event = self._markerReachedSignals[name]
		if not event then
			event = Signal.new("MarkerReached")
			self._markerReachedSignals[name] = event
		end
		return event
	end
	function AnimationTrack:GetTimeOfKeyframe(keyframeName)
		assertType("GetTimeOfKeyframe", keyframeName, {"string"}, 2)
		return self._keyframeTimes[keyframeName] or error("Could not find a keyframe by that name!")
	end
	local clock = os.clock
	local min = math.min
	local tclear = table.clear
	local cframeIdentity = CFrame.identity
	function AnimationTrack:Play(fadeTime, weight, speed)
		assertType("Play", fadeTime, {"number", "nil"}, 2)
		assertType("Play", weight, {"number", "nil"}, 3)
		assertType("Play", speed, {"number", "nil"}, 4)
		fadeTime = fadeTime or 0.1
		weight = weight or self.Weight
		speed = speed or 1
		self.Speed = speed
		self.Weight = weight
		local keyframes = self._keyframes
		local keyframeTimes = self._keyframeTimes
		local keyframeNames = self._keyframeNamesOrdered
		local markerTimes = self._markerTimes
		local markerNames = self._markerNamesOrdered
		local markerReachedSignals = self._markerReachedSignals
		local transforms = table.clone(self._parent._transforms)
		local jointNames = self._jointNames
		local hasNamedKeyframes = #keyframeNames > 0
		local hasNamedMarkers = #markerNames > 0
		local nextPassKeyframeIdx = 1
		local nextPassMarkerIdx = 1
		local didLoopEvent = self.DidLoop
		local keyframeReachedEvent = self.KeyframeReached
		self._transforms = transforms
		local startTime = clock()
		local length = self.Length
		local timePosition = 0
		local poseIndexes = {}
		local nextPoseIndexes = {}
		local lastPoses = {}
		local nextPoses = {}
		local jointNames = self._jointNames
		local weightInitial = 0
		local weightFadeStart = startTime
		local function reset()
			for _, jointName in jointNames do
				lastPoses[jointName] = keyframes[jointName][1]
				nextPoses[jointName] = keyframes[jointName][2]
				poseIndexes[jointName] = 1
				nextPoseIndexes[jointName] = 2
			end
		end
		local function getCurrentTotalWeight()
			return weightInitial + (weight - weightInitial)*min((clock() - weightFadeStart)/fadeTime, 1)
		end
		self._startTime = startTime
		reset()
		local function step(delta)
			debug.profilebegin("animationProcess")
			local now = clock()
			local netWeight = getCurrentTotalWeight()
			if length == 0 then
				for _, jointName in jointNames do
					local pose = keyframes[jointName][1]
					transforms[jointName] = pose and pose.CFrame or cframeIdentity
				end
				return transforms, netWeight
			end
			local inc = delta*self.Speed
			timePosition += inc
			local trueTimePosition = self.TimePosition + inc
			if trueTimePosition ~= timePosition then
				timePosition = self.TimePosition
				reset()
				for i, time in keyframeTimes do
					if time > timePosition then
						nextPassKeyframeIdx = i
						break
					end
				end
				for i, time in markerTimes do
					if time > timePosition then
						nextPassMarkerIdx = i
						break
					end
				end
				timePosition = trueTimePosition
			else
				self.TimePosition = timePosition
			end
			if timePosition > length then
				if self.Looped then
					timePosition %= length
					nextPassKeyframeIdx = 1
					nextPassMarkerIdx = 1
					reset()
					didLoopEvent:Fire()
				else
					self.TimePosition = 0
					self:Stop(0.5)
					return
				end
			end
			self.TimePosition = timePosition
			if hasNamedKeyframes then
				local nextKeyframeTime = keyframeTimes[nextPassKeyframeIdx]
				if nextKeyframeTime then
					if timePosition >= nextKeyframeTime then
						repeat
							keyframeReachedEvent:Fire(keyframeNames[nextPassKeyframeIdx])
							nextPassKeyframeIdx += 1
						until not keyframeTimes[nextPassKeyframeIdx] or keyframeTimes[nextPassKeyframeIdx] > timePosition
					end
				end
			end
			if hasNamedMarkers then
				local nextMarkerTime = markerTimes[nextPassMarkerIdx]
				if nextMarkerTime then
					if timePosition >= nextMarkerTime then
						repeat
							local event = markerReachedSignals[markerNames[nextPassMarkerIdx]]
							if event then
								event:Fire()
							end
							nextPassMarkerIdx += 1
						until not markerTimes[nextPassMarkerIdx] or markerTimes[nextPassMarkerIdx] > timePosition
					end
				end
			end
			for _, jointName in jointNames do
				local poses = keyframes[jointName]
				if #poses == 0 then
					transforms[jointName] = cframeIdentity
					continue
				end
				local lastPose = lastPoses[jointName]
				local nextPose = nextPoses[jointName]
				local poseIdx = poseIndexes[jointName]
				local nextPoseIdx = nextPoseIndexes[jointName]
				local numPoses = #poses
				if nextPose and timePosition > nextPose.time then
					repeat
						poseIdx = nextPoseIdx
						nextPoseIdx += 1
					until not poses[nextPoseIdx] or poses[nextPoseIdx].time >= timePosition
					lastPose = poses[poseIdx]
					nextPose = poses[nextPoseIdx]
					lastPoses[jointName] = lastPose
					nextPoses[jointName] = nextPose
					poseIndexes[jointName] = poseIdx
					nextPoseIndexes[jointName] = nextPoseIdx
				end
				if not nextPose or lastPose == nextPose then
					transforms[jointName] = lastPose.cframe
				else
					local dt = (timePosition - lastPose.time)/(nextPose.time - lastPose.time)
					transforms[jointName] = lastPose.cframe:Lerp(nextPose.cframe, getLerpAlpha(dt, nextPose.easingStyle, nextPose.easingDirection))
				end
			end
			debug.profileend()
			return transforms, netWeight
		end
		local function setWeight(newWeight, newFadeTime)
			weightInitial = getCurrentTotalWeight()
			weight = newWeight
			weightFadeStart = clock()
			fadeTime = newFadeTime or 0.1
			self.Weight = newWeight
		end
		self.IsPlaying = true
		self._step = step
		self._setWeight = setWeight
	end
	function AnimationTrack:_fadeOut(fadeTime)
		local initCFrames = table.clone(self._transforms)
		local startTime = clock()
		local function step()
			local elapsed = clock() - startTime
			local newTransforms = {}
			local a = min(elapsed/fadeTime, 1)
			if a == 1 then
				self.Ended:Fire()
				if self._step == step then
					self._step = nil
					self._setWeight = nil
				end
				return
			end
			for jointName, initCF in initCFrames do
				newTransforms[jointName] = initCF:Lerp(cframeIdentity, a)
			end
			self._transforms = newTransforms
			return {}, self.Weight*(1 - a)
		end
		self._step = step
	end
	function AnimationTrack:Stop(fadeTime)
		assertType("Stop", fadeTime, {"number", "nil"}, 2)
		if not self.IsPlaying then
			return
		end
		fadeTime = fadeTime or 0.5
		self.IsPlaying = false
		self.Stopped:Fire()
		self._step = nil
		self._startTime = nil
		if fadeTime > 0 then
			self:_fadeOut(fadeTime)
		else
			self.Ended:Fire()
		end
	end
	function AnimationTrack:Destroy()
		assert(not self._destroyed, "cannot destroy already destroyed AnimationTrack")
		self._destroyed = true
		self:Stop()
		self.DidLoop:Destroy()
		self.Stopped:Destroy()
		self.Ended:Destroy()
		self.KeyframeReached:Destroy()
		self.Stopped:Destroy()
		for _, signal in self._markerReachedSignals do
			signal:Destroy()
		end
		table.remove(self._parent._animations, table.find(self._parent._animations, self))
	end
	function AnimationTrack.new(parent, keyframeSequence)
		local self = setmetatable({}, AnimationTrack)
		self.IsPlaying = false
		self.Length = 0
		self.Looped = keyframeSequence.Loop
		self.Speed = 1
		self.TimePosition = 0
		self.Weight = 1
		self.Priority = keyframeSequence.Priority
		self.Name = keyframeSequence.Name
		self.DidLoop = Signal.new("DidLoop")
		self.Ended = Signal.new("Ended")
		self.KeyframeReached = Signal.new("KeyframeReached")
		self.Stopped = Signal.new("Stopped")
		self._parent = parent
		self._destroyed = false
		self._keyframes = {}
		self._keyframeTimes = {}
		self._keyframeNamesOrdered = {}
		self._markerTimes = {}
		self._markerNamesOrdered = {}
		self._jointNames = {}
		self._transforms = {}
		self._step = nil
		self._setWeight = nil
		self._markerReachedSignals = {}
		local keyframeTimes = {}
		local markerTimes = {}
		for _, keyframe in keyframeSequence:GetChildren() do
			self.Length = math.max(self.Length, keyframe.time)
			if keyframe.Name ~= "Keyframe" then
				keyframeTimes[keyframe.Name] = keyframe.time
				table.insert(self._keyframeTimes, keyframe.time)
				table.insert(self._keyframeNamesOrdered, keyframe.Name)
			end
			for _, marker in keyframe:GetMarkers() do
				markerTimes[marker.Name] = keyframe.time
				table.insert(self._markerTimes, keyframe.time)
				table.insert(self._markerNamesOrdered, marker.Name)
			end
			local rootPose = keyframe:GetChildren()[1]
			if not rootPose then
				continue
			end
			for _, pose in rootPose:GetDescendants() do
				if not pose:IsA("Pose") or pose.Weight == 0 then
					continue
				end
				local keyframes = self._keyframes[pose.Name]
				if not keyframes then
					keyframes = {}
					self._keyframes[pose.Name] = keyframes
					self._transforms[pose.Name] = CFrame.identity
					table.insert(self._jointNames, pose.Name)
				end
				table.insert(keyframes, {
					time = keyframe.Time,
					cframe = pose.CFrame,
					easingDirection = pose.EasingDirection.Value,
					easingStyle = pose.EasingStyle.Value,
					weight = pose.Weight
				})
			end
		end
		table.sort(self._keyframeTimes, function(a, b) return a < b end)
		table.sort(self._markerTimes, function(a, b) return a < b end)
		table.sort(self._keyframeNamesOrdered, function(a, b)
			return keyframeTimes[a] < keyframeTimes[b]
		end)
		table.sort(self._markerNamesOrdered, function(a, b)
			return markerTimes[a] < markerTimes[b]
		end)
		for _, jointKeyframes in self._keyframes do
			table.sort(jointKeyframes, function(a, b)
				return a.time < b.time
			end)
			if self.Looped and #jointKeyframes > 1 then
				local first = table.clone(jointKeyframes[1])
				local last = table.clone(jointKeyframes[#jointKeyframes])
				first.time = self.Length + first.time
				last.time = last.time - self.Length
				table.insert(jointKeyframes, first)
				table.insert(jointKeyframes, 1, last)
			end
		end
		return self
	end
	return AnimationTrack
end
M.Animator = function()
	local RunService = game:GetService("RunService")
	local AnimationMode = {
		Transform = 0,
		C0 = 1
	}
	local Animator = {}
	Animator.__index = Animator
	Animator.AnimationMode = AnimationMode
	local AnimationTrack = req("AnimationTrack")
	local Signal = req("Signal")
	local assertClass = req("assertType").assertClass
	local function assertIsObject(self)
		assert(self ~= Animator, "cannot call object method on static class")
	end
	function Animator:LoadAnimation(keyframeSequence)
		assertIsObject(self)
		assertClass("LoadAnimation", keyframeSequence, {"AnimationTrack", "KeyframeSequence"}, 2)
		local animations = self._animations
		for _, animation in animations do
			if animation._keyframeSequence == keyframeSequence then
				return animation
			end
		end
		local animation = AnimationTrack.new(self, keyframeSequence)
		table.insert(animations, animation)
		return animation
	end
	function Animator:GetPlayingAnimationTracks()
		local tracks = {}
		for _, animationTrack in self._animations do
			if animationTrack.IsPlaying then
				table.insert(tracks, animationTrack)
			end
		end
		return tracks
	end
	function Animator:Destroy()
		assertIsObject(self)
		assert(not self._destroyed, "cannot destroy already destroyed Animator")
		self._destroyed = true
		for _, animation in self._animations do
			animation:Destroy()
		end
		for _, stopTracker in self._jointTrackers do
			stopTracker()
		end
		table.clear(self._animations)
		table.clear(self._jointTrackers)
		self._stepped:Disconnect()
		self._descendantAdded:Disconnect()
		self._descendantRemoving:Disconnect()
		self._stepped = nil
		self._descendantAdded = nil
		self._descendantRemoving = nil
	end
	local clock = os.clock
	local cfIdentity = CFrame.identity
	local function Part1Tracker(part, onSet)
		local connection = part:GetPropertyChangedSignal("Name"):Connect(function()
			onSet(part.Name)
		end)
		return function()
			connection:Disconnect()
		end
	end
	local function JointTracker(joint, onSet, onUnset)
		local current
		local currentTracker
		local function onPartNameChanged(name)
			onUnset(current)
			current = name
			onSet(current)
		end
		if joint.Part1 then
			current = joint.Part1.Name
			currentTracker = Part1Tracker(joint.Part1, onPartNameChanged)
		end
		local connection = joint:GetPropertyChangedSignal("Part1"):Connect(function()
			onUnset(current)
			if currentTracker then
				currentTracker()
				currentTracker = nil
			end
			if joint.Part1 then
				current = joint.Part1.Name
				onSet(current)
				currentTracker = Part1Tracker(joint.Part1, onPartNameChanged)
			end
		end)
		return function()
			connection:Disconnect()
			if currentTracker then
				currentTracker()
			end
		end
	end
	function Animator.new(humanoid)
		assertClass("Animator.new", humanoid, {"Humanoid", "AnimationController"}, 1)
		local self = setmetatable({}, Animator)
		local animations = {}
		local joints = {}
		local jointTrackers = {}
		local steppedEvent = Signal.new("Stepped")
		self.AnimationMode = AnimationMode.Transform
		self.Stepped = steppedEvent
		self._humanoid = humanoid
		self._destroyed = false
		self._joints = joints
		self._transforms = {}
		self._jointTrackers = jointTrackers
		self._animations = animations
		self._descendantAdded = nil
		self._descendantRemoving = nil
		local last = clock()
		self._stepped = RunService.Stepped:Connect(function()
			debug.profilebegin("animatorProcess")
			local now = clock()
			local delta = now - last
			last = now
			local currentTransforms = self._transforms
			local newTransforms = {}
			local priorities = {}
			for jointName in joints do
				priorities[jointName] = 0
			end
			for _, animation in animations do
				if not animation._step then
					continue
				end
				local priority = animation.Priority.Value
				local transforms, weight = animation._step(delta)
				if not transforms then
					continue
				end
				for jointName, cf in transforms do
					if not joints[jointName] then
						continue
					end
					local override = false
					if priority >= priorities[jointName] then
						priorities[jointName] = priority
						override = true
					end
					local other = newTransforms[jointName]
					if override then
						local startTime = animation._startTime
						if other then
							local a = priority == other[3] and weight/(weight + other[4]) or weight
							local cfFinal = other[2]:Lerp(cf, a)
							newTransforms[jointName] = {startTime, cfFinal, priority, weight}
						else
							newTransforms[jointName] = {startTime, cf, priority, weight}
						end
					end
				end
			end
			for jointName, cfData in newTransforms do
				newTransforms[jointName] = cfData[2]
			end
			for jointName, joint in joints do
				local cf = newTransforms[jointName]
				local transform
				if cf then
					transform = cf
					newTransforms[jointName] = transform
				else
					transform = currentTransforms[jointName]:Lerp(cfIdentity, 1 - (1/10)^(delta*10))
					newTransforms[jointName] = transform
				end
				if self.AnimationMode == AnimationMode.Transform then
					joint.joint.Transform = transform
				else
					joint.joint.C0 = joint.c0 * transform
				end
			end
			self._transforms = newTransforms
			steppedEvent:Fire(newTransforms)
			debug.profileend()
		end)
		local function newDescendant(joint)
			if joint.ClassName ~= "Motor6D" then
				return
			end
			local me = {
				joint = joint,
				c0 = joint.C0
			}
			if joint.Part1 then
				joints[joint.Part1.Name] = me
				self._transforms[joint.Part1.Name] = cfIdentity
			end
			self._jointTrackers[joint] = JointTracker(joint, function(name)
				joints[name] = me
				if not self._transforms[joint.Part1.Name] then
					self._transforms[joint.Part1.Name] = cfIdentity
				end
			end, function(name)
				joints[name] = nil
			end)
		end
		for _, joint in humanoid.Parent:GetDescendants() do
			newDescendant(joint)
		end
		self._descendantAdded = humanoid.Parent.DescendantAdded:Connect(newDescendant)
		self._descendantRemoving = humanoid.Parent.DescendantRemoving:Connect(function(joint)
			if joint.ClassName ~= "Motor6D" then
				return
			end
			if joint.Part1 then
				steppedEvent[joint.Part1.Name] = nil
			end
			jointTrackers[joint]()
			jointTrackers[joint] = nil
		end)
		return self
	end
	return Animator
end
local function SC(script)
	local character = script.Parent
	local humanoid = character:WaitForChild("Humanoid")
	local root = character:WaitForChild("HumanoidRootPart")
	local Animator = req("Animator")
	local animator = Animator.new(humanoid)
	animator.AnimationMode = Animator.AnimationMode.C0
	local health = humanoid.Health
	local isstunned = false
	local shockwave = script:FindFirstChild("Shockwave")
	if shockwave then
		shockwave.Parent = nil
	end
	local weld = nil
	local highlights = {}
	local swords = script:FindFirstChild("Swords")
	if swords then
		swords.Parent = nil
	end
	local abi = false
	local animsfolder = script.animations
	if animsfolder then
		animsfolder.Parent = nil
	end
	local stunids = {
		127407161765070,
		76279549285070,
		139477985881551,
		101236418754441,
		101891040414483,
		130007374858894,
		136928477805472,
		88035218917486,
		115634615746119,
		116737153661438,
		125412409728651
	}
	local anims = {
		idle = animator:LoadAnimation(animsfolder["1x1 Idle"]),
		run = animator:LoadAnimation(animsfolder["1x1 Run"]),
		entaglement = animator:LoadAnimation(animsfolder["Entanglement"]),
		massinfection = animator:LoadAnimation(animsfolder["Mass Infection"]),
		kill = animator:LoadAnimation(animsfolder["Execution Killer"]),
		slash = animator:LoadAnimation(animsfolder["Slash"]),
		stun = animator:LoadAnimation(animsfolder["StunStart"]),
		stunloop = animator:LoadAnimation(animsfolder["StunIdle"]),
		stunend = animator:LoadAnimation(animsfolder["StunEnd"]),
		unstableye = animator:LoadAnimation(animsfolder["Unstable Eye"]),
		kill_2 = animator:LoadAnimation(animsfolder["Shed Execution 1x"]),
	}
	task.spawn(function()
		while isstunned do
			task.wait(0.1)
			abi = true
			anims.idle:Stop()
			anims.run:Stop()
		end
	end)
	rem.mass.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		anims.massinfection.TimePosition = 0
		root.Anchored = true
		anims.idle:Stop()
		anims.run:Stop()
		anims.massinfection:Play()
		local sound1 = script:FindFirstChild("MassInfection")
		if sound1 then sound1:Play() end
		local sound2 = script:FindFirstChild("MassInfection2")
		if sound2 then sound2:Play() end
		task.wait(1.5)
		local projectile = shockwave:Clone()
		local projroot = projectile:FindFirstChild("Root")
		projroot.CFrame = root.CFrame * CFrame.new(0, 0, -10)
		projectile.Parent = workspace.Terrain
		local bv = Instance.new("BodyVelocity", projroot)
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = root.CFrame.LookVector * 100
		projroot.CanTouch = false
		projroot.Anchored = false
		projroot.Ambience:Play()
		task.delay(0.2, function()
			if projroot and projroot.Parent then
				projroot.CanTouch = true
			end
		end)
		projroot.Touched:Connect(function(hit)
			if not projroot.CanTouch then return end
			if hit.Parent:IsDescendantOf(character) then return end
			local hum = hit.Parent:FindFirstChild("Humanoid")
			if hum then
				hum:TakeDamage(35)
			end
		end)
		game.Debris:AddItem(projectile, 10)
		task.wait(1)
		root.Anchored = false
		anims.idle:Play()
		abi = false
	end)
	rem.entaglement.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		anims.entaglement.TimePosition = 0
		root.Anchored = true
		anims.idle:Stop()
		anims.run:Stop()
		anims.entaglement:Play()
		local sound1 = script:FindFirstChild("Entaglement")
		if sound1 then sound1:Play() end
		task.wait(1)
		local projectile = swords:Clone()
		local projroot = projectile:FindFirstChild("Root")
		projroot.CFrame = root.CFrame * CFrame.new(0, 0, -10) * CFrame.Angles(0, math.rad(180), 0)
		projectile.Parent = workspace.Terrain
		local bv = Instance.new("BodyVelocity", projroot)
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Velocity = root.CFrame.LookVector * 100
		projroot.CanTouch = false
		projroot.Anchored = false
		task.delay(0.2, function()
			if projroot and projroot.Parent then
				projroot.CanTouch = true
			end
		end)
		projroot.Touched:Connect(function(hit)
			if not projroot.CanTouch then return end
			if hit.Parent:IsDescendantOf(character) then return end
			local hum = hit.Parent:FindFirstChildOfClass("Humanoid")
			if hum then
				hum:TakeDamage(35)
				local speed = hum.WalkSpeed
				humanoid.WalkSpeed = 0
				task.delay(3, function()
					humanoid.WalkSpeed = speed
				end)
			end
		end)
		game.Debris:AddItem(projectile, 10)
		task.wait(1)
		root.Anchored = false
		anims.idle:Play()
		abi = false
	end)
	rem.eye.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		anims.unstableye.TimePosition = 0
		anims.unstableye:Play()
		anims.idle:Stop()
		anims.run:Stop()
		humanoid.WalkSpeed = 0.1
		script.UnstableEye:Play()
		task.wait(1.5)
		humanoid.WalkSpeed = 32.5
		for _, p in ipairs(game.Players:GetPlayers()) do
			if p ~= player and p.Character and p.Character ~= character then
				local hl = Instance.new("Highlight")
				hl.FillColor = Color3.fromRGB(255, 255, 0)
				hl.OutlineColor = Color3.fromRGB(197, 197, 0)
				hl.Parent = p.Character
				table.insert(highlights, hl)
			end
		end
		task.wait(0.5)
		anims.idle:Play()
		abi = false
		task.delay(3, function()
			for _, hl in ipairs(highlights) do
				if hl then hl:Destroy() end
			end
			table.clear(highlights)
			humanoid.WalkSpeed = 27
		end)
	end)
	rem.swing.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		anims.idle:Stop()
		anims.run:Stop()
		anims.slash.TimePosition = 0
		anims.slash:Play()
		script.Slash:Play()
		task.delay(0.65, function()
			local alreadyhit = {}
			local startime = tick()
			while tick() - startime <= 0.6 do
				local hrpcframe = character.HumanoidRootPart.CFrame
				local boxsize = Vector3.new(2, 4.739, 5.375)
				local boxcframe = hrpcframe * CFrame.new(0, 0, -3)
				local overlaparams = OverlapParams.new()
				overlaparams.FilterDescendantsInstances = {character}
				overlaparams.FilterType = Enum.RaycastFilterType.Exclude
				local parts = workspace:GetPartBoundsInBox(boxcframe, boxsize, overlaparams)
				for _, part in ipairs(parts) do
					local model = part:FindFirstAncestorOfClass("Model")
					if model and model ~= character then
						local hum = model:FindFirstChildOfClass("Humanoid")
						if hum and not table.find(alreadyhit, hum) then
							table.insert(alreadyhit, hum)
							local damage = 15
							hum.Health -= damage
							script.Hit:Play()
							if hum.Health <= 25 then
								isstunned = true
								local targetroot = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
								if targetroot then
									targetroot.CFrame = root.CFrame * CFrame.new(0, 0, -3)
								end
								local weld = nil
								if targetroot and model.PrimaryPart then
									weld = Instance.new("WeldConstraint")
									weld.Part0 = root
									weld.Part1 = targetroot
									weld.Parent = root
								end
								root.Anchored = true
								if math.random(1, 100) <= 80 then
									script.Kill.SoundId = "rbxassetid://77959988631460"
									script.Kill:Play()
									anims.kill_2:Play()
									local victimanimator = Animator.new(hum)
									victimanimator.AnimationMode = Animator.AnimationMode.C0
									local victimtrack = victimanimator:LoadAnimation(animsfolder["Shed Execution Player"])
									victimtrack:Play()
									task.wait(4.267)
									hum.Health = 0
								else
									script.Kill.SoundId = "rbxassetid://84384752783260"
									script.Kill:Play()
									anims.kill:Play()
									local victimanimator = Animator.new(hum)
									victimanimator.AnimationMode = Animator.AnimationMode.C0
									local victimtrack = victimanimator:LoadAnimation(animsfolder["Execution Player"])
									victimtrack:Play()
									task.wait(3.333)
									hum.Health = 0
								end
								root.Anchored = false
								if weld then
									weld:Destroy()
								end
								isstunned = false
							end
						end
					end
				end
				task.wait(0.05)
			end
		end)
		task.wait(1.2)
		anims.idle:Play()
		abi = false
	end)
	humanoid.HealthChanged:Connect(function(health2)
		local damagetaken = health - health2
		if damagetaken >= 30 and not isstunned and health2 > 0 then
			anims.idle:Stop()
			anims.run:Stop()
			anims.stun.TimePosition = 0
			anims.stun:Play()
			humanoid.WalkSpeed = 0
			script.Stun.SoundId = "rbxassetid://"..tostring(stunids[math.random(1, #stunids)])
			script.Stun:Play()
			isstunned = true
			task.wait(2.483)
			anims.stunloop:Play()
			task.wait(3)
			anims.stunloop:Stop()
			anims.stunend.TimePosition = 0
			anims.stunend:Play()
			task.wait(1)
			humanoid.WalkSpeed = 27
			isstunned = false
			anims.idle:Play()
		end
	end)
	humanoid.WalkSpeed = 27
	humanoid.Running:Connect(function(speed)
		if abi then return end
		if speed > 0.5 then
			anims.idle:Stop()
			anims.run:Play()
		else
			anims.idle:Play()
			anims.run:Stop()
		end
	end)
end
local function LC(script)
	local contextactionservice = game:GetService("ContextActionService")
	local function handlekeybinds(actioname, inputstate, inputobject)
		if inputstate ~= Enum.UserInputState.Begin then return end
		if actioname == "swing" then
			rem.swing:FireServer()
		elseif actioname == "mass" then
			rem.mass:FireServer()
		elseif actioname == "entaglement" then
			rem.entaglement:FireServer()
		elseif actioname == "eye" then
			rem.eye:FireServer()
		end
	end
	contextactionservice:BindAction("swing", handlekeybinds, true, Enum.UserInputType.MouseButton1, Enum.KeyCode.ButtonR2)
	contextactionservice:BindAction("mass", handlekeybinds, true, Enum.KeyCode.Q)
	contextactionservice:BindAction("entaglement", handlekeybinds, true, Enum.KeyCode.E)
	contextactionservice:BindAction("eye", handlekeybinds, true, Enum.KeyCode.R)
end
local function oneeggs(username: string)
	if not username then return end
	local player = game.Players:FindFirstChild(username)
	local rig = G.Rig:Clone()
	local start = CFrame.new(0, 32, 0)
	if player.Character then
		start = player.Character:GetPivot()
	end
	rig:PivotTo(start * CFrame.new(0, 2.9, 0))
	rig.Name = player.Name
	player.Character = rig
	rig.Humanoid.DisplayName = player.Name
	rem = {}
	for _, n in ipairs({"swing", "mass", "entaglement", "eye"}) do
		local be = Instance.new("BindableEvent")
		rem[n] = {
			OnServerEvent = be.Event,
			FireServer = function(_, ...)
				be:Fire(LP, ...)
			end
		}
	end
	for _, d in ipairs(rig:GetDescendants()) do
		if d:IsA("BaseScript") then
			d.Enabled = false
		end
	end
	rig.Parent = workspace
	task.defer(SC, rig.Script)
	task.defer(LC, rig.LocalScript)
end
oneeggs(LP.Name)
