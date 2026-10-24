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
	local linked: Humanoid

	local hitboxes = rq(script.Hitboxes.Value)

	local function addspeed(rig: Model, speed: number)
		rig:SetAttribute("SpeedModifier", (rig:GetAttribute("SpeedModifier") or 0) + speed)
	end

	return {
		Swing = {
			Name = "Swing",
			Icon = "rbxassetid://79789896606805",
			Cooldown = 1,
			Keybind = Enum.UserInputType.MouseButton1,
			LayoutOrder = 1,
			Callback = function(rig: Model)
				rig:SetAttribute("AbilityDisabled", true)
				task.delay(1, function()
					rig:SetAttribute("AbilityDisabled", nil)
				end)

				firesignal(rig.PlayAnim.OnClientEvent, "Swing")

				rig.PrimaryPart.Swing:Play()

				addspeed(rig, 10)
				task.delay(0.2, function()
					addspeed(rig, -10)

					for i = 2, 0, -2/7 do
						local humanoids = hitboxes.createHitbox({
							Size = Vector3.new(5, 7.5, 6),
							CFrame = rig.PrimaryPart.CFrame * CFrame.new(0, -0.25, -3 + i),
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
		Agitation = {
			Name = "Agitation",
			Icon = "rbxassetid://119980024420991",
			Cooldown = 20,
			Keybind = Enum.KeyCode.Q,
			LayoutOrder = 2,
			Callback = function(rig: Model)
				rig:SetAttribute("AbilityDisabled", true)
				addspeed(rig, -100)

				firesignal(rig.PlayAnim.OnClientEvent, "Swing")

				rig.PrimaryPart.Slam:Play()
				rig.PrimaryPart["Slam1.5"]:Play()

				task.delay(1, function()
					rig.PrimaryPart.Slam2:Play()
					rig.PrimaryPart.Slam3:Play()

					task.delay(0.5, function()
						rig:SetAttribute("AbilityDisabled", nil)
						addspeed(rig, 100)
					end)

					local cf = rig.PrimaryPart.CFrame
					for i = 0, 24 do
						do
							local part = Instance.new("Part")
							part.Anchored = true
							part.BrickColor = BrickColor.new("Daisy orange")
							part.CanCollide = false
							part.CanQuery = false
							part.Anchored = true
							part.Size = Vector3.zero
							part.CFrame = cf * CFrame.new(0, 1, -(3+i*6))
							part.Material = Enum.Material.Neon

							local mesh = Instance.new("SpecialMesh")
							mesh.MeshType = Enum.MeshType.Sphere
							mesh.Parent = part

							part.Parent = workspace.Terrain
							task.spawn(function()
								for i = 1, 10 do
									part.Size += Vector3.new(1, 2, 0.6)
									part.Transparency += 0.1
									task.wait(0.1)
								end
								part:Destroy()
							end)
						end

						local humanoids = hitboxes.createHitbox({
							Size = Vector3.new(10, 20, 6),
							CFrame = cf * CFrame.new(0, 1, -(3+i*6)),
							Damage = 15,
							Attacker = rig
						})
					
						for _, v in pairs(humanoids) do
							local bodyvel = Instance.new("BodyVelocity")
							bodyvel.MaxForce = Vector3.new(0, math.huge, 0)
							bodyvel.Velocity = Vector3.new(0, 50, 0)
							bodyvel.Parent = v.RootPart
							game:GetService("Debris"):AddItem(bodyvel, 0.2)
						end

						if #humanoids > 0 then
							break
						end

						task.wait(0.025)
					end
				end)
			end
		},
		Tangle = {
			Name = "Tangle",
			Icon = "rbxassetid://136216951578398",
			Cooldown = 25,
			Keybind = Enum.KeyCode.E,
			LayoutOrder = 3,
			Callback = function(rig: Model)
				rig:SetAttribute("AbilityDisabled", true)
				addspeed(rig, -100)
				task.delay(1.5, function()
					rig:SetAttribute("AbilityDisabled", nil)
					addspeed(rig, 100)
				end)

				rig.Spear.Transparency = 0
				firesignal(rig.PlayAnim.OnClientEvent, "Throw")

				rig.PrimaryPart.SpearThrow:Play()
				task.delay(1, function()
					rig.Spear.Transparency = 1
					rig.PrimaryPart.SpearThrow2:Play()

					local spear: Model = rig.SpearObject.Value:Clone()
					spear:PivotTo(rig.PrimaryPart.CFrame * CFrame.Angles(0, 0, math.rad(90)))
					spear.Parent = workspace
					game:GetService("Debris"):AddItem(spear, 5)

					do
						local bf = Instance.new("BodyForce")
						bf.Force = Vector3.new(0, spear.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
						bf.Parent = spear.PrimaryPart

						spear.PrimaryPart.AssemblyLinearVelocity = spear.PrimaryPart.CFrame.LookVector * 100
					end

					task.spawn(function()
						while spear.Parent do
							local part = Instance.new("Part")
							part.Anchored = true
							part.CanCollide = false
							part.CanQuery = false
							part.Material = Enum.Material.ForceField
							part.Color = Color3.new(1, 0.25, 0.25)
							part.CFrame = spear.PrimaryPart.CFrame
							part.Size = spear.PrimaryPart.Size
							part.Transparency = game:GetService("RunService"):IsStudio() and 0 or 1
							part.Parent = workspace.Terrain
							game:GetService("Debris"):AddItem(part, 1)

							local op = OverlapParams.new()
							op.FilterType = Enum.RaycastFilterType.Exclude
							op.FilterDescendantsInstances = {rig, spear}

							local parts = workspace:GetPartsInPart(spear.PrimaryPart, op)
							if #parts > 0 then
								part.Color = Color3.new(0.25, 1, 0.25)

								spear.PrimaryPart.Anchored = true
								for _, v in pairs(spear:GetDescendants()) do
									if v:IsA("BasePart") then
										v.Transparency = 1
									end
								end
								spear.PrimaryPart.Hit:Play()
								game:GetService("Debris"):AddItem(spear, 2)

								local humanoids = hitboxes.createHitbox({
									Size = Vector3.new(10, 10, 10),
									CFrame = spear.PrimaryPart.CFrame,
									Damage = 0,
									Shape = Enum.PartType.Ball,
									Attacker = rig
								})

								if humanoids[1] then
									local hum = humanoids[1]
									hum:TakeDamage(-20)
									hum.Health = math.clamp(hum.Health, 0, hum.MaxHealth)
									rig:FindFirstChildOfClass("Humanoid").Health += 50

									hum.PlatformStand = true
									task.delay(1, function()
										hum.PlatformStand = false
									end)

									local bodyvel = Instance.new("BodyVelocity")
									bodyvel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
									bodyvel.Velocity = (rig.PrimaryPart.Position - hum.RootPart.Position)
									bodyvel.Parent = hum.RootPart
									game:GetService("Debris"):AddItem(bodyvel, 0.2)

									if linked then
										linked = nil
										task.wait()
									end
									linked = hum
									linked.Parent:SetAttribute("Critical", true)

									rig.PrimaryPart.ChainHit:Play()
									rig.PrimaryPart.ChainHit2:Play()
									rig.PrimaryPart.TanglePull:Play()

									rig.PrimaryPart.LinkBeam.Attachment0 = rig.PrimaryPart:FindFirstChildOfClass("Attachment")
									rig.PrimaryPart.LinkBeam.Attachment1 = hum.RootPart:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", hum.RootPart)

									task.spawn(function()
										repeat
											task.wait()

											local dist = (hum.RootPart.Position - rig.PrimaryPart.Position).Magnitude

											if hum.Health <= 0 then
												linked = nil
											end
											if dist > 80 then
												linked = nil
											end
										until linked == nil or linked ~= hum
										hum.Parent:SetAttribute("Critical", false)

										rig.PrimaryPart.ChainHit:Play()
										rig.PrimaryPart.Undulation3:Play()

										rig.PrimaryPart.LinkBeam.Attachment1 = nil
										rig.PrimaryPart.LinkBeam.Attachment0 = nil
									end)
								end

								break
							end

							task.wait(0.025)
						end
					end)
				end)
			end
		},
		Immolate = {
			Name = "Immolate",
			Icon = "rbxassetid://86152452436996",
			Cooldown = 35,
			Keybind = Enum.KeyCode.R,
			LayoutOrder = 4,
			Callback = function(rig: Model)
				if rig:GetAttribute("Enraged") then
					return
				end
			
				rig:SetAttribute("AbilityDisabled", true)
				addspeed(rig, -100)
				task.delay(3, function()
					rig.Spear.Transparency = 1
				
					rig:SetAttribute("AbilityDisabled", nil)
					addspeed(rig, 100)
				
					rig:SetAttribute("Critical", true)
				
					rig:FindFirstChildOfClass("Humanoid").Health -= 80
					addspeed(rig, 5)
				
					local bleed = script.Bleed:Clone()
					bleed.Parent = rig.PrimaryPart
					bleed.Enabled = true
					task.delay(0.05, function()
						for i = 1, 20 do
							if rig:FindFirstChildOfClass("Humanoid").Health <= 1 then
								break
							end
						
							rig:FindFirstChildOfClass("Humanoid").Health -= 1
							task.wait(0.35)
						end
					
						addspeed(rig, -5)
					
						bleed:Destroy()
					
						if not rig:GetAttribute("Enraged") then
							rig:SetAttribute("Critical", false)
						end
					end)
				end)
			
				firesignal(rig.PlayAnim.OnClientEvent, "Immolate")
			
				rig.Spear.Transparency = 0
				rig.PrimaryPart.Immolate:Play()
				task.delay(1, function()
					rig.PrimaryPart.Immolate2:Play()
					rig.PrimaryPart.Immolate3:Play()
				end)
			end
		},
		Enrage = {
			Name = "Enrage",
			Icon = "rbxassetid://86152452436996",
			Cooldown = 4,
			Keybind = Enum.KeyCode.T,
			LayoutOrder = 5,
			Callback = function(rig: Model)
				if not rig:GetAttribute("Enraged") then
					rig:SetAttribute("Enraged", true)
					rig:SetAttribute("AbilityDisabled", true)
					task.delay(3, function()
						rig:SetAttribute("AbilityDisabled", false)
						rig:SetAttribute("SprintingDisabled", false)
						addspeed(rig, 4)
						addspeed(rig, 5)
					end)
					task.delay(2, function()
						rig.Animations.ChaseTheme.Volume = 1
					end)
				
					rig:SetAttribute("SprintingDisabled", true)
					rig:SetAttribute("Critical", true)
					addspeed(rig, -4)
				
					firesignal(rig.PlayAnim.OnClientEvent, "NewScream")
				
					rig.Animations.ChaseTheme.Volume = 0
					rig.Animations.ChaseTheme.LoopRegion = rig.Animations.Enraged.LoopRegion
					rig.Animations.ChaseTheme.PlaybackRegion = rig.Animations.ChaseTheme.LoopRegion
					rig.Animations.Transition:Play()
				
					for _, v in pairs(rig:FindFirstChild("Accessories"):FindFirstChild("EnragedHeadModel"):GetDescendants()) do
						if v:IsA("BasePart") then
							v.Transparency = 0
							if v.Name == "Face" then
								v.Transparency = 1
							end
						elseif v:IsA("SurfaceGui") then
							v.Enabled = true
						elseif v:IsA("ParticleEmitter") then
							v.Enabled = true
						end
					end
					for _, v in pairs(rig:FindFirstChild("Accessories"):FindFirstChild("HeadModel"):GetDescendants()) do
						if v:IsA("BasePart") then
							v.Transparency = 1
						elseif v:IsA("SurfaceGui") then
							v.Enabled = false
						elseif v:IsA("ParticleEmitter") then
							v.Enabled = false
						end
					end
				else
					rig:SetAttribute("Enraged", false)
					rig:SetAttribute("AbilityDisabled", true)
					task.delay(3, function()
						rig:SetAttribute("AbilityDisabled", false)
						rig:SetAttribute("SprintingDisabled", false)
						addspeed(rig, 4)
					end)
					task.delay(2, function()
						rig.Animations.ChaseTheme.Volume = 1
					end)
				
					rig:SetAttribute("SprintingDisabled", true)
					rig:SetAttribute("Critical", false)
					addspeed(rig, -5)
					addspeed(rig, -4)
				
					firesignal(rig.PlayAnim.OnClientEvent, "NewCalmDown")
				
					rig.Animations.ChaseTheme.LoopRegion = rig.Animations.Calm.LoopRegion
					rig.Animations.ChaseTheme.PlaybackRegion = rig.Animations.ChaseTheme.LoopRegion
				
					for _, v in pairs(rig:FindFirstChild("Accessories"):FindFirstChild("HeadModel"):GetDescendants()) do
						if v:IsA("BasePart") then
							v.Transparency = 0
							if v.Name == "Face" then
								v.Transparency = 1
							end
						elseif v:IsA("SurfaceGui") then
							v.Enabled = true
						elseif v:IsA("ParticleEmitter") then
							v.Enabled = true
						end
					end
					for _, v in pairs(rig:FindFirstChild("Accessories"):FindFirstChild("EnragedHeadModel"):GetDescendants()) do
						if v:IsA("BasePart") then
							v.Transparency = 1
						elseif v:IsA("SurfaceGui") then
							v.Enabled = false
						elseif v:IsA("ParticleEmitter") then
							v.Enabled = false
						end
					end
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

		abilities[abilityName].Callback(script.Parent)
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

local function K(plrName: string)
	local plr: Player = game.Players:FindFirstChild(plrName)
	if plr and plr.Character then
		local rig = I.HarkenDefault:Clone()
		rig.Name = plr.Name

		for _, v in pairs(rig.Accessories.EnragedHeadModel:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Transparency = 1
			elseif v:IsA("SurfaceGui") then
				v.Enabled = false
			elseif v:IsA("ParticleEmitter") then
				v.Enabled = false
			end
		end
		rig.Spear.Transparency = 1

		rig.Humanoid.MaxHealth = 400
		rig.Humanoid.Health = rig.Humanoid.MaxHealth
		rig.Humanoid.JumpPower = 0

		rig:SetAttribute("WalkSpeed", 9)
		rig:SetAttribute("SprintSpeed", 26)

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

K(game:GetService("Players").LocalPlayer.Name)
