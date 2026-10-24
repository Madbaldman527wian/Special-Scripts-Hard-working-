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
local function FS(script)
	local flowery = script.Parent
	local humanoid = flowery:WaitForChild("Humanoid")
	local root = flowery:WaitForChild("HumanoidRootPart")
	flowery:FindFirstChild("Flowery"):Play()
	local plr = game:GetService("Players"):GetPlayerFromCharacter(flowery)
	local Animator = req("Animator")
	local animator = Animator.new(humanoid)
	animator.AnimationMode = Animator.AnimationMode.C0
	local afterimagestemplates = script:FindFirstChild("Afterimage")
	if afterimagestemplates then
		afterimagestemplates.Parent = nil
	end
	local jaronas = {
		"rbxassetid://70749527021215",
		"rbxassetid://132159994399077",
		"rbxassetid://107428258752104",
		"rbxassetid://120347973175811"
	}
	local function playrandomjarona()
		local randomindex = math.random(1, #jaronas)
		local sound = script.lines.jarona
		sound.SoundId = jaronas[randomindex]
		sound.Volume = 3
		sound:Play()
	end
	local abi = false
	local anims = {
		punchmiss = animator:LoadAnimation(script.PunchMis),
		punchhit = animator:LoadAnimation(script.PunchStartMArtist),
		quickattack = animator:LoadAnimation(script.QuickAttack),
		idle = animator:LoadAnimation(script.idle),
		run = animator:LoadAnimation(script.run),
		walk = animator:LoadAnimation(script.walk),
		ravagestartup = animator:LoadAnimation(script.RavageStartUp),
		ravageplayer = animator:LoadAnimation(script.RavagePlayer),
	}
	local endtask = nil
	local talkbox = flowery.Head.Talkbox.TextLabel
	local function say(text,forceline)
		if endtask ~= nil then
			task.cancel(endtask)
		end
		local makenoise = true
		if text == "J- ust kidding" then
			makenoise = false
			script.lines["just kidding"]:Play()
		elseif forceline ~= nil then
			makenoise = false
			script.lines[forceline]:Play()
		else
			for i,v in script.lines:GetChildren() do
				if string.match(string.lower(text),string.lower(v.Name)) ~= nil then
					if makenoise == true then
						makenoise = false
						if text == "Jarona!" then
							playrandomjarona()
						else
							v:Play()
						end
					end
				end
			end
		end
		talkbox.Text = "* "
		for i=1, string.len(text) do
			talkbox.Text = "* "..string.sub(text,1,i)
			if makenoise then
				local sounds = script.gibberish:GetChildren()
				sounds[math.random(1,#sounds)]:Play()
			end
			if string.sub(text,i,i) == "!" or string.sub(text,i,i) == "?" or string.sub(text,i,i) == "." then
				task.wait(0.3)
			elseif string.sub(text,i,i) == ";" or string.sub(text,i,i) == ":" or string.sub(text,i,i) == "," then
				task.wait(0.15)
			else
				task.wait(0.05)
			end
		end
		task.delay(3,function()
			talkbox.Text = ""
		end)
	end
	plr.Chatted:Connect(say)
	local function ragdoll(character, duration)
		local hum = character:FindFirstChildOfClass("Humanoid")
		if not hum or hum.PlatformStand then return end
		local ragdollJoints = {}
		for _, motor in ipairs(character:GetDescendants()) do
			if motor:IsA("Motor6D") then
				local part0, part1 = motor.Part0, motor.Part1
				if part0 and part1 then
					local attachment0 = Instance.new("Attachment", part0)
					attachment0.CFrame = motor.C0
					local attachment1 = Instance.new("Attachment", part1)
					attachment1.CFrame = motor.C1
					local ball = Instance.new("BallSocketConstraint")
					ball.Attachment0 = attachment0
					ball.Attachment1 = attachment1
					ball.LimitsEnabled = true
					ball.TwistLimitsEnabled = true
					ball.Parent = part0
					table.insert(ragdollJoints, {motor = motor, ball = ball, a0 = attachment0, a1 = attachment1})
					motor.Enabled = false
				end
			end
		end
		hum.PlatformStand = true
		task.delay(duration, function()
			if hum and hum.Parent and hum.Health > 0 then
				for _, data in ipairs(ragdollJoints) do
					if data.motor and data.motor.Parent then
						data.motor.Enabled = true
					end
					if data.ball then data.ball:Destroy() end
					if data.a0 then data.a0:Destroy() end
					if data.a1 then data.a1:Destroy() end
				end
				hum.PlatformStand = false
			end
		end)
	end
	rem.jarona3.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		humanoid.WalkSpeed = 0
		anims.idle:Stop()
		anims.run:Stop()
		anims.ravagestartup.TimePosition = 0
		anims.ravagestartup:Play()
		local isjarona = false
		local afterimages = true
		playrandomjarona()
		task.spawn(function()
			while afterimages do
				task.wait(0.001)
				for i, v in ipairs(flowery:GetChildren()) do
					if v:IsA("BasePart") and v.Transparency ~= 1 and v.Name ~= "HumanoidRootPart" then
						local afterimages2 = Instance.new("Part")
						afterimagespart.CFrame = v.CFrame
						afterimagespart.Anchored = true
						afterimagespart.CanCollide = false
						afterimagespart.Material = Enum.Material.Neon
						afterimagespart.Color = Color3.new(0, 0.45098, 1)
						afterimagespart.Parent = workspace
						local tweeninf = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
						game.TweenService:Create(afterimagespart, tweeninf, {Transparency = 1}):Play()
						game.Debris:AddItem(afterimagespart, 0.25)
					end
				end
			end
		end)
		task.wait(0.5)
		local jaronapart = flowery:FindFirstChild("JARONA3")
		if jaronapart then
			jaronapart.CanTouch = true
			local connection
			connection = jaronapart.Touched:Connect(function(hit)
				if isjarona then return end
				local hitcharacter = hit.Parent
				if hitcharacter == flowery or hitcharacter == workspace then return end
				local hithumanoid = hitcharacter:FindFirstChildOfClass("Humanoid")
				if not hithumanoid then return end
				isjarona = true
				if connection and connection.Connected then connection:Disconnect() end
				jaronapart.CanTouch = false
				afterimages = false
				anims.ravagestartup:Stop()
				local hitroot = hitcharacter:FindFirstChild("HumanoidRootPart")
				if hitroot then
					local victimanimator = Animator.new(hithumanoid)
					victimanimator.AnimationMode = Animator.AnimationMode.C0
					if script:FindFirstChild("RavageVictim") then
						local victimanim = victimanimator:LoadAnimation(script.RavageVictim)
						victimanim:Play()
					end
					hitroot.CFrame = root.CFrame * CFrame.new(0, 0, -2.5)
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = root
					weld.Part1 = hitroot
					weld.Parent = root
					root.Anchored = true
					hithumanoid.WalkSpeed = 0
					hithumanoid.JumpPower = 0
					humanoid.JumpPower = 0
					humanoid.WalkSpeed = 0
					anims.ravageplayer:Play()
					task.wait(0.79)
					hithumanoid:TakeDamage(35)
					local hit1Sound = root:FindFirstChild("hit1")
					if hit1Sound then hit1Sound:Play() end
					for _, v in ipairs(root.MULTIJARONAHIT:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(6)
						end
					end
					task.wait(0.4)
					hithumanoid:TakeDamage(35)
					local hit1sound2 = root:FindFirstChild("hit1")
					if hit1sound2 then hit1sound2:Play() end
					for _, v in ipairs(root.REGULARJARONAHIT:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(6)
						end
					end
					task.wait(1)
					for i = 1, 55 do
						task.wait()
						local damageindicatorgui = Instance.new("BillboardGui")
						damageindicatorgui.AlwaysOnTop = true
						damageindicatorgui.Size = UDim2.new(1.5, 0, 1.5, 0)
						local offsetX = math.random(-10, 10)/10
						local offsetY = math.random(-10, 10)/10
						local offsetZ = math.random(-10, 10)/10
						damageindicatorgui.StudsOffset = Vector3.new(offsetX, offsetY, offsetZ)
						local damageindicatorlabel = Instance.new("TextLabel")
						damageindicatorlabel.AnchorPoint = Vector2.new(0.5, 0.5)
						damageindicatorlabel.Position = UDim2.new(0.5, 0, 0.5, 0)
						damageindicatorlabel.TextScaled = true
						damageindicatorlabel.TextColor3 = Color3.fromRGB(255, 0, 0)
						damageindicatorlabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
						damageindicatorlabel.TextStrokeTransparency = 0
						damageindicatorlabel.BackgroundTransparency = 1
						damageindicatorlabel.Font = Enum.Font.Arcade
						damageindicatorlabel.Text = "-999"
						damageindicatorlabel.Size = UDim2.new(0, 0, 0, 0)
						damageindicatorlabel.Parent = damageindicatorgui
						damageindicatorgui.Parent = hitroot
						damageindicatorlabel:TweenSize(UDim2.new(1, 0, 1, 0), "InOut", "Quint", 0.3)
						game.Debris:AddItem(damageindicatorgui, 0.3)
						local soundclone = root:FindFirstChild("hit1")
						if soundclone then
							local sound2 = soundclone:Clone()
							sound2.Parent = root
							sound2:Play()
							game.Debris:AddItem(sound2, sound2.TimeLength + 0.5)
						end
						hithumanoid:TakeDamage(1)
						for _, v in ipairs(root.MULTIJARONAHIT:GetDescendants()) do
							if v:IsA("ParticleEmitter") then
								v:Emit(6)
							end
						end
					end
					task.wait(1)
					hithumanoid:TakeDamage(10)
					for _, v in ipairs(root.MULTIJARONAHIT:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(6)
						end
					end
					task.wait(0.13)
					for i,v in pairs(root.MULTIJARONAHIT:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(v:GetAttribute("EmitCount"))
						end
					end
					local hit1Sound3 = root:FindFirstChild("hit1")
					if hit1Sound3 then hit1Sound3:Play() end
					task.wait(0.46)
					hithumanoid:TakeDamage(100)
					for i,v in pairs(root.FINALJARONA:GetDescendants()) do
						if v:IsA("ParticleEmitter") then
							v:Emit(v:GetAttribute("EmitCount"))
						end
					end
					local hit1Sound4 = root:FindFirstChild("hit1")
					if hit1Sound4 then hit1Sound4:Play() end
					task.wait(1.25)
					isjarona = false
					if weld and weld.Parent then weld:Destroy() end
					if hitroot and hitroot.Parent then hitroot.Anchored = false end
					if root and root.Parent then root.Anchored = false end
					if hitroot and hitroot.Parent then
						hitroot.AssemblyLinearVelocity = Vector3.new(math.random(-10, 10), math.random(0, 10), math.random(-10, 10))
					end
					ragdoll(hitcharacter, 5)
					humanoid.WalkSpeed = 26
					humanoid.JumpPower = 50
					abi = false
				end
			end)
			task.wait(1.25)
			if connection and connection.Connected then
				connection:Disconnect()
			end
			jaronapart.CanTouch = false
			afterimages = false
			if not isjarona then
				anims.ravagestartup:Stop()
				abi = false
				humanoid.WalkSpeed = 26
				humanoid.JumpPower = 50
			end
		end
	end)
	rem.jarona.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		local isjarona = false
		local afterimages = true
		task.spawn(function()
			while afterimages do
				task.wait(0.001)
				for i, v in ipairs(flowery:GetChildren()) do
					if v:IsA("BasePart") and v.Transparency ~= 1 and v.Name ~= "HumanoidRootPart" then
						local afterimages2 = Instance.new("Part")
						afterimagespart.CFrame = v.CFrame
						afterimagespart.Anchored = true
						afterimagespart.CanCollide = false
						afterimagespart.Material = Enum.Material.Neon
						afterimagespart.Color = Color3.new(0, 0.45098, 1)
						afterimagespart.Parent = workspace
						local tweeninf = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
						game.TweenService:Create(afterimagespart, tweeninf, {Transparency = 1}):Play()
						game.Debris:AddItem(afterimagespart, 0.25)
					end
				end
			end
		end)
		local bv = Instance.new("BodyVelocity")
		bv.Velocity = root.CFrame.LookVector * 100
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Parent = root
		game.Debris:AddItem(bv, 0.2)
		anims.idle:Stop()
		anims.run:Stop()
		anims.walk:Stop()
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		anims.punchmiss:Play()
		playrandomjarona()
		local jaronapart = flowery:FindFirstChild("JARONA")
		if jaronapart then
			jaronapart.CanTouch = true
			local connection
			connection = jaronapart.Touched:Connect(function(hit)
				if isjarona then return end
				local hitcharacter = hit.Parent
				if hitcharacter == flowery or hitcharacter == workspace then return end
				local hithumanoid = hitcharacter:FindFirstChildOfClass("Humanoid")
				if not hithumanoid then return end
				isjarona = true
				if connection and connection.Connected then connection:Disconnect() end
				jaronapart.CanTouch = false
				local hitroot = hitcharacter:FindFirstChild("HumanoidRootPart")
				if hitroot then
					hitroot.CFrame = root.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0)
					local weld = Instance.new("WeldConstraint")
					weld.Part0 = root
					weld.Part1 = hitroot
					weld.Parent = root
					hithumanoid.WalkSpeed = 0
					hithumanoid.JumpPower = 0
					hitroot.Anchored = true
					root.Anchored = true
					humanoid.JumpPower = 0
					humanoid.WalkSpeed = 0
					local damagetask = task.spawn(function()
						while isjarona and hithumanoid and hithumanoid.Parent and hithumanoid.Health > 0 do
							hithumanoid:TakeDamage(5)
							task.wait(1)
							if not isjarona then break end
							hithumanoid:TakeDamage(20)
							task.wait(1)
							if not isjarona then break end
							hithumanoid:TakeDamage(35)
						end
					end)
					anims.punchhit:Play()
					local victimanimator = Animator.new(hithumanoid)
					victimanimator.AnimationMode = Animator.AnimationMode.C0
					if script:FindFirstChild("PunchStartEnemy") then
						local victimanim = victimanimator:LoadAnimation(script.PunchStartEnemy)
						victimanim:Play()
					end
					root:FindFirstChild("hit2"):Play()
					task.wait(1.75)
					isjarona = false
					task.cancel(damagetask)
					if weld and weld.Parent then weld:Destroy() end
					if hitroot and hitroot.Parent then hitroot.Anchored = false end
					if root and root.Parent then root.Anchored = false end
					if hitroot and hitroot.Parent then
						hitroot.AssemblyLinearVelocity = Vector3.new(math.random(-10, 10), math.random(0, 10), math.random(-10, 10))
					end
					ragdoll(hitcharacter, 5)
					humanoid.WalkSpeed = 26
					humanoid.JumpPower = 50
					abi = false
				end
			end)
			task.wait(1.25)
			if connection and connection.Connected then
				connection:Disconnect()
			end
			jaronapart.CanTouch = false
			afterimages = false
		end
		if abi then
			anims.idle:Play()
			humanoid.WalkSpeed = 26
			humanoid.JumpPower = 50
			abi = false
		end
	end)
	rem.jarona2.OnServerEvent:Connect(function(player)
		if abi then return end
		abi = true
		local isjarona2 = false
		local afterimages = true
		task.spawn(function()
			while afterimages do
				task.wait(0.001)
				for i, v in ipairs(flowery:GetChildren()) do
					if v:IsA("BasePart") and v.Transparency ~= 1 and v.Name ~= "HumanoidRootPart" then
						local afterimages2 = Instance.new("Part")
						afterimagespart.CFrame = v.CFrame
						afterimagespart.Anchored = true
						afterimagespart.CanCollide = false
						afterimagespart.Material = Enum.Material.Neon
						afterimagespart.Color = Color3.new(0, 0.45098, 1)
						afterimagespart.Parent = workspace
						local tweeninf = TweenInfo.new(0.25, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, 0, false, 0)
						game.TweenService:Create(afterimagespart, tweeninf, {Transparency = 1}):Play()
						game.Debris:AddItem(afterimagespart, 0.25)
					end
				end
			end
		end)
		local bv = Instance.new("BodyVelocity")
		bv.Velocity = root.CFrame.LookVector * 100
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bv.Parent = root
		game.Debris:AddItem(bv, 0.2)
		anims.idle:Stop()
		anims.run:Stop()
		anims.walk:Stop()
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		anims.quickattack:Play()
		playrandomjarona()
		local jarona2part = flowery:FindFirstChild("JARONA2")
		if jarona2part then
			jarona2part.CanTouch = true
			local connection
			connection = jarona2part.Touched:Connect(function(hit)
				if isjarona2 then return end
				local hitcharacter = hit.Parent
				if hitcharacter == flowery or hitcharacter == workspace then return end
				local hithumanoid = hitcharacter:FindFirstChildOfClass("Humanoid")
				if not hithumanoid then return end
				isjarona2 = true
				if connection and connection.Connected then connection:Disconnect() end
				jarona2part.CanTouch = false
				local hitroot = hitcharacter:FindFirstChild("HumanoidRootPart")
				if hitroot then
					hitroot.AssemblyLinearVelocity = Vector3.new(math.random(-10, 10), math.random(0, 10), math.random(-10, 10))
				end
				hithumanoid:TakeDamage(45)
				for k, d in ipairs(root.REGULARJARONAHIT:GetDescendants()) do
					if d:IsA("ParticleEmitter") then
						d:Emit(6)
					end
				end
				root:FindFirstChild("hit1"):Play()
				ragdoll(hitcharacter, 3)
			end)
			task.wait(1.59)
			if connection and connection.Connected then
				connection:Disconnect()
			end
			jarona2part.CanTouch = false
			afterimages = false
		end
		anims.idle:Play()
		humanoid.WalkSpeed = 26
		humanoid.JumpPower = 50
		abi = false
	end)
	humanoid.Running:Connect(function(speed)
		if abi then return end
		if speed > 0 then
			anims.idle:Stop()
			anims.run:Play()
		else
			anims.idle:Play()
			anims.run:Stop()
		end
	end)
	task.spawn(function()
		local RainbowHighlight = flowery:FindFirstChild("RainbowHighlight")
		local v1 = 0
		while true do
			v1 = (v1 + task.wait() * 0.3) % 1
			local _, v2, v3 = RainbowHighlight.FillColor:ToHSV()
			RainbowHighlight.FillColor = Color3.fromHSV(v1, v2, v3)
		end
	end)
	humanoid.WalkSpeed = 26
end
local function FL(script)
	local contextactionservice = game:GetService("ContextActionService")
	local players = game:GetService("Players")
	local tweenservice = game:GetService("TweenService")
	local player = players.LocalPlayer

	local function activate(actioname)
		if actioname == "punchaction" then
			rem.jarona:FireServer()
		elseif actioname == "quickhitaction" then
			rem.jarona2:FireServer()
		elseif actioname == "superdeathkillcomboaction" then
			rem.jarona3:FireServer()
		end
	end

	local function handlekeybinds(actioname, inputstate)
		if inputstate == Enum.UserInputState.Begin then
			activate(actioname)
		end
		return Enum.ContextActionResult.Pass
	end

	contextactionservice:BindAction("punchaction", handlekeybinds, false, Enum.KeyCode.E)
	contextactionservice:BindAction("quickhitaction", handlekeybinds, false, Enum.KeyCode.Q)
	contextactionservice:BindAction("superdeathkillcomboaction", handlekeybinds, false, Enum.KeyCode.R)

	local playerGui = player:WaitForChild("PlayerGui")
	local oldGui = playerGui:FindFirstChild("FloweryMobileControls")
	if oldGui then
		oldGui:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "FloweryMobileControls"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 10000
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Enabled = true
	gui.Parent = playerGui

	local panel = Instance.new("Frame")
	panel.Name = "AbilityPanel"
	panel.AnchorPoint = Vector2.new(1, 0.5)
	panel.Position = UDim2.new(1, -14, 0.58, 0)
	panel.Size = UDim2.fromOffset(164, 208)
	panel.BackgroundColor3 = Color3.fromRGB(18, 20, 31)
	panel.BackgroundTransparency = 0.1
	panel.BorderSizePixel = 0
	panel.Visible = true
	panel.Active = true
	panel.ZIndex = 20
	panel.Parent = gui

	local panelCorner = Instance.new("UICorner")
	panelCorner.CornerRadius = UDim.new(0, 13)
	panelCorner.Parent = panel

	local panelStroke = Instance.new("UIStroke")
	panelStroke.Color = Color3.fromRGB(75, 155, 255)
	panelStroke.Transparency = 0.15
	panelStroke.Thickness = 1.5
	panelStroke.Parent = panel

	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Position = UDim2.fromOffset(6, 4)
	title.Size = UDim2.new(1, -12, 0, 28)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.Text = "FLOWERY"
	title.TextColor3 = Color3.fromRGB(225, 240, 255)
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.ZIndex = 22
	title.Parent = panel

	local buttonsFrame = Instance.new("Frame")
	buttonsFrame.Name = "Buttons"
	buttonsFrame.Position = UDim2.fromOffset(7, 36)
	buttonsFrame.Size = UDim2.new(1, -14, 1, -43)
	buttonsFrame.BackgroundTransparency = 1
	buttonsFrame.BorderSizePixel = 0
	buttonsFrame.Visible = true
	buttonsFrame.ZIndex = 21
	buttonsFrame.Parent = panel

	local list = Instance.new("UIListLayout")
	list.Padding = UDim.new(0, 7)
	list.FillDirection = Enum.FillDirection.Vertical
	list.HorizontalAlignment = Enum.HorizontalAlignment.Center
	list.VerticalAlignment = Enum.VerticalAlignment.Top
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Parent = buttonsFrame

	local abilities = {
		{id = "punchaction", label = "PUNCH", key = "E"},
		{id = "quickhitaction", label = "QUICK HIT", key = "Q"},
		{id = "superdeathkillcomboaction", label = "SUPER DEATH KILL", key = "R"}
	}

	for index, ability in ipairs(abilities) do
		local button = Instance.new("TextButton")
		button.Name = ability.id
		button.LayoutOrder = index
		button.Size = UDim2.new(1, 0, 0, 49)
		button.BackgroundColor3 = Color3.fromRGB(32, 73, 125)
		button.BorderSizePixel = 0
		button.AutoButtonColor = false
		button.Font = Enum.Font.GothamBold
		button.Text = ability.label .. "\n[" .. ability.key .. "]"
		button.TextColor3 = Color3.fromRGB(255, 255, 255)
		button.TextSize = 12
		button.TextWrapped = true
		button.Visible = true
		button.Active = true
		button.Selectable = true
		button.ZIndex = 22
		button.Parent = buttonsFrame

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 9)
		corner.Parent = button

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(108, 185, 255)
		stroke.Transparency = 0.25
		stroke.Thickness = 1
		stroke.Parent = button

		button.Activated:Connect(function()
			activate(ability.id)
			tweenservice:Create(button, TweenInfo.new(0.08), {
				BackgroundColor3 = Color3.fromRGB(49, 118, 190)
			}):Play()
			task.delay(0.12, function()
				if button.Parent then
					tweenservice:Create(button, TweenInfo.new(0.12), {
						BackgroundColor3 = Color3.fromRGB(32, 73, 125)
					}):Play()
				end
			end)
		end)
	end

	local userinputservice = game:GetService("UserInputService")
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
	userinputservice.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
			local delta = input.Position - dragStart
			panel.Position = UDim2.new(
				startPosition.X.Scale, startPosition.X.Offset + delta.X,
				startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
			)
		end
	end)
end
local function flowery(playername)
	local player = game.Players:FindFirstChild(playername)
	if not player then return end
	local rig = G:FindFirstChild("flowery"):Clone()
	local start = CFrame.new(0, 32, 0)
	if player.Character then
		start = player.Character:GetPivot()
	end
	rig:PivotTo(start * CFrame.new(0, 2.9, 0))
	rig.Name = player.Name
	player.Character = rig
	rig.Humanoid.DisplayName = player.Name
	rem = {}
	for _, n in ipairs({"jarona", "jarona2", "jarona3"}) do
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
	task.defer(FS, rig.Script)
	task.defer(FL, rig.LocalScript)
end
flowery(LP.Name)
