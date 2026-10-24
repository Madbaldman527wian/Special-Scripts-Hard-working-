local LP = game:GetService("Players").LocalPlayer
local G = game:GetObjects("rbxassetid://117302516345882")[1]
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
local function EV(script)
	local char = script.Parent
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	local Animator = req("Animator")
	local animator = Animator.new(humanoid)
	animator.AnimationMode = Animator.AnimationMode.C0
	humanoid.WalkSpeed = 22
	humanoid.JumpPower = 50
	local abi = false
	local isemoting = false
	local cd = false
	local cameracframe = nil
	local islunging = false
	local ispacman = false
	local isverity = false
	local hollowpurpleassets = script:FindFirstChild("HollowEffects")
	if hollowpurpleassets then
		hollowpurpleassets.Parent = nil
	end
	local idle = animator:LoadAnimation(script:FindFirstChild("Idle"))
	local lunge = animator:LoadAnimation(script:FindFirstChild("Lunge"))
	local sixsevenanim = animator:LoadAnimation(script:FindFirstChild("67"))
	local purple = animator:LoadAnimation(script:FindFirstChild("purple"))
	local normalimages = {
		"rbxassetid://125885955387516",
		"rbxassetid://103101183170961",
		"rbxassetid://11710147805"
	}
	local verityimages = {
		"rbxassetid://139132255282154",
		"rbxassetid://76559707998422",
		"rbxassetid://138724178467824"
	}
	local normalverityimages = {
		"rbxassetid://120621676530648",
		"rbxassetid://113838091420033",
		"rbxassetid://114440432425085",
		"rbxassetid://105694612418085"
	}
	local normalimage = "rbxassetid://105646791909536"
	local sixseven = "rbxassetid://89522762006817"
	local lungeimage = "rbxassetid://90184823043048"
	task.spawn(function()
		while true do
			if isemoting then
				idle:Stop()
			end
			task.wait()
		end
	end)
	task.spawn(function()
		while true do
			if islunging then
				local sphere = Instance.new("Part")
				sphere.Shape = Enum.PartType.Ball
				sphere.Size = Vector3.new(15, 15, 15)
				if isverity then
					sphere.Color = Color3.fromRGB(255, 255, 0)
				else
					sphere.Color = Color3.fromRGB(0, 0, 0)
				end
				if ispacman then
					sphere.Color = Color3.fromRGB(255, 176, 0)
				end
				sphere.Material = Enum.Material.SmoothPlastic
				sphere.Name = "evil scary peak vfx"
				sphere.Anchored = true
				sphere.CanCollide = false
				sphere.Transparency = 0.8
				sphere.CFrame = root.CFrame
				sphere.Parent = workspace.Terrain
				game.Debris:AddItem(sphere, 0.2)
			end
			task.wait(0.015)
		end
	end)
	local function getcameradirection()
		if typeof(cameracframe) ~= "CFrame" then
			return nil
		end
		local direction = cameracframe.LookVector
		if direction.Magnitude < 0.001 then
			return nil
		end
		return direction.Unit
	end
	local function rebound()
		local direction = getcameradirection()
		if not direction then
			return
		end
		local backwards = - direction
		local originalpivot = char:GetPivot()
		local originalrotation = originalpivot - originalpivot.Position
		for i = 1, 15 do
			local currentpivot = char:GetPivot()
			local newposition = currentpivot.Position + backwards * 10
			char:PivotTo(CFrame.new(newposition) * originalrotation)
			task.wait()
		end
	end
	local function movemodel(direction, distance, rotatetodirection)
		if not direction then
			return false
		end
		local pivot = char:GetPivot()
		local position = pivot.Position
		local newposition = position + direction * distance
		if rotatetodirection then
			char:PivotTo(CFrame.lookAt(newposition, newposition + direction, Vector3.yAxis))
		else
			local rotationonly = pivot - pivot.Position
			char:PivotTo(CFrame.new(newposition) * rotationonly)
		end
		return true
	end
	game:GetService("RunService").Heartbeat:Connect(function(dt)
		if abi then return end
		if cd then return end
		if humanoid.MoveDirection.Magnitude > 0 then
			if math.random() < 0.05 then
				cd = true
				local direction = getcameradirection()
				if not direction then
					cd = false
					return
				end
				local billboard = char:FindFirstChild("Torso") and char.Torso:FindFirstChild("BillboardGui")
				if billboard then
					if isverity then
						billboard.ImageLabel.Image = normalverityimages[math.random(1, #normalverityimages)]
					elseif isemoting then
						billboard.ImageLabel.Image = sixseven
					else
						billboard.ImageLabel.Image = normalimages[math.random(1, #normalimages)]
					end
				end
				local movesound = ispacman and root:FindFirstChild("Move2") or root:FindFirstChild("Move")
				if movesound then
					local shortestdistance = math.huge
					for _, obj in ipairs(workspace:GetChildren()) do
						if obj ~= char and obj:IsA("Model") then
							local targetroot = obj:FindFirstChild("HumanoidRootPart")
							local targethumanoid = obj:FindFirstChildOfClass("Humanoid")
							if targetroot and targethumanoid and targethumanoid.Health > 0 then
								local dist = (root.Position - targetroot.Position).Magnitude
								if dist < shortestdistance then
									shortestdistance = dist
								end
							end
						end
					end
					local t = 1 - math.clamp((shortestdistance - 5) / (80 - 5), 0, 1)
					movesound.PlaybackSpeed = 1 + 0.5 * t
					movesound:Play()
				end
				movemodel(direction, 10, true)
				task.wait(0.15)
				cd = false
			end
		end
	end)
	idle:Play()
	rem.Six.OnServerEvent:Connect(function(player, mode, clientcamcf)
		if ispacman then return end
		if isverity then return end
		if clientcamcf and typeof(clientcamcf) == "CFrame" then
			cameracframe = clientcamcf
		end
		if mode == "6" then
			if not isemoting then
				local billboard = char:FindFirstChild("Torso") and char.Torso:FindFirstChild("BillboardGui")
				if billboard then
					billboard.Size = UDim2.new(9, 0, 9, 0)
					billboard.ImageLabel.Image = sixseven
				end
				idle:Stop()
				sixsevenanim:Play()
				local sixsound = root:FindFirstChild("SixSeven")
				if sixsound then sixsound:Play() end
				isemoting = true
			end
		end
		if mode == "7" then
			if isemoting then
				local billboard = char:FindFirstChild("Torso") and char.Torso:FindFirstChild("BillboardGui")
				if billboard then
					billboard.Size = UDim2.new(15, 0, 15, 0)
					billboard.ImageLabel.Image = normalimage
				end
				idle:Play()
				sixsevenanim:Stop()
				local sixsound = root:FindFirstChild("SixSeven")
				if sixsound then sixsound:Stop() end
				isemoting = false
			end
		end
	end)
	local function forward()
		for i = 1, 23 do
			local direction = getcameradirection()
			if direction then
				movemodel(direction, 1, true)
			end
			task.wait()
		end
	end
	local function hollowpurple(char)
		local var0 = char:FindFirstChild("HumanoidRootPart")
		if not var0 then
			return
		end
		local hollowpurple = hollowpurpleassets:Clone()
		local var1 = hollowpurple.Blue:Clone()
		var1.Weld.Part0 = var0
		var1.Parent = workspace.Terrain
		local var2 = hollowpurple.Red:Clone()
		var2.Weld.Part0 = var0
		var2.Parent = workspace.Terrain
		local var96 = {}
		var96.Transparency = 0
		game:GetService("TweenService"):Create(var2, TweenInfo.new(0.25), var96):Play()
		local var105 = {}
		var105.Brightness = 20
		game:GetService("TweenService"):Create(var1.PointLight, TweenInfo.new(0.25), var105):Play()
		local var114 = {}
		var114.Transparency = 0
		game:GetService("TweenService"):Create(var2, TweenInfo.new(0.25), var114):Play()
		local var123 = {}
		var123.Brightness = 20
		game:GetService("TweenService"):Create(var2.PointLight, TweenInfo.new(0.25), var123):Play()
		var1.Mid.Charge:Emit(2)
		var2.Mid.Charge:Emit(2)
		task.wait(0.25)
		var1.Material = Enum.Material.Granite
		var2.Material = Enum.Material.Granite
		local var158 = {}
		var158.C1 = CFrame.new(0, 0, 9)
		game:GetService("TweenService"):Create(var1.Weld, TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.In), var158):Play()
		local var173 = {}
		var173.C1 = CFrame.new(0, 0, -9) * CFrame.Angles(0, 3.141592653589793, 0)
		game:GetService("TweenService"):Create(var2.Weld, TweenInfo.new(1, Enum.EasingStyle.Circular, Enum.EasingDirection.In), var173):Play()
		task.wait(1)
		var1:Destroy()
		var2:Destroy()
		local upval1 = hollowpurple.PurpleProjectile:Clone()
		upval1.Weld.Part0 = var0
		upval1.Parent = workspace.Terrain
		local var203 = {}
		var203.Size = Vector3.new(15,15,15)
		game:GetService("TweenService"):Create(upval1, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), var203):Play()
		local var214 = {}
		var214.C1 = CFrame.new(0, 3, -13) * CFrame.Angles(0 , math.rad(180), 0)
		game:GetService("TweenService"):Create(upval1.Weld, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), var214):Play()
		local var229 = {}
		var229.Brightness = 10
		game:GetService("TweenService"):Create(upval1.PointLight, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), var229):Play()
		upval1.Anchored = false
		upval1.CFrame = CFrame.new(upval1.Position, upval1.Position + var0.CFrame.LookVector) * CFrame.new(0, 0, 20)
		return upval1
	end
	rem.Purple.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		idle:Stop()
		lunge:Stop()
		purple:Play()
		sixsevenanim:Stop()
		root:FindFirstChild("Purple"):Play()
		local purple2 = hollowpurple(char)
		if purple2 then
			if purple2:FindFirstChild("Weld") then
				purple2.Weld:Destroy()
			end
			purple2.Anchored = true
			task.wait(1.5)
			local movedir = root.CFrame.LookVector
			coroutine.wrap(function()
				local hitted = {}
				local active = true
				task.delay(3, function()
					active = false
				end)
				local connection
				connection = game:GetService("RunService").Heartbeat:Connect(function(dt)
					if not active or not purple2 or not purple2.Parent then
						connection:Disconnect()
						return
					end
					purple2.CFrame = purple2.CFrame + (movedir * (150 * dt))
					local overlapparams = OverlapParams.new()
					overlapparams.FilterDescendantsInstances = {char}
					overlapparams.FilterType = Enum.RaycastFilterType.Exclude
					for i, v in pairs(workspace:GetPartBoundsInRadius(purple2.Position, 10, overlapparams)) do
						if v.Parent and v.Parent:FindFirstChildWhichIsA("Humanoid") and v.Parent ~= char then
							local targetmodel = v.Parent
							if not table.find(hitted, targetmodel) then
								local primarypart = targetmodel.PrimaryPart or targetmodel:FindFirstChild("HumanoidRootPart")
								if primarypart then
									for _, part in pairs(targetmodel:GetDescendants()) do
										if part:IsA("BasePart") then
											if not string.find(part.Name, "Leg") then
												part.Transparency = 1
												part.CanCollide = false
											end
										end
									end
									targetmodel:FindFirstChildWhichIsA("Humanoid").Health = 0
									table.insert(hitted, targetmodel)
								end
							end
						end
					end
				end)
			end)()
			game:GetService("Debris"):AddItem(purple2, 3)
		end
		task.wait(1.167)
		if isemoting then
			sixsevenanim:Play()
			idle:Stop()
		else
			idle:Play()
		end
		abi = false
	end)
	rem.Verity.OnServerEvent:Connect(function(player, mode)
		if ispacman then return end
		if isemoting then return end
		if mode == "verify" then
			if not isverity then
				local billboard = char:FindFirstChild("Torso") and char.Torso:FindFirstChild("BillboardGui")
				if billboard then
					billboard.ImageLabel.Image = normalverityimages[math.random(1, #normalverityimages)]
					billboard.ImageLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
				end
				isverity = true
				local veritysound = root:FindFirstChild("Verity")
				if veritysound then veritysound:Play() end
				for _, parts in ipairs(char:GetDescendants()) do
					if parts:IsA("BasePart") and parts.Name ~= "HumanoidRootPart" then
						parts.Color = Color3.fromRGB(255, 255, 0)
					end
				end
			end
		end
		if mode == "verity" then
			if isverity then
				local billboard = char:FindFirstChild("Torso") and char.Torso:FindFirstChild("BillboardGui")
				if billboard then
					billboard.ImageLabel.Image = normalimages[math.random(1, #normalimages)]
					billboard.ImageLabel.ImageColor3 = Color3.fromRGB(255, 0, 0)
				end
				isverity = false
				local veritysound = root:FindFirstChild("Verity")
				if veritysound then veritysound:Stop() end
				for _, parts in ipairs(char:GetDescendants()) do
					if parts:IsA("BasePart") and parts.Name ~= "HumanoidRootPart" then
						parts.Color = Color3.fromRGB(0, 0, 0)
					end
				end
			end
		end
	end)
	rem.Lunge.OnServerEvent:Connect(function(player, mouseposition, clientcamcf)
		if abi then return end
		abi = true
		if clientcamcf and typeof(clientcamcf) == "CFrame" then
			cameracframe = clientcamcf
		end
		idle:Stop()
		lunge:AdjustSpeed(0.2)
		if isemoting then
			sixsevenanim:Play()
		else
			lunge:Play()
			sixsevenanim:Stop()
		end
		rebound()
		local billboard = char:FindFirstChild("Torso") and char.Torso:FindFirstChild("BillboardGui")
		if billboard then
			if isemoting then
				billboard.ImageLabel.Image = sixseven
			else
				billboard.ImageLabel.Image = lungeimage
			end
			if isverity then
				billboard.ImageLabel.Image = verityimages[math.random(1, #verityimages)]
			end
		end
		islunging = true
		idle:Stop()
		local function playflighteffects()
			local flight = ispacman and root:FindFirstChild("Flight2") or root:FindFirstChild("Flight")
			local flightstart = root:FindFirstChild("FlightStart")
			if flight then flight:Play() end
			if flightstart then flightstart:Play() end
			if billboard then
				if isemoting then
					billboard.ImageLabel.Image = sixseven
				else
					billboard.ImageLabel.Image = normalimages[math.random(1, #normalimages)]
					billboard.Size = UDim2.new(15, 0, 15, 0)
				end
				if isverity then
					billboard.ImageLabel.Image = verityimages[math.random(1, #verityimages)]
				end
			end
		end
		playflighteffects()
		forward()
		rebound()
		task.wait(1)
		lunge:Stop()
		idle:Play()
		task.wait(0.2)
		lunge:Play()
		idle:Stop()
		playflighteffects()
		forward()
		rebound()
		task.wait(1)
		lunge:Stop()
		idle:Play()
		task.wait(0.2)
		playflighteffects()
		lunge:Play()
		idle:Stop()
		forward()
		rebound()
		root:FindFirstChild("FlightStart"):Play()
		task.wait(0.5)
		islunging = false
		local flight = ispacman and root:FindFirstChild("Flight2") or root:FindFirstChild("Flight")
		if flight then flight:Stop() end
		if billboard then
			if isemoting then
				billboard.ImageLabel.Image = sixseven
			else
				billboard.ImageLabel.Image = normalimage
				billboard.Size = UDim2.new(15, 0, 15, 0)
			end
			if isverity then
				billboard.ImageLabel.Image = normalverityimages[math.random(1, #normalverityimages)]
			end
		end
		idle:Play()
		lunge:Stop()
		abi = false
	end)
	rem.Lunge2.OnServerEvent:Connect(function(player, mouseposition, clientcamcf)
		if abi then return end
		abi = true
		local seconds = 1
		if clientcamcf and typeof(clientcamcf) == "CFrame" then
			cameracframe = clientcamcf
		end
		idle:Stop()
		if isemoting then
			sixsevenanim:Play()
		else
			lunge:Play()
			sixsevenanim:Stop()
		end
		local lungesound = ispacman and root:FindFirstChild("Lunge4") or root:FindFirstChild("Lunge")
		if lungesound then lungesound:Play() end
		local lungesound2 = root:FindFirstChild("Lunge2")
		if lungesound2 then lungesound2:Play() end
		local billboard = char:FindFirstChild("Torso") and char.Torso:FindFirstChild("BillboardGui")
		if billboard then
			if isemoting then
				billboard.ImageLabel.Image = sixseven
			else
				billboard.ImageLabel.Image = lungeimage
			end
			if isverity then
				billboard.ImageLabel.Image = verityimages[math.random(1, #verityimages)]
			end
		end
		task.wait(3)
		islunging = true
		idle:Stop()
		local l3 = ispacman and root:FindFirstChild("Lunge5") or root:FindFirstChild("Lunge3")
		if l3 then l3:Play() end
		local function playflighteffects()
			local move = ispacman and root:FindFirstChild("Move2") or root:FindFirstChild("Move")
			local shortestdistance = math.huge
			for _, obj in ipairs(workspace:GetChildren()) do
				if obj ~= char and obj:IsA("Model") then
					local targetroot = obj:FindFirstChild("HumanoidRootPart")
					local targethumanoid = obj:FindFirstChildOfClass("Humanoid")
					if targetroot and targethumanoid and targethumanoid.Health > 0 then
						local dist = (root.Position - targetroot.Position).Magnitude
						if dist < shortestdistance then
							shortestdistance = dist
						end
					end
				end
			end
			local t = 1 - math.clamp((shortestdistance - 5) / (80 - 5), 0, 1)
			move.PlaybackSpeed = 1 + 0.5 * t
			move:Play()
			if move then move:Play() end
			if billboard then
				if isemoting then
					billboard.ImageLabel.Image = sixseven
				else
					billboard.ImageLabel.Image = "rbxassetid://125885955387516"
					billboard.Size = UDim2.new(15, 0, 15, 0)
				end
				if isverity then
					billboard.ImageLabel.Image = verityimages[math.random(1, #verityimages)]
				end
			end
		end
		for i = 1, 20 do
			playflighteffects()
			movemodel(getcameradirection(), 15, true)
			local a, b = pcall(function()
				lunge:AdjustSpeed(1. + 5)
			end)
			task.wait(seconds)
			seconds -= 0.1
		end
		task.wait(0.25)
		islunging = false
		if l3 then l3:Stop() end
		if billboard then
			if isemoting then
				billboard.ImageLabel.Image = sixseven
			else
				billboard.ImageLabel.Image = normalimage
				billboard.Size = UDim2.new(15, 0, 15, 0)
			end
			if isverity then
				billboard.ImageLabel.Image = normalverityimages[math.random(1, #normalverityimages)]
			else
				billboard.ImageLabel.Image = normalimage
			end
		end
		idle:Play()
		lunge:Stop()
		abi = false
	end)
	rem.Pac.OnServerEvent:Connect(function(player, mode)
		if isemoting then return end
		if isverity then return end
		if mode == "on" then
			if not ispacman then
				ispacman = true
				char:FindFirstChild("Torso").Transparency = 1
				char:FindFirstChild("LeftHand").Transparency = 1
				char:FindFirstChild("RightHand").Transparency = 1
				char:FindFirstChild("Torso").Pac.Transparency = 0
				char:FindFirstChild("Torso"):FindFirstChild("BillboardGui").Enabled = false
			end
		end
		if mode == "off" then
			if ispacman then
				ispacman = false
				char:FindFirstChild("Torso").Transparency = 0
				char:FindFirstChild("LeftHand").Transparency = 0
				char:FindFirstChild("RightHand").Transparency = 0
				char:FindFirstChild("Torso").Pac.Transparency = 1
				char:FindFirstChild("Torso"):FindFirstChild("BillboardGui").Enabled = true
			end
		end
	end)
	rem.Camera.OnServerEvent:Connect(function(player, action, data)
		if action == "aim" then
			if typeof(data) ~= "CFrame" then
				return
			end
			cameracframe = data
			return
		end
	end)
end
local function LS(script)
	local uis = game:GetService("UserInputService")
	local cas = game:GetService("ContextActionService")
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local player = Players.LocalPlayer
	local camera = workspace.CurrentCamera
	local mouse = player:GetMouse()
	local isemoting = false
	local isverity = false
	local ispacman = false

	local function activate(actionname)
		camera = workspace.CurrentCamera
		if actionname == "lunge" then
			if camera then rem.Lunge:FireServer(mouse.Hit.Position, camera.CFrame) end
		elseif actionname == "lunge2" then
			if camera then rem.Lunge2:FireServer(mouse.Hit.Position, camera.CFrame) end
		elseif actionname == "emote" then
			isemoting = not isemoting
			rem.Six:FireServer(isemoting and "6" or "7", camera and camera.CFrame)
		elseif actionname == "verity" then
			isverity = not isverity
			rem.Verity:FireServer(isverity and "verify" or "verity")
		elseif actionname == "purple" then
			rem.Purple:FireServer()
		elseif actionname == "pacman" then
			ispacman = not ispacman
			rem.Pac:FireServer(ispacman and "on" or "off")
		end
	end

	local keybinds = {
		lunge = Enum.KeyCode.Q,
		lunge2 = Enum.KeyCode.E,
		emote = Enum.KeyCode.R,
		verity = Enum.KeyCode.T,
		purple = Enum.KeyCode.Y,
		pacman = Enum.KeyCode.U
	}

	local function handlekeybind(actionname, inputstate)
		if inputstate == Enum.UserInputState.Begin then
			activate(actionname)
		end
		return Enum.ContextActionResult.Pass
	end

	for actionname, keycode in pairs(keybinds) do
		cas:BindAction("EvilScary_" .. actionname, handlekeybind, false, keycode)
	end

	local playerGui = player:WaitForChild("PlayerGui")
	local oldGui = playerGui:FindFirstChild("EvilScaryMobileControls")
	if oldGui then oldGui:Destroy() end

	local gui = Instance.new("ScreenGui")
	gui.Name = "EvilScaryMobileControls"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 100
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = playerGui

	local panel = Instance.new("Frame")
	panel.Name = "AbilityPanel"
	panel.AnchorPoint = Vector2.new(1, 0.5)
	panel.Position = UDim2.new(1, -14, 0.58, 0)
	panel.Size = UDim2.fromOffset(154, 250)
	panel.BackgroundColor3 = Color3.fromRGB(19, 17, 23)
	panel.BackgroundTransparency = 0.16
	panel.BorderSizePixel = 0
	panel.Parent = gui

	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 12)
	panelCorner.Parent = panel

	local panelStroke = Instance.new("UIStroke")
	panelStroke.Color = Color3.fromRGB(135, 72, 90)
	panelStroke.Transparency = 0.25
	panelStroke.Thickness = 1.3
	panelStroke.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -12, 0, 27)
	title.Position = UDim2.fromOffset(6, 4)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.Text = "EVIL SCARY"
	title.TextColor3 = Color3.fromRGB(255, 226, 231)
	title.TextSize = 13
	title.Parent = panel

	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "Buttons"
	buttonContainer.Position = UDim2.fromOffset(0, 33)
	buttonContainer.Size = UDim2.new(1, 0, 1, -33)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = panel

	panel.Visible = true
	panel.Active = true
	panel.ZIndex = 20
	title.ZIndex = 22

	local buttonsFrame = Instance.new("Frame")
	buttonsFrame.Name = "Buttons"
	buttonsFrame.Position = UDim2.fromOffset(5, 34)
	buttonsFrame.Size = UDim2.new(1, -10, 1, -39)
	buttonsFrame.BackgroundTransparency = 1
	buttonsFrame.BorderSizePixel = 0
	buttonsFrame.Visible = true
	buttonsFrame.ZIndex = 21
	buttonsFrame.Parent = panel

	local list = Instance.new("UIGridLayout")
	list.CellSize = UDim2.new(0.5, -4, 0, 58)
	list.CellPadding = UDim2.fromOffset(6, 6)
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.VerticalAlignment = Enum.VerticalAlignment.Top
	list.StartCorner = Enum.StartCorner.TopLeft
	list.Parent = buttonsFrame

	local abilities = {
		{ id = "lunge", label = "LUNGE", key = "Q" },
		{ id = "lunge2", label = "LUNGE 2", key = "E" },
		{ id = "emote", label = "EMOTE", key = "R" },
		{ id = "verity", label = "VERITY", key = "T" },
		{ id = "purple", label = "PURPLE", key = "Y" },
		{ id = "pacman", label = "PAC-MAN", key = "U" }
	}

	local function updateToggleLabels()
		for _, child in ipairs(panel:GetChildren()) do
			if child:IsA("TextButton") then
				if child.Name == "emote" then
					child.Text = (isemoting and "EMOTE: ON" or "EMOTE") .. "\n[R]"
				elseif child.Name == "verity" then
					child.Text = (isverity and "VERITY: ON" or "VERITY") .. "\n[T]"
				elseif child.Name == "pacman" then
					child.Text = (ispacman and "PAC-MAN: ON" or "PAC-MAN") .. "\n[U]"
				end
			end
		end
	end

	for index, ability in ipairs(abilities) do
		local button = Instance.new("TextButton")
		button.Name = ability.id
		button.LayoutOrder = index
		button.AutoButtonColor = false
		button.BackgroundColor3 = Color3.fromRGB(57, 36, 47)
		button.BorderSizePixel = 0
		button.Font = Enum.Font.GothamBold
		button.Text = ability.label .. "\n[" .. ability.key .. "]"
		button.TextColor3 = Color3.fromRGB(255, 241, 244)
		button.TextSize = 11
		button.TextWrapped = true
		button.Visible = true
		button.ZIndex = 22
		button.Parent = buttonsFrame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = button

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(156, 85, 108)
		stroke.Transparency = 0.35
		stroke.Thickness = 1
		stroke.Parent = button

		button.Activated:Connect(function()
			activate(ability.id)
			updateToggleLabels()
			TweenService:Create(button, TweenInfo.new(0.08), {
				BackgroundColor3 = Color3.fromRGB(104, 49, 68)
			}):Play()
			task.delay(0.1, function()
				if button.Parent then
					TweenService:Create(button, TweenInfo.new(0.12), {
						BackgroundColor3 = Color3.fromRGB(57, 36, 47)
					}):Play()
				end
			end)
		end)
	end

	local dragging = false
	local dragStart
	local startPosition
	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPosition = panel.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	uis.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
			local delta = input.Position - dragStart
			panel.Position = UDim2.new(
				startPosition.X.Scale, startPosition.X.Offset + delta.X,
				startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
			)
		end
	end)

	task.spawn(function()
		while script.Parent do
			camera = workspace.CurrentCamera
			if camera then
				rem.Camera:FireServer("aim", camera.CFrame)
			end
			task.wait(0.03)
		end
	end)
end
local function CM(script)
	local camera = workspace.CurrentCamera
	local humanoid = script.Parent:WaitForChild("Humanoid")
	camera.CameraType = Enum.CameraType.Custom
	camera.CameraSubject = humanoid
end
local function TS(script)
	local scream = script:FindFirstChild("Scream")
	local gui = script:WaitForChild("Jumpscare")
	local debounce = {}
	script.Parent.Touched:Connect(function(hit)
		local character = hit:FindFirstAncestorOfClass("Model")
		if not character then
			return
		end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then
			return
		end
		if debounce[character] then
			return
		end
		debounce[character] = true
		local scream = scream:Clone()
		scream.PlaybackSpeed = math.random(90, 125) / 100
		scream.Parent = character.PrimaryPart
		scream:Play()
		game:GetService("Debris"):AddItem(scream, scream.TimeLength)
		humanoid.Health = 0
		local player = game:GetService("Players"):GetPlayerFromCharacter(character)
		if player then
			local playergui = player:FindFirstChildOfClass("PlayerGui")
			if playergui then
				local jumpscareclone = gui:Clone()
				jumpscareclone.Parent = playergui
				game:GetService("Debris"):AddItem(jumpscareclone, 5.5)
			end
		end
		task.delay(1, function()
			debounce[character] = nil
		end)
	end)
end
local function evilscary(playername)
	local player = game:GetService("Players"):FindFirstChild(playername)
	if not player then return end
	local random = math.random(1, 2)
	local rig = G:FindFirstChild("Evil Scary"):Clone()
	local start = CFrame.new(0, 32, 0)
	if player.Character then
		start = player.Character:GetPivot()
	end
	rig:PivotTo(start * CFrame.new(0, 2.9, 0))
	rig.Name = player.Name
	player.Character = rig
	local camerathing = G:FindFirstChild("camera"):Clone()
	camerathing.Parent = rig
	rig.Humanoid.DisplayName = player.Name
	rem = {}
	for _, n in ipairs({"Six", "Purple", "Verity", "Lunge", "Lunge2", "Pac", "Camera"}) do
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
	task.defer(EV, rig.EvilScript)
	task.defer(LS, rig.LocalScript)
	task.defer(CM, camerathing)
	task.defer(TS, rig.Torso:FindFirstChildOfClass("Script"))
	local m = Instance.new("Message", workspace)
	m.Text = "IT IS EVIL AND SCARY"
	game.Debris:AddItem(m, 4)
end
evilscary(LP.Name)
