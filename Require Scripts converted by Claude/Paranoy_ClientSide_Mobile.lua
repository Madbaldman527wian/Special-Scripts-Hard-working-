local A = game:GetObjects("rbxassetid://80759949348591")[1]
local I = A:FindFirstChildWhichIsA("ModuleScript", true)

local C = {}
local M = {}
local Z = {}

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
				local ping = plr:GetNetworkPing()

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
	local linked: Humanoid

	local hitboxes = rq(script.Hitboxes.Value)

	local function addspeed(rig: Model, speed: number)
		rig:SetAttribute("SpeedModifier", (rig:GetAttribute("SpeedModifier") or 0) + speed)
	end

	return {}
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

	for _, v in pairs(abilities) do
		script.Parent.the.RemoteEvent:FireClient(currentPlr, v)
	end
end

Z.Animate = function(script)
	local hum = script.Parent:WaitForChild("Humanoid")
	local animator = rq(script:WaitForChild("Animator"))

	local animations = {}
	for _, v in pairs(script.Parent.Animations:GetChildren()) do
		if v:IsA("KeyframeSequence") then
			animations[v.Name] = animator.LoadAnimation(script.Parent, v)
		end
	end

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

	script.Parent:WaitForChild("PlayAnim").OnClientEvent:Connect(function(animName: string)
		animations[animName]:Play()
	end)
end

Z.SongHandler = function(script)
	local Players = game:GetService("Players")

	local rigPlr = game:GetService("Players"):GetPlayerFromCharacter(script.Parent)

	local chaseTheme: Sound = script.Parent:WaitForChild("Animations"):WaitForChild("ChaseTheme")

	while task.wait(0.5) do
		if not Players.LocalPlayer.Character then
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
	local GuiService = game:GetService("GuiService")

	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

	local gui = script:WaitForChild("ScreenGui")
	local template = script:WaitForChild("AbilityTemplate")

	local abilities = {}

	-- Ajustes de layout para mobile
	if isMobile then
		local abilitiesFolder = gui:FindFirstChild("Abilities")
		if abilitiesFolder then
			-- Posiciona as habilidades na parte inferior da tela (melhor para polegar)
			if abilitiesFolder:IsA("Frame") or abilitiesFolder:IsA("ScrollingFrame") then
				abilitiesFolder.AnchorPoint = Vector2.new(0.5, 1)
				abilitiesFolder.Position = UDim2.new(0.5, 0, 1, -20)
				abilitiesFolder.Size = UDim2.new(0.95, 0, 0.18, 0)
			end

			local folder = abilitiesFolder:FindFirstChild("Folder")
			if folder and folder:IsA("UIListLayout") == false then
				local list = folder:FindFirstChildOfClass("UIListLayout")
				if list then
					list.Padding = UDim.new(0, 12)
					list.HorizontalAlignment = Enum.HorizontalAlignment.Center
				end
			end
		end
	end

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
					local boolean = script.Parent.Abilities.RemoteFunction:InvokeServer(v.Name)
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

		-- Texto do input adaptado para mobile
		if isMobile then
			the.Input.Text = "TAP"
			-- Deixa o botão maior e mais fácil de tocar
			the.Size = UDim2.new(0, 90, 0, 90)
			if the:FindFirstChild("UICorner") then
				the.UICorner.CornerRadius = UDim.new(0, 12)
			end
		else
			the.Input.Text = ability.Keybind.Name == "MouseButton1" and "M1" or ability.Keybind.Name
		end

		the.CooldownLabel.Visible = true
		the.CooldownLabel.Text = ""
		the.LayoutOrder = ability.LayoutOrder
		the.Parent = gui.Abilities.Folder

		ability.C00ldown = 0
		ability.Container = the
		table.insert(abilities, ability)

		-- Clique / toque funciona tanto no PC quanto no mobile
		the.MouseButton1Click:Connect(function()
			if ability.C00ldown <= 0 then
				local boolean = script.Parent.Abilities.RemoteFunction:InvokeServer(ability.Name)
				if boolean then
					ability.C00ldown = ability.Cooldown
				end
			end
		end)
	end)

	gui.Parent = game.Players.LocalPlayer.PlayerGui
end

Z.sprinting = function(script)
	local RunService = game:GetService("RunService")
	local TweenService = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local Players = game:GetService("Players")

	local hum = script.Parent:WaitForChild("Humanoid")
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

	-- Estado de sprint controlado pelo botão mobile (hold)
	local mobileSprinting = false

	-- Cria botão de Sprint para mobile
	if isMobile then
		local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

		local mobileGui = Instance.new("ScreenGui")
		mobileGui.Name = "MobileControls"
		mobileGui.ResetOnSpawn = false
		mobileGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		mobileGui.Parent = playerGui

		local sprintBtn = Instance.new("TextButton")
		sprintBtn.Name = "SprintButton"
		sprintBtn.Size = UDim2.new(0, 80, 0, 80)
		sprintBtn.Position = UDim2.new(1, -100, 1, -180) -- canto inferior direito
		sprintBtn.AnchorPoint = Vector2.new(0, 0)
		sprintBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		sprintBtn.BackgroundTransparency = 0.3
		sprintBtn.Text = "SPRINT"
		sprintBtn.TextColor3 = Color3.new(1, 1, 1)
		sprintBtn.TextScaled = true
		sprintBtn.Font = Enum.Font.GothamBold
		sprintBtn.AutoButtonColor = false
		sprintBtn.Parent = mobileGui

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 16)
		corner.Parent = sprintBtn

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(255, 255, 255)
		stroke.Thickness = 2
		stroke.Transparency = 0.5
		stroke.Parent = sprintBtn

		-- Hold para sprintar
		sprintBtn.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				mobileSprinting = true
				sprintBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 80)
				sprintBtn.BackgroundTransparency = 0.1
			end
		end)

		sprintBtn.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				mobileSprinting = false
				sprintBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				sprintBtn.BackgroundTransparency = 0.3
			end
		end)

		-- Caso o dedo saia da tela sem soltar
		UserInputService.TouchEnded:Connect(function()
			if mobileSprinting then
				mobileSprinting = false
				sprintBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
				sprintBtn.BackgroundTransparency = 0.3
			end
		end)
	end

	RunService.Heartbeat:Connect(function()
		local speedmod = script.Parent:GetAttribute("SpeedModifier") or 0

		local isSprinting = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or mobileSprinting

		if hum.MoveDirection.Magnitude == 0 then
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

	-- Só aplica o MouseLock no PC
	if not isMobile then
		pcall(function()
			game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule")
				:WaitForChild("CameraModule")
				:WaitForChild("MouseLockController")
				:WaitForChild("BoundKeys").Value = "LeftControl,RightControl"
		end)
	end
end

local PhysicsService = game:GetService("PhysicsService")
pcall(function()
	PhysicsService:RegisterCollisionGroup("Killer")
end)
pcall(function()
	PhysicsService:CollisionGroupSetCollidable("Killer", "Killer", false)
end)

local function P(plrName: string)
	local plr: Player = game.Players:FindFirstChild(plrName)
	if plr and plr.Character then
		local rig = I.Paranoy:Clone()
		rig.Name = plr.Name

		rig.Humanoid.MaxHealth = 9999
		rig.Humanoid.Health = rig.Humanoid.MaxHealth
		rig.Humanoid.JumpPower = 0

		rig:SetAttribute("WalkSpeed", 10)
		rig:SetAttribute("SprintSpeed", 34)

		for _, v: Instance in pairs(rig.Accessories.Wall:GetDescendants()) do
			if v:IsA("BasePart") or v:IsA("Decal") or v:IsA("Texture") then
				v.Transparency = 1
			elseif v:IsA("SurfaceGui") then
				v.Enabled = false
			end
		end

		rig:PivotTo(plr.Character.PrimaryPart.CFrame)
		plr.Character = rig
		rig.Parent = workspace

		for _, v in pairs(rig:GetChildren()) do
			if v:IsA("BaseScript") then
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

P(game:GetService("Players").LocalPlayer.Name)
