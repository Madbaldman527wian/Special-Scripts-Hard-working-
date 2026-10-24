local A = game:GetObjects("rbxassetid://80759949348591")[1]
local I = A:FindFirstChildWhichIsA("ModuleScript", true)

local C = {}
local M = {}
local Z = {}
local H

local function rq(m)
	local e = C[m]
	if e then
		return e.v
	end
	local f = M[m.Name]
	if f and m:IsA("ModuleScript") then
		e = {}
		C[m] = e
		e.v = f(m)
		return e.v
	end
	return require(m)
end

M.Hitboxes = function(script)
	local hitboxes = {
		KillSound = script.Kill
	}

	function hitboxes.TeammateDeath()
	
		local killsfx = script.Kill:Clone()
		killsfx.PlayOnRemove = true
		killsfx.Parent = workspace
		killsfx:Destroy()
	end

	function hitboxes.createHitbox(Table: {})
		local part = Instance.new("Part")
		part.Anchored = true
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
		part.Material = Enum.Material.ForceField
		part.Color = Color3.new(1, 0.25, 0.25)
		part.Size = Table.Size
		part.CFrame = Table.CFrame
		part.Shape = Table.Shape or Enum.PartType.Block
		part.Transparency = (game:GetService("RunService"):IsStudio() or workspace:GetAttribute("VisibleHitboxesEnabled")) and 0 or 1
		part.Parent = workspace.Terrain
		game:GetService("Debris"):AddItem(part, 1)
	
		local hum: Humanoid = Table.Attacker:FindFirstChildOfClass("Humanoid")
		if hum and Table.Predict then
			local plr = game:GetService("Players"):GetPlayerFromCharacter(hum.Parent)
		
			local velunit = hum.RootPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1)
			if velunit.Magnitude < 1 then
				velunit = Vector3.zero
			end
			if velunit.Magnitude > 0 then
				velunit = velunit.Unit
			end
		
			local z = hum.RootPart.CFrame.LookVector:Dot(velunit)
		
			local add = Vector3.zero
			if z > 0.1 then
				add = hum.RootPart.CFrame.LookVector * 4
			end
		
			if plr then
				local s, ping = pcall(plr.GetNetworkPing, plr)
				if not s then
					ping = 0
				end
			
				add += hum.RootPart.CFrame.LookVector * math.clamp(ping * 25, 0, 4)
			end
		
			part.Position += add
		end
	
		local op = OverlapParams.new()
		op.FilterType = Enum.RaycastFilterType.Exclude
		op.CollisionGroup = "Killer"
	
		local humanoids = {}
		for _, v in pairs(workspace:GetPartsInPart(part, op)) do
			local hum = v.Parent:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 and not table.find(humanoids, hum) then
				table.insert(humanoids, hum)
			
				local mult = 1
				if hum.Parent:GetAttribute("Critical") then
					mult *= 1.25
				end
			
				if Table.Attacker:GetAttribute("Critical") then
					mult *= 1.25
				end
			
				hum:TakeDamage(math.round(Table.Damage * mult))
				hum.Health = math.clamp(hum.Health, 0, hum.MaxHealth)
				if hum.Health <= 0 then
					if hum.Parent:FindFirstChild("Head") then
						hitboxes.TeammateDeath()
					end
				end
			
				part.Color = Color3.new(0.25, 1, 0.25)
			end
		end
	
		return humanoids
	end

	return hitboxes
end

M.Abilities = function(script)
	local hitboxes = rq(script.Hitboxes.Value)

	local transparencyThread: thread

	local function addspeed(rig: Model, speed: number)
		rig:SetAttribute("SpeedModifier", (rig:GetAttribute("SpeedModifier") or 0) + speed)
	end

	return {
		Swing = {
			Name = "Swing",
			Icon = "rbxassetid://86297288069487",
			Cooldown = 1,
			Keybind = Enum.UserInputType.MouseButton1,
			LayoutOrder = 1,
			Callback = function(rig: Model)
				rig:SetAttribute("AbilityDisabled", true)
				addspeed(rig, 10)
				task.delay(1, function()
					rig:SetAttribute("AbilityDisabled", nil)
				end)

				firesignal(rig.PlayAnim.OnClientEvent, "Swing")

				rig.PrimaryPart.Swing:Play()

				task.delay(0.2, function()
					addspeed(rig, -10)

					for i = 2, 0, -2/7 do
						local humanoids = hitboxes.createHitbox({
							Size = Vector3.new(5, 6, 6),
							CFrame = rig.PrimaryPart.CFrame * CFrame.new(0, 0, -3 + i),
							Damage = 20,
							Predict = true,
							Attacker = rig
						})

						if #humanoids > 0 then
							rig.PrimaryPart.Hit:Play()
							break
						end

						task.wait(0.025)
					end
				end)
			end,
		},
		Cleave = {
			Name = "Cleave",
			Icon = "rbxassetid://92447235780730",
			Cooldown = 20,
			Keybind = Enum.KeyCode.Q,
			LayoutOrder = 1,
			Callback = function(rig: Model)
				rig:SetAttribute("AbilityDisabled", true)
				addspeed(rig, 10)
			
				firesignal(rig.PlayAnim.OnClientEvent, "Cleave")
			
				rig.PrimaryPart.Cleave:Play()
			
				rig.Dagger.Transparency = 0
				rig.BackDagger.Transparency = 1
			
				task.delay(0.5, function()
					addspeed(rig, -10)
				
					for i = 2, 0, -2/7 do
						local humanoids = hitboxes.createHitbox({
							Size = Vector3.new(4, 1, 6),
							CFrame = rig.PrimaryPart.CFrame * CFrame.new(0, 0, -3 + i),
							Damage = 20,
							Predict = true,
							Attacker = rig
						})
					
						if #humanoids > 0 then
							rig.PrimaryPart.CleaveHit:Play()
							break
						end
					
						task.wait(1/14)
					end
				
					rig.PrimaryPart.CleaveEnd:Play()
					rig.PrimaryPart.CleaveEnd2:Play()
				
					firesignal(rig.StopAnim.OnClientEvent, "Cleave")
					firesignal(rig.PlayAnim.OnClientEvent, "CleaveEnd")
				
					addspeed(rig, -4)
					rig:SetAttribute("SprintingDisabled", true)
					task.delay(2, function()
						addspeed(rig, 4)
					
						firesignal(rig.StopAnim.OnClientEvent, "Cleave")
					
						rig:SetAttribute("AbilityDisabled", false)
						rig:SetAttribute("SprintingDisabled", false)
					
						rig.Dagger.Transparency = 1
						rig.BackDagger.Transparency = 0
					end)
				end)
			end,
		},
		Howl = {
			Name = "Howl",
			Icon = "rbxassetid://121485044324107",
			Cooldown = 35,
			Keybind = Enum.KeyCode.E,
			LayoutOrder = 3,
			Callback = function(rig: Model)
				rig:SetAttribute("AbilityDisabled", true)
				addspeed(rig, -100)
				task.delay(2, function()
					rig:SetAttribute("AbilityDisabled", false)
					addspeed(rig, 100)
				end)
			
				firesignal(rig.PlayAnim.OnClientEvent, "Howl")
			
				rig.Head.Howl.PE.Enabled = true
				rig.Head.Howl.PE2.Enabled = true
				task.delay(2, function()
					rig.Head.Howl.PE.Enabled = false
					rig.Head.Howl.PE2.Enabled = false
				end)
			
				rig.PrimaryPart.Howl:Play()
				rig.PrimaryPart.Howl2:Play()
			end,
		},
		Stalk = {
			Name = "Stalk",
			Icon = "rbxassetid://92577246919936",
			Cooldown = 0,
			Keybind = Enum.KeyCode.R,
			LayoutOrder = 4,
			Callback = function(rig: Model, plr: Player)
				local partblacklist = {
					"Dagger",
					"Face",
					"HumanoidRootPart"
				}
			
				if not rig:GetAttribute("Stalked") then
					rig:SetAttribute("Stalked", true)
				
					addspeed(rig, -100)
				
					firesignal(rig.SetCooldown.OnClientEvent, "Stalk", 2.5)
				
					local stalkSound: {Sound} = {rig.PrimaryPart.Stalk, rig.PrimaryPart.Stalk2, rig.PrimaryPart.Stalk3, rig.PrimaryPart.Stalk4}
					for _, v in pairs(stalkSound) do
						v.Volume = 1
						v:Play()
					end
				
					rig.PrimaryPart.Stalk.PlaybackSpeed = 1
					task.delay(0.5, function()
						game:GetService("TweenService"):Create(rig.PrimaryPart.Stalk, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {PlaybackSpeed = 0.25, Volume = 0}):Play()
					end)
				
					firesignal(rig.PlayAnim.OnClientEvent, "Stalk")
					task.delay(2.5, function()
						firesignal(rig.PlayAnim.OnClientEvent, "StalkWalk")
						addspeed(rig, 120)
					
						rig.PrimaryPart.Stalk:Stop()
					end)
				
					if transparencyThread then
						task.cancel(transparencyThread)
					end
					transparencyThread = task.delay(2.5, function()
						for i = 1, 10 do
							for _, v in pairs(rig:GetDescendants()) do
								if v:IsA("BasePart") then
									if table.find(partblacklist, v.Name) then
										v.Transparency = 1
									else
										v.Transparency = i/10
									end
								elseif v:IsA("Decal") then
									v.Transparency = i/10
								end
							end
							task.wait(0.1)
						end
					end)
				else
					rig:SetAttribute("AbilityDisabled", true)
					addspeed(rig, -120)
					rig:SetAttribute("Stalked", nil)
				
					firesignal(rig.SetCooldown.OnClientEvent, "Stalk", 15)
				
					if transparencyThread then
						task.cancel(transparencyThread)
					end
					transparencyThread = task.spawn(function()
						for i = 19, 0, -1 do
							for _, v in pairs(rig:GetDescendants()) do
								if v:IsA("BasePart") then
									if table.find(partblacklist, v.Name) then
										v.Transparency = 1
									else
										v.Transparency = i/20
									end
								elseif v:IsA("Decal") then
									v.Transparency = i/20
								end
							end
							task.wait(0.1)
						end
					end)
				
					task.delay(2, function()
						firesignal(rig.StopAnim.OnClientEvent, "StalkWalk")
					
						rig:SetAttribute("AbilityDisabled", false)
						addspeed(rig, 100)
					end)
				end
			end,
		}
	}
end

M.Animator = function(script)
	local animator = {}
	animator.__index = animator

	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")

	animator.Animations = {}

	function animator.LoadAnimation(rig: Model, keyframeSequence: KeyframeSequence)
		local self = setmetatable({}, animator)
		self.name = keyframeSequence.Name
		self.looped = keyframeSequence.Loop
		self.speed = 1
		self.isPlaying = false
		self.timePosition = 0
		self.weight = Instance.new("NumberValue")
		self.fadeTime = 0.1
	
		self.priority = keyframeSequence.Priority
		self.keyframes = keyframeSequence:GetChildren()
		table.sort(self.keyframes, function(a, b)
			return a.Time < b.Time
		end)
	
		self.length = self.keyframes[#self.keyframes].Time
	
		self.joints = {}
		for _, v in pairs(rig:GetDescendants()) do
			if v:IsA("Motor6D") and v.Part1 then
				self.joints[v.Part1.Name] = v
			end
		end
	
		task.spawn(function()
			while true do
				local dt = RunService.PreSimulation:Wait()
				if not self.isPlaying then
					continue
				end
				self.timePosition += dt * self.speed
				if self.timePosition >= self.length then
					if not self.looped then
						self.timePosition = self.length
						self:Stop()
					else
						self.timePosition = self.timePosition%self.length
					end
				end
			end
		end)
	
		if not animator.Animations[rig] then
			animator.Animations[rig] = {}
		
			task.spawn(function()
				while rig.Parent do
					RunService.PreSimulation:Wait()
				
					if animator.Animations[rig].stopped then
						continue
					end
				
					table.sort(animator.Animations[rig], function(a, b)
						return a.priority.Value < b.priority.Value
					end)
				
					for _, anim in pairs(animator.Animations[rig]) do
						if typeof(anim) ~= "table" then
							continue
						end
					
						for jointName, joint in pairs(anim.joints) do
							local thethingthingything = math.clamp(anim.timePosition, anim.keyframes[1].Time, anim.keyframes[#anim.keyframes].Time)
						
							local selected: Keyframe
							local selectedIndex = 1
							for index, keyframe: Keyframe in pairs(anim.keyframes) do
								if keyframe.Time < thethingthingything and keyframe:FindFirstChild(jointName, true) then
									selected = keyframe
									selectedIndex = index
								end
							end
							if not selected then
								selected = anim.keyframes[1]
							end
						
							if selected then
								local pose = selected:FindFirstChild(jointName, true)
								if not pose or not pose:IsA("Pose") then
									continue
								end
							
								local nextKeyframe: Keyframe
								local nextPose: Pose
								local counter = 1
								repeat
									nextKeyframe = anim.keyframes[selectedIndex+counter]
									if not nextKeyframe then
										break
									end
								
									nextPose = nextKeyframe:FindFirstChild(jointName, true)
								
									counter += 1
								until nextPose and nextPose:IsA("Pose")
							
								if not nextPose then
									continue
								end
							
								local alpha = 1
								if pose.EasingStyle ~= Enum.PoseEasingStyle.Constant then
									local old = pose.EasingStyle
									local easingStyle: Enum.EasingStyle
									if pose.EasingStyle == Enum.PoseEasingStyle.CubicV2 then
										easingStyle = Enum.EasingStyle.Cubic
									else
										easingStyle = Enum.EasingStyle:FromName(pose.EasingStyle.Name)
									end
								
									alpha = TweenService:GetValue(
										math.clamp((anim.timePosition-nextKeyframe.Time)/(selected.Time-nextKeyframe.Time), 0, 1),
										easingStyle,
										Enum.EasingDirection:FromName(pose.EasingDirection.Name)
									)
								end
							
								joint.Transform = joint.Transform:Lerp(pose.CFrame:Lerp(nextPose.CFrame, alpha), anim.weight.Value)
							end
						end
					end
				end
			end)
		end
		table.insert(animator.Animations[rig], self)
	
		return self
	end

	function animator:Play(fadeTime: number)
		self.fadeTime = fadeTime or self.fadeTime
	
		if not self.looped then
			self.timePosition = 0
		end
		self.isPlaying = true
		game:GetService("TweenService"):Create(self.weight, TweenInfo.new(self.fadeTime, Enum.EasingStyle.Linear), {Value = 1}):Play()
	end

	function animator:Stop(fadeTime: number)
		self.fadeTime = fadeTime or self.fadeTime
	
		self.isPlaying = false
		game:GetService("TweenService"):Create(self.weight, TweenInfo.new(self.fadeTime, Enum.EasingStyle.Linear), {Value = 0}):Play()
	end

	return animator
end

Z.Abilities = function(script)
	local currentPlr = game:GetService("Players"):GetPlayerFromCharacter(script.Parent)

	local abilities = rq(script.Abilities)

	H = function(abilityName: string)
		local plr = game:GetService("Players").LocalPlayer
		if currentPlr ~= plr then
			return false
		end

		if not plr.Character or plr.Character:GetAttribute("AbilityDisabled") then
			return false
		end

		if not abilities[abilityName] then
			return false
		end

		if abilityName ~= "Stalk" and plr.Character:GetAttribute("Stalked") then
			return false
		end

		abilities[abilityName].Callback(script.Parent, plr)
		return true
	end

	for _, v in pairs(abilities) do
		firesignal(script.Parent.the.RemoteEvent.OnClientEvent, v)
	end
end

Z.Animate = function(script)
	local hum = script.Parent:WaitForChild("Humanoid")
	local animator = rq(script:WaitForChild("Animator"))

	local animations = {}
	for _, v in pairs(script.Parent:WaitForChild("Animations"):GetChildren()) do
		if v:IsA("KeyframeSequence") then
			animations[v.Name] = animator.LoadAnimation(script.Parent, v)
		end
	end
	script.Parent.Animations.ChildAdded:Connect(function(v: Instance)
		if v:IsA("KeyframeSequence") then
			animations[v.Name] = animator.LoadAnimation(script.Parent, v)
		end
	end)

	animations.Idle:Play()

	hum.Running:Connect(function(speed)
		local walkSpeed = script.Parent:GetAttribute("WalkSpeed") or 8
		local sprintSpeed = script.Parent:GetAttribute("SprintSpeed") or 26
	
		animations.Walk.speed = speed/walkSpeed
		animations.Sprint.speed = speed/sprintSpeed
	
		if speed > 0 then
			if speed > sprintSpeed-walkSpeed then
				animations.Walk:Stop()
				animations.Sprint:Play()
			else
				animations.Sprint:Stop()
				animations.Walk:Play()
			end
			animations.Idle:Stop()
		else
			animations.Idle.timePosition = 0
			animations.Idle:Play()
			animations.Walk:Stop()
			animations.Sprint:Stop()
		end
	end)

	local stalkWalk = false
	script.Parent:WaitForChild("PlayAnim").OnClientEvent:Connect(function(animName: string)
		if animName == "StalkWalk" then
			animator.Animations[script.Parent].stopped = true
		
			stalkWalk = true
		end
	
		if animations[animName] then
			animations[animName]:Play()
		end
	end)

	script.Parent:WaitForChild("StopAnim").OnClientEvent:Connect(function(animName: string)
		if animName == "StalkWalk" then
			animator.Animations[script.Parent].stopped = false
		
			stalkWalk = false
		end
	
		if animations[animName] then
			animations[animName]:Stop()
		end
	end)

	game:GetService("RunService").PreSimulation:Connect(function()
		if not stalkWalk then
			return
		end
	
		local torso = script.Parent:FindFirstChild("Torso")
		local ls = torso and torso:FindFirstChild("Left Shoulder")
		local rs = torso and torso:FindFirstChild("Right Shoulder")
		local lh = torso and torso:FindFirstChild("Left Hip")
		local rh = torso and torso:FindFirstChild("Right Hip")
		local neck = torso and torso:FindFirstChild("Neck")
	
		if ls then
			ls.Transform = CFrame.Angles(0, 0, -math.pi/2)
		end
		if rs then
			rs.Transform = CFrame.Angles(0, 0, math.pi/2)
		end
		if lh then
			lh.Transform = CFrame.identity
		end
		if rh then
			rh.Transform = CFrame.identity
		end
		if neck then
			neck.Transform = CFrame.identity
		end
	end)
end

Z.SongHandler = function(script)
	local Players = game:GetService("Players")

	local rigPlr = game:GetService("Players"):GetPlayerFromCharacter(script.Parent)

	local chaseTheme = script.Parent:WaitForChild("Animations"):WaitForChild("ChaseTheme")

	while task.wait(0.5) do
		if script.Parent:GetAttribute("Stalked") then
			chaseTheme:Pause()
			continue
		end
	
		if Players:GetPlayerFromCharacter(script.Parent) == Players.LocalPlayer then
			chaseTheme:Resume()
			continue
		end
	
		local char = Players.LocalPlayer.Character
		if char then
			local range = 50
			if chaseTheme.IsPlaying then
				range += 30
			end
		
			local dist = Players.LocalPlayer:DistanceFromCharacter(script.Parent.PrimaryPart.Position)
			if dist > range then
				chaseTheme:Pause()
			else
				if (range/2) >= dist then
					chaseTheme.Volume = 1
				else
					chaseTheme.Volume = 1 - dist/80
				end
				chaseTheme:Resume()
			end
		end
	end
end

Z.the = function(script)
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")

	local gui = script:WaitForChild("ScreenGui")
	local template = script:WaitForChild("AbilityTemplate")

	local abilities = {}

	RunService.RenderStepped:Connect(function(dt)
		for _, v in pairs(abilities) do
			v.C00ldown = math.max(v.C00ldown - dt, 0)
		
			if v.C00ldown > 0 then
				v.Container.Icon.ImageColor3 = Color3.fromRGB(90, 90, 90)
				v.Container.CooldownLabel.Text = string.format("%.1fs", v.C00ldown)
			else
				v.Container.Icon.ImageColor3 = Color3.new(1, 1, 1)
				v.Container.CooldownLabel.Text = ""
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		if not gpe then
			for _, v in pairs(abilities) do
				if v.C00ldown <= 0 and (v.Keybind == input.KeyCode or v.Keybind == input.UserInputType) then
					local boolean = H(v.Name)
					if boolean then
						v.C00ldown = v.Cooldown
					end
				end
			end
		end
	end)

	script:WaitForChild("RemoteEvent").OnClientEvent:Connect(function(ability: {})
		local the = template:Clone()
		the.Name = ability.Name
		the.Title.Text = ability.Name
		the.Icon.Image = ability.Icon
		the.Input.Text = ability.Keybind.Name == "MouseButton1" and "M1" or ability.Keybind.Name
		the.CooldownLabel.Visible = true
		the.CooldownLabel.Text = ""
		the.LayoutOrder = ability.LayoutOrder
		the.Parent = gui.Abilities.Folder
	
		ability.C00ldown = 0
		ability.Container = the
		table.insert(abilities, ability)
	
		the.MouseButton1Click:Connect(function()
			if ability.C00ldown <= 0 then
				local boolean = H(ability.Name)
				if boolean then
					ability.C00ldown = ability.Cooldown
				end
			end
		end)
	end)

	script.Parent:WaitForChild("SetCooldown").OnClientEvent:Connect(function(abilityName: string, cooldown: number)
		for _, v in pairs(abilities) do
			if v.Name == abilityName then
				v.C00ldown = cooldown
				break
			end
		end
	end)

	gui.Parent = game.Players.LocalPlayer.PlayerGui
end

Z.sprinting = function(script)
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")

	local hum = script.Parent:WaitForChild("Humanoid")

	RunService.Heartbeat:Connect(function()
		local speedmod = script.Parent:GetAttribute("SpeedModifier") or 0
		local isSprinting = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
		if hum.MoveDirection.Magnitude == 0 or script.Parent:GetAttribute("SprintingDisabled") then
			isSprinting = false
		end
	
		local walkSpeed = script.Parent:GetAttribute("WalkSpeed") or 8
		local sprintSpeed = script.Parent:GetAttribute("SprintSpeed") or 26
	
		if isSprinting then
			hum.WalkSpeed = sprintSpeed + speedmod
			TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.5), {FieldOfView = 80}):Play()
		else
			hum.WalkSpeed = walkSpeed + speedmod
			TweenService:Create(workspace.CurrentCamera, TweenInfo.new(0.5), {FieldOfView = 70}):Play()
		end
	end)

	game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")
		:WaitForChild("CameraModule")
		:WaitForChild("MouseLockController")
		:WaitForChild("BoundKeys").Value = "LeftControl,RightControl"
end

local PhysicsService = game:GetService("PhysicsService")
pcall(function()
	PhysicsService:RegisterCollisionGroup("Killer")
end)
pcall(function()
	PhysicsService:CollisionGroupSetCollidable("Killer", "Killer", false)
end)

local function U(plrName: string)
	local plr: Player = game.Players:FindFirstChild(plrName)
	if plr and plr.Character then
		local rig = I.PursuerDefault:Clone()
		rig.Name = plr.Name

		rig.Humanoid.MaxHealth = 1000
		rig.Humanoid.Health = rig.Humanoid.MaxHealth
		rig.Humanoid.JumpPower = 0

		rig:SetAttribute("WalkSpeed", 10)
		rig:SetAttribute("SprintSpeed", 27)

		rig.Dagger.Transparency = 1

		rig:PivotTo(plr.Character.PrimaryPart.CFrame)
		plr.Character = rig
		rig.Parent = workspace

		for _, v in pairs(rig:GetChildren()) do
			if v:IsA("BaseScript") and v.Name ~= "Abilities" then
				local f = Z[v.Name]
				if f then
					task.spawn(f, v)
				end
			end
		end
		for _, v in pairs(rig:GetChildren()) do
			if v:IsA("BaseScript") and v.Name == "Abilities" then
				local f = Z[v.Name]
				if f then
					task.spawn(f, v)
				end
			end
		end

		task.spawn(function()
			for i = 1, 10 do
				for _, v in pairs(rig:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CollisionGroup = "Killer"
					end
				end
				task.wait(0.1)
			end
		end)
	end
end

U(game:GetService("Players").LocalPlayer.Name)
