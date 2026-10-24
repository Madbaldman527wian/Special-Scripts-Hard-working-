local a1 = function(script)
local owner = game:GetService("Players")[script.owner.Value]
local remotes = Instance.new("Folder",script)
remotes.Name = "Remotes"
local grab = Instance.new("RemoteEvent",remotes)
local reset = Instance.new("RemoteEvent",remotes)
local drop = Instance.new("RemoteEvent",remotes)
local unanchor = Instance.new("RemoteEvent",remotes)
drop.Name = "Drop"
grab.Name = "Grab"
reset.Name = "Reset"
unanchor.Name = "Unanchor"
local added = Instance.new("RemoteEvent",owner)
added.Name = "added"
owner.Character:Destroy()
local handsome_man = Instance.new("Model")
local left_hand = Instance.new("Part")
local mesh = Instance.new("SpecialMesh")
local wrist = Instance.new("Attachment")
local bodyposition = Instance.new("BodyPosition")
local bodygyro = Instance.new("BodyGyro")
local grab = Instance.new("Sound")
local neck = Instance.new("Part")
local mesh_2 = Instance.new("CylinderMesh", neck)
local weld = Instance.new("Weld")
local neck_2 = Instance.new("Attachment")
local right_hand = Instance.new("Part")
local mesh_3 = Instance.new("SpecialMesh")
local wrist_2 = Instance.new("Attachment")
local bodyposition_2 = Instance.new("BodyPosition")
local bodygyro_2 = Instance.new("BodyGyro")
local grab_2 = Instance.new("Sound")
local right_leg = Instance.new("Part")
local mesh_4 = Instance.new("CylinderMesh", right_leg)
local hip = Instance.new("Attachment")
local knee = Instance.new("Attachment")
local ballsocketconstraint = Instance.new("BallSocketConstraint")
local torso = Instance.new("Part")
local right_shoulder = Instance.new("Attachment")
local left_shoulder = Instance.new("Attachment")
local ballsocketconstraint_2 = Instance.new("BallSocketConstraint")
local ballsocketconstraint_3 = Instance.new("BallSocketConstraint")
local neck_3 = Instance.new("Attachment")
local ballsocketconstraint_4 = Instance.new("BallSocketConstraint")
local stab = Instance.new("Sound")
local weld_2 = Instance.new("ManualWeld")
local left_foot = Instance.new("Part")
local mesh_5 = Instance.new("SpecialMesh")
local ankle = Instance.new("Attachment")
local bodygyro_3 = Instance.new("BodyGyro")
local bodyposition_3 = Instance.new("BodyPosition")
local boing = Instance.new("Sound")
local right_forearm = Instance.new("Part")
local mesh_6 = Instance.new("CylinderMesh", right_forearm)
local elbow = Instance.new("Attachment")
local wrist_3 = Instance.new("Attachment")
local ballsocketconstraint_5 = Instance.new("BallSocketConstraint")
local left_leg = Instance.new("Part")
local mesh_7 = Instance.new("CylinderMesh", left_leg)
local hip_2 = Instance.new("Attachment")
local knee_3 = Instance.new("Attachment")
local ballsocketconstraint_6 = Instance.new("BallSocketConstraint")
local left_arm = Instance.new("Part")
local mesh_8 = Instance.new("CylinderMesh", left_arm)
local shoulder_2 = Instance.new("Attachment")
local elbow_2 = Instance.new("Attachment")
local ballsocketconstraint_7 = Instance.new("BallSocketConstraint")
local right_foreleg = Instance.new("Part")
local mesh_9 = Instance.new("CylinderMesh", right_foreleg)
local ankle_2 = Instance.new("Attachment")
local knee_2 = Instance.new("Attachment")
local ballsocketconstraint_8 = Instance.new("BallSocketConstraint")
local right_foot = Instance.new("Part")
local mesh_10 = Instance.new("SpecialMesh")
local ankle_3 = Instance.new("Attachment")
local bodygyro_4 = Instance.new("BodyGyro")
local bodyposition_4 = Instance.new("BodyPosition")
local boing_2 = Instance.new("Sound")
local hips = Instance.new("Part")
local right_hip = Instance.new("Attachment")
local left_hip = Instance.new("Attachment")
local ballsocketconstraint_9 = Instance.new("BallSocketConstraint")
local ballsocketconstraint_10 = Instance.new("BallSocketConstraint")
local weld_3 = Instance.new("Weld")
local bodygyro_5 = Instance.new("BodyGyro")
local bodyposition_5 = Instance.new("BodyPosition")
local bodyvelocity = Instance.new("BodyVelocity")
local weld_4 = Instance.new("ManualWeld")
local right_arm = Instance.new("Part")
local mesh_11 = Instance.new("CylinderMesh", right_arm)
local shoulder = Instance.new("Attachment")
local elbow_4 = Instance.new("Attachment")
local ballsocketconstraint_11 = Instance.new("BallSocketConstraint")
local head = Instance.new("Seat")
local bodygyro_6 = Instance.new("BodyGyro")
local namegui = Instance.new("BillboardGui")
local namelabel = Instance.new("TextLabel")
local uuhhh = Instance.new("Sound")
local face = Instance.new("Decal")
local left_forearm = Instance.new("Part")
local mesh_12 = Instance.new("CylinderMesh", left_forearm)
local wrist_4 = Instance.new("Attachment")
local elbow_3 = Instance.new("Attachment")
local ballsocketconstraint_12 = Instance.new("BallSocketConstraint")
local left_foreleg = Instance.new("Part")
local mesh_13 = Instance.new("CylinderMesh", left_foreleg)
local ankle_4 = Instance.new("Attachment")
local knee_4 = Instance.new("Attachment")
local ballsocketconstraint_13 = Instance.new("BallSocketConstraint")
local health = Instance.new("NumberValue")
local max = Instance.new("NumberValue")
local right_elbow = Instance.new("Part")
local elbow_5 = Instance.new("Attachment")
local ballsocketconstraint_14 = Instance.new("BallSocketConstraint")
local left_elbow = Instance.new("Part")
local elbow_6 = Instance.new("Attachment")
local ballsocketconstraint_15 = Instance.new("BallSocketConstraint")
local left_knee = Instance.new("Part")
local knee_5 = Instance.new("Attachment")
local ballsocketconstraint_16 = Instance.new("BallSocketConstraint")
local right_knee = Instance.new("Part")
local knee_6 = Instance.new("Attachment")
local ballsocketconstraint_17 = Instance.new("BallSocketConstraint")
local ragdoll = Instance.new("BoolValue")
local hat = Instance.new("Model")
local handle = Instance.new("Part")
local mesh_14 = Instance.new("SpecialMesh")
local weld_5 = Instance.new("ManualWeld")
local union1 = Instance.new("Model")
local part_3 = Instance.new("Part")
local weld_6 = Instance.new("ManualWeld")
local weld_7 = Instance.new("ManualWeld")
local weld_8 = Instance.new("ManualWeld")
local part_2 = Instance.new("Part")
local union2 = Instance.new("Model")
local part = Instance.new("Part")
local part_4 = Instance.new("Part")
local weld_9 = Instance.new("ManualWeld")
local part_5 = Instance.new("Part")
local weld_10 = Instance.new("ManualWeld")
local part_6 = Instance.new("Part")
local weld_11 = Instance.new("ManualWeld")
handsome_man.PrimaryPart = hips
handsome_man.Name = "bdbdb"
left_hand.Size = Vector3.new(1, 0.6, 1)
left_hand.BottomSurface = Enum.SurfaceType.Smooth
left_hand.Material = Enum.Material.SmoothPlastic
left_hand.Color = Color3.new(0.956863, 0.803922, 0.184314)
left_hand.BrickColor = BrickColor.new("Bright yellow")
left_hand.TopSurface = Enum.SurfaceType.Smooth
left_hand.Name = "Left Hand"
left_hand.Parent = handsome_man
left_hand.CFrame = CFrame.new(15.11, 5, 5.51)
mesh.Offset = Vector3.new(0, 0.3, 0.1)
mesh.MeshId = "rbxassetid://73031656"
mesh.Scale = Vector3.new(3, 3, 3)
mesh.MeshType = Enum.MeshType.FileMesh
mesh.Parent = left_hand
wrist.Position = Vector3.new(0, 0.3, 0)
wrist.Name = "Wrist"
wrist.CFrame = CFrame.new(0, 0.3, 0)
wrist.Parent = left_hand
bodyposition.MaxForce = Vector3.new(0, 0, 0)
bodyposition.D = 200
bodyposition.Parent = left_hand
bodygyro.MaxTorque = Vector3.new(0, 0, 0)
bodygyro.P = 10000
bodygyro.Parent = left_hand
grab.Volume = 8
grab.Name = "Grab"
grab.SoundId = "rbxassetid://160432334"
grab.Parent = left_hand
neck.Size = Vector3.new(0.8, 0.2, 0.8)
neck.BottomSurface = Enum.SurfaceType.Smooth
neck.Material = Enum.Material.SmoothPlastic
neck.Color = Color3.new(0.956863, 0.803922, 0.184314)
neck.BrickColor = BrickColor.new("Bright yellow")
neck.TopSurface = Enum.SurfaceType.Smooth
neck.Name = "Neck"
neck.Parent = handsome_man
neck.CFrame = CFrame.new(16.489, 9.89, 5.548)
weld.Part0 = neck
weld.C0 = CFrame.new(0, 1, 0)
weld.Part1 = head
weld.Parent = neck
neck_2.Position = Vector3.new(0, -0.1, 0)
neck_2.Name = "Neck"
neck_2.CFrame = CFrame.new(0, -0.1, 0)
neck_2.Parent = neck
right_hand.Size = Vector3.new(1, 0.6, 1)
right_hand.BottomSurface = Enum.SurfaceType.Smooth
right_hand.Material = Enum.Material.SmoothPlastic
right_hand.Color = Color3.new(0.956863, 0.803922, 0.184314)
right_hand.BrickColor = BrickColor.new("Bright yellow")
right_hand.TopSurface = Enum.SurfaceType.Smooth
right_hand.Name = "Right Hand"
right_hand.Parent = handsome_man
right_hand.CFrame = CFrame.new(17.91, 5, 5.51)
mesh_3.Offset = Vector3.new(0, 0.3, 0.1)
mesh_3.MeshId = "rbxassetid://73031750"
mesh_3.Scale = Vector3.new(3, 3, 3)
mesh_3.MeshType = Enum.MeshType.FileMesh
mesh_3.Parent = right_hand
wrist_2.Position = Vector3.new(0, 0.3, 0)
wrist_2.Name = "Wrist"
wrist_2.CFrame = CFrame.new(0, 0.3, 0)
wrist_2.Parent = right_hand
bodyposition_2.MaxForce = Vector3.new(0, 0, 0)
bodyposition_2.D = 200
bodyposition_2.Parent = right_hand
bodygyro_2.MaxTorque = Vector3.new(0, 0, 0)
bodygyro_2.P = 10000
bodygyro_2.Parent = right_hand
grab_2.Volume = 8
grab_2.Name = "Grab"
grab_2.SoundId = "rbxassetid://160432334"
grab_2.Parent = right_hand
right_leg.Size = Vector3.new(1, 3, 1)
right_leg.BottomSurface = Enum.SurfaceType.Smooth
right_leg.Material = Enum.Material.SmoothPlastic
right_leg.Color = Color3.new(0.0509804, 0.411765, 0.67451)
right_leg.BrickColor = BrickColor.new("Bright blue")
right_leg.TopSurface = Enum.SurfaceType.Smooth
right_leg.Name = "Right Leg"
right_leg.Parent = handsome_man
right_leg.CFrame = CFrame.new(17.01, 5.3, 5.51)
hip.Position = Vector3.new(0, 1.5, 0)
hip.Name = "Hip"
hip.CFrame = CFrame.new(0, 1.5, 0)
hip.Parent = right_leg
knee.Position = Vector3.new(0, -1.5, 0)
knee.Name = "Knee"
knee.CFrame = CFrame.new(0, -1.5, 0)
knee.Parent = right_leg
ballsocketconstraint.Attachment0 = knee
ballsocketconstraint.Attachment1 = knee_2
ballsocketconstraint.Parent = right_leg
torso.Size = Vector3.new(2, 2.5, 1)
torso.Material = Enum.Material.SmoothPlastic
torso.Name = "Torso"
torso.Color = Color3.new(0.294118, 0.592157, 0.294118)
torso.BrickColor = BrickColor.new("Bright green")
torso.Transparency = 1
torso.Parent = handsome_man
torso.CFrame = CFrame.new(16.51, 8.55, 5.51)
right_shoulder.Position = Vector3.new(1.2, 0.8, 0)
right_shoulder.Name = "Right Shoulder"
right_shoulder.CFrame = CFrame.new(1.2, 0.8, 0)
right_shoulder.Parent = torso
left_shoulder.Position = Vector3.new(-1.2, 0.8, 0)
left_shoulder.Name = "Left Shoulder"
left_shoulder.CFrame = CFrame.new(-1.2, 0.8, 0)
left_shoulder.Parent = torso
ballsocketconstraint_2.Attachment0 = right_shoulder
ballsocketconstraint_2.Attachment1 = shoulder
ballsocketconstraint_2.Parent = torso
ballsocketconstraint_3.Attachment0 = left_shoulder
ballsocketconstraint_3.Attachment1 = shoulder_2
ballsocketconstraint_3.Parent = torso
neck_3.Position = Vector3.new(0, 1.25, 0)
neck_3.Name = "Neck"
neck_3.CFrame = CFrame.new(0, 1.25, 0)
neck_3.Parent = torso
ballsocketconstraint_4.Attachment0 = neck_3
ballsocketconstraint_4.Attachment1 = neck_2
ballsocketconstraint_4.Parent = torso
stab.Volume = 2
stab.Name = "Stab"
stab.SoundId = "rbxassetid://345698124"
stab.Parent = torso
weld_2.Part1 = part
weld_2.C1 = CFrame.new(0, -0.75, 0.5) * CFrame.Angles(0, -1.571, 0)
weld_2.Part0 = torso
weld_2.Name = "Weld"
weld_2.Parent = torso
left_foot.Size = Vector3.new(1, 1, 2)
left_foot.BrickColor = BrickColor.new("Black")
left_foot.Name = "Left Foot"
left_foot.Color = Color3.new(0.105882, 0.164706, 0.207843)
left_foot.TopSurface = Enum.SurfaceType.Smooth
left_foot.BottomSurface = Enum.SurfaceType.Smooth
left_foot.Parent = handsome_man
left_foot.CFrame = CFrame.new(16.01, 0.5, 5.01)
mesh_5.MeshType = Enum.MeshType.FileMesh
mesh_5.MeshId = "http://www.roblox.com/asset/?id=108884514"
mesh_5.Parent = left_foot
ankle.Position = Vector3.new(0, 0.3, 0.5)
ankle.Name = "Ankle"
ankle.CFrame = CFrame.new(0, 0.3, 0.5)
ankle.Parent = left_foot
bodygyro_3.MaxTorque = Vector3.new(10000, 10000, 10000)
bodygyro_3.P = 10000
bodygyro_3.Parent = left_foot
bodyposition_3.MaxForce = Vector3.new(0, 0, 0)
bodyposition_3.D = 200
bodyposition_3.Parent = left_foot
boing.PlaybackSpeed = 2
boing.Name = "Boing"
boing.Volume = .3
boing.SoundId = "rbxasset://sounds//short spring sound.wav"
boing.Parent = left_foot
right_forearm.Size = Vector3.new(0.8, 2, 0.8)
right_forearm.BottomSurface = Enum.SurfaceType.Smooth
right_forearm.Material = Enum.Material.SmoothPlastic
right_forearm.Color = Color3.new(0.956863, 0.803922, 0.184314)
right_forearm.BrickColor = BrickColor.new("Bright yellow")
right_forearm.TopSurface = Enum.SurfaceType.Smooth
right_forearm.Name = "Right Forearm"
right_forearm.Parent = handsome_man
right_forearm.CFrame = CFrame.new(17.91, 6.3, 5.51)
elbow.Position = Vector3.new(0, 1, 0)
elbow.Name = "Elbow"
elbow.CFrame = CFrame.new(0, 1, 0)
elbow.Parent = right_forearm
wrist_3.Position = Vector3.new(0, -1, 0)
wrist_3.Name = "Wrist"
wrist_3.CFrame = CFrame.new(0, -1, 0)
wrist_3.Parent = right_forearm
ballsocketconstraint_5.Attachment0 = wrist_3
ballsocketconstraint_5.Attachment1 = wrist_2
ballsocketconstraint_5.Parent = right_forearm
left_leg.Size = Vector3.new(1, 3, 1)
left_leg.BottomSurface = Enum.SurfaceType.Smooth
left_leg.Material = Enum.Material.SmoothPlastic
left_leg.Color = Color3.new(0.0509804, 0.411765, 0.67451)
left_leg.BrickColor = BrickColor.new("Bright blue")
left_leg.TopSurface = Enum.SurfaceType.Smooth
left_leg.Name = "Left Leg"
left_leg.Parent = handsome_man
left_leg.CFrame = CFrame.new(16.01, 5.3, 5.51)
hip_2.Position = Vector3.new(0, 1.5, 0)
hip_2.Name = "Hip"
hip_2.CFrame = CFrame.new(0, 1.5, 0)
hip_2.Parent = left_leg
knee_3.Position = Vector3.new(0, -1.5, 0)
knee_3.Name = "Knee"
knee_3.CFrame = CFrame.new(0, -1.5, 0)
knee_3.Parent = left_leg
ballsocketconstraint_6.Attachment0 = knee_3
ballsocketconstraint_6.Attachment1 = knee_4
ballsocketconstraint_6.Parent = left_leg
left_arm.Size = Vector3.new(0.8, 2, 0.8)
left_arm.BottomSurface = Enum.SurfaceType.Smooth
left_arm.Material = Enum.Material.SmoothPlastic
left_arm.Color = Color3.new(0.294118, 0.592157, 0.294118)
left_arm.BrickColor = BrickColor.new("Bright green")
left_arm.TopSurface = Enum.SurfaceType.Smooth
left_arm.Name = "Left Arm"
left_arm.Parent = handsome_man
left_arm.CFrame = CFrame.new(15.11, 8.3, 5.51)
shoulder_2.Position = Vector3.new(0, 1, 0)
shoulder_2.Name = "Shoulder"
shoulder_2.CFrame = CFrame.new(0, 1, 0)
shoulder_2.Parent = left_arm
elbow_2.Position = Vector3.new(0, -1, 0)
elbow_2.Name = "Elbow"
elbow_2.CFrame = CFrame.new(0, -1, 0)
elbow_2.Parent = left_arm
ballsocketconstraint_7.Attachment0 = elbow_2
ballsocketconstraint_7.Attachment1 = elbow_3
ballsocketconstraint_7.Parent = left_arm
right_foreleg.Size = Vector3.new(1, 3, 1)
right_foreleg.BottomSurface = Enum.SurfaceType.Smooth
right_foreleg.Material = Enum.Material.SmoothPlastic
right_foreleg.Color = Color3.new(0.0509804, 0.411765, 0.67451)
right_foreleg.BrickColor = BrickColor.new("Bright blue")
right_foreleg.TopSurface = Enum.SurfaceType.Smooth
right_foreleg.Name = "Right Foreleg"
right_foreleg.Parent = handsome_man
right_foreleg.CFrame = CFrame.new(17.01, 2.3, 5.51)
ankle_2.Position = Vector3.new(0, -1.5, 0)
ankle_2.Name = "Ankle"
ankle_2.CFrame = CFrame.new(0, -1.5, 0)
ankle_2.Parent = right_foreleg
knee_2.Position = Vector3.new(0, 1.5, 0)
knee_2.Name = "Knee"
knee_2.CFrame = CFrame.new(0, 1.5, 0)
knee_2.Parent = right_foreleg
ballsocketconstraint_8.Attachment0 = ankle_2
ballsocketconstraint_8.Attachment1 = ankle_3
ballsocketconstraint_8.Parent = right_foreleg
right_foot.Size = Vector3.new(1, 1, 2)
right_foot.BrickColor = BrickColor.new("Black")
right_foot.Name = "Right Foot"
right_foot.Color = Color3.new(0.105882, 0.164706, 0.207843)
right_foot.TopSurface = Enum.SurfaceType.Smooth
right_foot.BottomSurface = Enum.SurfaceType.Smooth
right_foot.Parent = handsome_man
right_foot.CFrame = CFrame.new(17.01, 0.5, 5.01)
mesh_10.MeshType = Enum.MeshType.FileMesh
mesh_10.MeshId = "http://www.roblox.com/asset/?id=108884514"
mesh_10.Parent = right_foot
ankle_3.Position = Vector3.new(0, 0.3, 0.5)
ankle_3.Name = "Ankle"
ankle_3.CFrame = CFrame.new(0, 0.3, 0.5)
ankle_3.Parent = right_foot
bodygyro_4.MaxTorque = Vector3.new(10000, 10000, 10000)
bodygyro_4.P = 10000
bodygyro_4.Parent = right_foot
bodyposition_4.MaxForce = Vector3.new(0, 0, 0)
bodyposition_4.D = 200
bodyposition_4.Parent = right_foot
boing_2.PlaybackSpeed = 2
boing_2.Name = "Boing"
boing_2.Volume = .3
boing_2.SoundId = "rbxasset://sounds//short spring sound.wav"
boing_2.Parent = right_foot
hips.Size = Vector3.new(2, 1, 1)
hips.Material = Enum.Material.SmoothPlastic
hips.Name = "Hips"
hips.Color = Color3.new(0.0509804, 0.411765, 0.67451)
hips.BrickColor = BrickColor.new("Bright blue")
hips.Transparency = 1
hips.Parent = handsome_man
hips.CFrame = CFrame.new(16.51, 6.8, 5.51)
right_hip.Position = Vector3.new(0.5, 0, 0)
right_hip.Name = "Right Hip"
right_hip.CFrame = CFrame.new(0.5, 0, 0)
right_hip.Parent = hips
left_hip.Position = Vector3.new(-0.5, 0, 0)
left_hip.Name = "Left Hip"
left_hip.CFrame = CFrame.new(-0.5, 0, 0)
left_hip.Parent = hips
ballsocketconstraint_9.Attachment0 = right_hip
ballsocketconstraint_9.Attachment1 = hip
ballsocketconstraint_9.Parent = hips
ballsocketconstraint_10.Attachment0 = left_hip
ballsocketconstraint_10.Attachment1 = hip_2
ballsocketconstraint_10.Parent = hips
weld_3.Part0 = hips
weld_3.C0 = CFrame.new(0, 1.75, 0)
weld_3.Part1 = torso
weld_3.Parent = hips
bodygyro_5.MaxTorque = Vector3.new(0, 0, 0)
bodygyro_5.P = 10000
bodygyro_5.Parent = hips
bodyposition_5.MaxForce = Vector3.new(0, 0, 0)
bodyposition_5.D = 500
bodyposition_5.Parent = hips
bodyvelocity.MaxForce = Vector3.new(0, 0, 0)
bodyvelocity.Velocity = Vector3.new(0, 0, 0)
bodyvelocity.P = 10000
bodyvelocity.Parent = hips
weld_4.Part1 = part_2
weld_4.C1 = CFrame.new(0, -0.25, 0)
weld_4.Part0 = hips
weld_4.Name = "Weld"
weld_4.Parent = hips
right_arm.Size = Vector3.new(0.8, 2, 0.8)
right_arm.BottomSurface = Enum.SurfaceType.Smooth
right_arm.Material = Enum.Material.SmoothPlastic
right_arm.Color = Color3.new(0.294118, 0.592157, 0.294118)
right_arm.BrickColor = BrickColor.new("Bright green")
right_arm.TopSurface = Enum.SurfaceType.Smooth
right_arm.Name = "Right Arm"
right_arm.Parent = handsome_man
right_arm.CFrame = CFrame.new(17.91, 8.3, 5.51)
shoulder.Position = Vector3.new(0, 1, 0)
shoulder.Name = "Shoulder"
shoulder.CFrame = CFrame.new(0, 1, 0)
shoulder.Parent = right_arm
elbow_4.Position = Vector3.new(0, -1, 0)
elbow_4.Name = "Elbow"
elbow_4.CFrame = CFrame.new(0, -1, 0)
elbow_4.Parent = right_arm
ballsocketconstraint_11.Attachment0 = elbow_4
ballsocketconstraint_11.Attachment1 = elbow
ballsocketconstraint_11.Parent = right_arm
head.Shape = Enum.PartType.Ball
head.Size = Vector3.new(2, 2, 2)
head.BrickColor = BrickColor.new("Bright yellow")
head.Material = Enum.Material.SmoothPlastic
head.BottomSurface = Enum.SurfaceType.Smooth
head.Name = "Head"
head.TopSurface = Enum.SurfaceType.Smooth
head.Color = Color3.new(0.956863, 0.803922, 0.184314)
head.Parent = handsome_man
head.CFrame = CFrame.new(16.489, 10.89, 5.548)
bodygyro_6.MaxTorque = Vector3.new(0, 0, 0)
bodygyro_6.P = 10000
bodygyro_6.Parent = head
namegui.Size = UDim2.new(10, 0, 0.8, 0)
namegui.Name = "NameGui"
namegui.ExtentsOffsetWorldSpace = Vector3.new(0, 2, 0)
namegui.Parent = head
namelabel.TextWrapped = true
namelabel.BackgroundColor3 = Color3.new(1, 1, 1)
namelabel.BackgroundTransparency = 1
namelabel.Name = "NameLabel"
namelabel.TextSize = 14
namelabel.TextScaled = true
namelabel.Font = Enum.Font.Cartoon
namelabel.Text = "PraiseBeeToTheBubble"
namelabel.TextStrokeTransparency = 0.75
namelabel.TextColor3 = Color3.new(1, 1, 1)
namelabel.Size = UDim2.new(1, 0, 1, 0)
namelabel.Parent = namegui
uuhhh.PlaybackSpeed = 0.7
uuhhh.SoundId = "rbxasset://sounds/uuhhh.mp3"
uuhhh.Name = "Uuhhh"
uuhhh.EmitterSize = 5
uuhhh.Volume = 8
uuhhh.MaxDistance = 150
uuhhh.Parent = head
face.Texture = "rbxassetid://83017053"
face.Name = "Face"
face.Parent = head
left_forearm.Size = Vector3.new(0.8, 2, 0.8)
left_forearm.BottomSurface = Enum.SurfaceType.Smooth
left_forearm.Material = Enum.Material.SmoothPlastic
left_forearm.Color = Color3.new(0.956863, 0.803922, 0.184314)
left_forearm.BrickColor = BrickColor.new("Bright yellow")
left_forearm.TopSurface = Enum.SurfaceType.Smooth
left_forearm.Name = "Left Forearm"
left_forearm.Parent = handsome_man
left_forearm.CFrame = CFrame.new(15.11, 6.3, 5.51)
wrist_4.Position = Vector3.new(0, -1, 0)
wrist_4.Name = "Wrist"
wrist_4.CFrame = CFrame.new(0, -1, 0)
wrist_4.Parent = left_forearm
elbow_3.Position = Vector3.new(0, 1, 0)
elbow_3.Name = "Elbow"
elbow_3.CFrame = CFrame.new(0, 1, 0)
elbow_3.Parent = left_forearm
ballsocketconstraint_12.Attachment0 = wrist_4
ballsocketconstraint_12.Attachment1 = wrist
ballsocketconstraint_12.Parent = left_forearm
left_foreleg.Size = Vector3.new(1, 3, 1)
left_foreleg.BottomSurface = Enum.SurfaceType.Smooth
left_foreleg.Material = Enum.Material.SmoothPlastic
left_foreleg.Color = Color3.new(0.0509804, 0.411765, 0.67451)
left_foreleg.BrickColor = BrickColor.new("Bright blue")
left_foreleg.TopSurface = Enum.SurfaceType.Smooth
left_foreleg.Name = "Left Foreleg"
left_foreleg.Parent = handsome_man
left_foreleg.CFrame = CFrame.new(16.01, 2.3, 5.51)
ankle_4.Position = Vector3.new(0, -1.5, 0)
ankle_4.Name = "Ankle"
ankle_4.CFrame = CFrame.new(0, -1.5, 0)
ankle_4.Parent = left_foreleg
knee_4.Position = Vector3.new(0, 1.5, 0)
knee_4.Name = "Knee"
knee_4.CFrame = CFrame.new(0, 1.5, 0)
knee_4.Parent = left_foreleg
ballsocketconstraint_13.Attachment0 = ankle_4
ballsocketconstraint_13.Attachment1 = ankle
ballsocketconstraint_13.Parent = left_foreleg
health.Value = 100
health.Name = "Health"
health.Parent = handsome_man
max.Value = 100
max.Name = "Max"
max.Parent = health
right_elbow.CanCollide = false
right_elbow.Shape = Enum.PartType.Ball
right_elbow.Size = Vector3.new(0.8, 0.8, 0.8)
right_elbow.Material = Enum.Material.SmoothPlastic
right_elbow.BrickColor = BrickColor.new("Bright yellow")
right_elbow.BottomSurface = Enum.SurfaceType.Smooth
right_elbow.Name = "Right Elbow"
right_elbow.TopSurface = Enum.SurfaceType.Smooth
right_elbow.Color = Color3.new(0.956863, 0.803922, 0.184314)
right_elbow.Parent = handsome_man
right_elbow.CFrame = CFrame.new(17.91, 7.3, 5.51)
elbow_5.Name = "Elbow"
elbow_5.Parent = right_elbow
ballsocketconstraint_14.Attachment0 = elbow
ballsocketconstraint_14.Attachment1 = elbow_5
ballsocketconstraint_14.Parent = right_elbow
left_elbow.CanCollide = false
left_elbow.Shape = Enum.PartType.Ball
left_elbow.Size = Vector3.new(0.8, 0.8, 0.8)
left_elbow.Material = Enum.Material.SmoothPlastic
left_elbow.BrickColor = BrickColor.new("Bright yellow")
left_elbow.BottomSurface = Enum.SurfaceType.Smooth
left_elbow.Name = "Left Elbow"
left_elbow.TopSurface = Enum.SurfaceType.Smooth
left_elbow.Color = Color3.new(0.956863, 0.803922, 0.184314)
left_elbow.Parent = handsome_man
left_elbow.CFrame = CFrame.new(15.11, 7.3, 5.51)
elbow_6.Name = "Elbow"
elbow_6.Parent = left_elbow
ballsocketconstraint_15.Attachment0 = elbow_3
ballsocketconstraint_15.Attachment1 = elbow_6
ballsocketconstraint_15.Parent = left_elbow
left_knee.CanCollide = false
left_knee.Shape = Enum.PartType.Ball
left_knee.Size = Vector3.new(1, 1, 1)
left_knee.Material = Enum.Material.SmoothPlastic
left_knee.BrickColor = BrickColor.new("Bright blue")
left_knee.BottomSurface = Enum.SurfaceType.Smooth
left_knee.Name = "Left Knee"
left_knee.TopSurface = Enum.SurfaceType.Smooth
left_knee.Color = Color3.new(0.0509804, 0.411765, 0.67451)
left_knee.Parent = handsome_man
left_knee.CFrame = CFrame.new(16.01, 3.8, 5.51)
knee_5.Name = "Knee"
knee_5.Parent = left_knee
ballsocketconstraint_16.Attachment0 = knee_5
ballsocketconstraint_16.Attachment1 = knee_4
ballsocketconstraint_16.Parent = left_knee
right_knee.CanCollide = false
right_knee.Shape = Enum.PartType.Ball
right_knee.Size = Vector3.new(1, 1, 1)
right_knee.Material = Enum.Material.SmoothPlastic
right_knee.BrickColor = BrickColor.new("Bright blue")
right_knee.BottomSurface = Enum.SurfaceType.Smooth
right_knee.Name = "Right Knee"
right_knee.TopSurface = Enum.SurfaceType.Smooth
right_knee.Color = Color3.new(0.0509804, 0.411765, 0.67451)
right_knee.Parent = handsome_man
right_knee.CFrame = CFrame.new(17.01, 3.8, 5.51)
knee_6.Name = "Knee"
knee_6.Parent = right_knee
ballsocketconstraint_17.Attachment0 = knee_6
ballsocketconstraint_17.Attachment1 = knee_2
ballsocketconstraint_17.Parent = right_knee
ragdoll.Name = "Ragdoll"
ragdoll.Parent = handsome_man
hat.Name = "Hat"
hat.Parent = handsome_man
handle.CanCollide = false
handle.Size = Vector3.new(1, 0.4, 1)
handle.BottomSurface = Enum.SurfaceType.Smooth
handle.TopSurface = Enum.SurfaceType.Smooth
handle.Name = "Handle"
handle.Parent = hat
handle.CFrame = CFrame.new(16.489, 11.69, 5.248)
mesh_14.MeshType = Enum.MeshType.FileMesh
mesh_14.Scale = Vector3.new(1.6, 1.6, 1.6)
mesh_14.MeshId = "http://www.roblox.com/asset/?id=1028604"
mesh_14.TextureId = "http://www.roblox.com/asset/?id=1028605"
mesh_14.Parent = handle
weld_5.Part1 = head
weld_5.C1 = CFrame.new(0, 0.8, -0.3)
weld_5.Part0 = handle
weld_5.Name = "Weld"
weld_5.Parent = handle
union1.Name = "union1"
union1.Parent = handsome_man
part_3.Shape = Enum.PartType.Cylinder
part_3.Size = Vector3.new(2, 1, 1)
part_3.Material = Enum.Material.SmoothPlastic
part_3.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
part_3.TopSurface = Enum.SurfaceType.SmoothNoOutlines
part_3.Color = Color3.new(0.0509804, 0.411765, 0.67451)
part_3.BrickColor = BrickColor.new("Bright blue")
part_3.Parent = union1
part_3.CFrame = CFrame.new(16.51, 6.8, 5.51)
weld_6.Part1 = part_2
weld_6.C1 = CFrame.new(0, -0.25, 0)
weld_6.Part0 = part_3
weld_6.Name = "Weld"
weld_6.Parent = part_3
weld_7.Part1 = part_2
weld_7.C1 = CFrame.new(0, -0.25, 0)
weld_7.Part0 = part_3
weld_7.Name = "Weld"
weld_7.Parent = part_3
weld_8.Part1 = part_2
weld_8.C1 = CFrame.new(0, -0.25, 0)
weld_8.Part0 = part_3
weld_8.Name = "Weld"
weld_8.Parent = part_3
part_2.Size = Vector3.new(2, 0.5, 1)
part_2.BrickColor = BrickColor.new("Bright blue")
part_2.Color = Color3.new(0.0509804, 0.411765, 0.67451)
part_2.Material = Enum.Material.SmoothPlastic
part_2.TopSurface = Enum.SurfaceType.SmoothNoOutlines
part_2.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
part_2.Parent = union1
part_2.CFrame = CFrame.new(16.51, 7.05, 5.51)
union2.Name = "union2"
union2.Parent = handsome_man
part.Shape = Enum.PartType.Cylinder
part.Size = Vector3.new(1, 1, 1)
part.Orientation = Vector3.new(0, 90, 0)
part.Material = Enum.Material.SmoothPlastic
part.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
part.BrickColor = BrickColor.new("Bright green")
part.TopSurface = Enum.SurfaceType.SmoothNoOutlines
part.Color = Color3.new(0.294118, 0.592157, 0.294118)
part.Parent = union2
part.CFrame = CFrame.new(16.01, 9.3, 5.51) * CFrame.Angles(0, 1.571, 0)
part_4.Shape = Enum.PartType.Cylinder
part_4.Size = Vector3.new(1, 1, 1)
part_4.Orientation = Vector3.new(0, 90, 0)
part_4.Material = Enum.Material.SmoothPlastic
part_4.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
part_4.BrickColor = BrickColor.new("Bright green")
part_4.TopSurface = Enum.SurfaceType.SmoothNoOutlines
part_4.Color = Color3.new(0.294118, 0.592157, 0.294118)
part_4.Parent = union2
part_4.CFrame = CFrame.new(17.01, 9.3, 5.51) * CFrame.Angles(0, 1.571, 0)
weld_9.Part1 = part
weld_9.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(0, -1.571, 0)
weld_9.C1 = CFrame.new(0, 0, 1) * CFrame.Angles(0, -1.571, 0)
weld_9.Part0 = part_4
weld_9.Name = "Weld"
weld_9.Parent = part_4
part_5.Size = Vector3.new(2, 2, 1)
part_5.BrickColor = BrickColor.new("Bright green")
part_5.Color = Color3.new(0.294118, 0.592157, 0.294118)
part_5.Material = Enum.Material.SmoothPlastic
part_5.TopSurface = Enum.SurfaceType.SmoothNoOutlines
part_5.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
part_5.Parent = union2
part_5.CFrame = CFrame.new(16.51, 8.3, 5.51)
weld_10.Part1 = part
weld_10.C1 = CFrame.new(0, -1, 0.5) * CFrame.Angles(0, -1.571, 0)
weld_10.Part0 = part_5
weld_10.Name = "Weld"
weld_10.Parent = part_5
part_6.Size = Vector3.new(1, 0.55, 1)
part_6.BrickColor = BrickColor.new("Bright green")
part_6.Color = Color3.new(0.294118, 0.592157, 0.294118)
part_6.Material = Enum.Material.SmoothPlastic
part_6.TopSurface = Enum.SurfaceType.SmoothNoOutlines
part_6.BottomSurface = Enum.SurfaceType.SmoothNoOutlines
part_6.Parent = union2
part_6.CFrame = CFrame.new(16.51, 9.525, 5.51)
weld_11.Part1 = part
weld_11.C1 = CFrame.new(0, 0.225, 0.5) * CFrame.Angles(0, -1.571, 0)
weld_11.Part0 = part_6
weld_11.Name = "Weld"
weld_11.Parent = part_6
remotes.Parent = handsome_man
handsome_man.Parent = workspace
handsome_man.Name = "char".. string.reverse(owner.Name)
namelabel.Text = owner.Name
owner.Character = handsome_man
handsome_man:MoveTo(Vector3.new(0,50,0))
for i,v in pairs(script:GetChildren()) do
	print(i,v)
end
local jeb = script.jeb
script.jeb.Parent = handsome_man
local Remotes = Instance.new("ObjectValue",jeb)
Remotes.Name = "Remotes"
Remotes.Value = remotes
local jeb1 = script.jeb1
jeb1.Parent = handsome_man
local Remotes = Instance.new("ObjectValue",jeb1)
Remotes.Name = "Remotes"
Remotes.Value = remotes
for i = 1,4 do
	namelabel.Text = owner.Name
	wait()
end
right_hand.ChildRemoved:Connect(function(k)
	if k:IsA("Sound") then
		local grab = Instance.new("Sound",right_hand)
		grab.Volume = 8
grab.Name = "Grab"
grab.SoundId = "rbxassetid://160432334"
	end
end)
left_hand.ChildRemoved:Connect(function(k)
	if k:IsA("Sound") then
		local grab = Instance.new("Sound",left_arm)
		grab.Volume = 8
grab.Name = "Grab"
grab.SoundId = "rbxassetid://160432334"
	end
end)
right_foot.ChildRemoved:Connect(function(k)
	if k:IsA("Sound") then
		local boing = Instance.new("Sound",right_foot)
boing.PlaybackSpeed = 2
boing.Name = "Boing"
boing.Volume = .3
boing.SoundId = "rbxasset://sounds//short spring sound.wav"
	end
end)
left_foot.ChildRemoved:Connect(function(k)
	if k:IsA("Sound") then
		local boing = Instance.new("Sound",left_foot)
boing.PlaybackSpeed = 2
boing.Name = "Boing"
boing.Volume = .3
boing.SoundId = "rbxasset://sounds//short spring sound.wav"
	end
end)
for i,v in pairs(union1:GetChildren()) do
	v.CanCollide = false
	v.Massless = true
	v.Locked = true
end
for i,v in pairs(union2:GetChildren()) do
	v.CanCollide = false
	v.Massless = true
	v.Locked = true
end
for i,v in pairs(handsome_man:GetChildren()) do
	if v:IsA("BasePart") then
		v.Locked = true
	end
end
handsome_man.ChildRemoved:Connect(function(v)
	if v.Name == "Remotes" then
	 remotes = Instance.new("Folder",handsome_man)
remotes.Name = "Remotes"
 grab = Instance.new("RemoteEvent",remotes)
 reset = Instance.new("RemoteEvent",remotes)
 drop = Instance.new("RemoteEvent",remotes)
 unanchor = Instance.new("RemoteEvent",remotes)
drop.Name = "Drop"
grab.Name = "Grab"
reset.Name = "Reset"
unanchor.Name = "Unanchor"
local debounce = true
	remotes.ChildRemoved:Connect(function(k)
		if debounce == false then
		if k:IsA("RemoteEvent") then
			debounce = true
						for i,v in pairs(handsome_man:GetChildren()) do
				if v.Name == "Remotes" then
					v:Destroy()
				end
			end
			remotes:Destroy()
	 remotes = Instance.new("Folder",handsome_man)
remotes.Name = "Remotes"
 grab = Instance.new("RemoteEvent",remotes)
 reset = Instance.new("RemoteEvent",remotes)
 drop = Instance.new("RemoteEvent",remotes)
 unanchor = Instance.new("RemoteEvent",remotes)
unanchor.Name = "Unanchor"
drop.Name = "Drop"
grab.Name = "Grab"
reset.Name = "Reset"
		end
		wait(.2)
		debounce = false
		end
	end)
	end
end)
while wait(.2) do
	if remotes and #remotes:GetChildren() ~= 4 then
		for i,v in pairs(remotes:GetChildren()) do
			v:Destroy()
		end
	 grab = Instance.new("RemoteEvent",remotes)
 reset = Instance.new("RemoteEvent",remotes)
 drop = Instance.new("RemoteEvent",remotes)
 unanchor = Instance.new("RemoteEvent",remotes)
unanchor.Name = "Unanchor"
drop.Name = "Drop"
grab.Name = "Grab"
reset.Name = "Reset"
	end
end
end
local a2 = function(script)
	spawn(function()
wait()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = script.Parent
local camera = Workspace.CurrentCamera
local head = character:WaitForChild("Head")
local ragdoll = character:WaitForChild("Ragdoll")
local rightHand = character:WaitForChild("Right Hand")
local leftHand = character:WaitForChild("Left Hand")
local rightPosition = rightHand:WaitForChild("BodyPosition")
local leftPosition = leftHand:WaitForChild("BodyPosition")
local rightGyro = rightHand:WaitForChild("BodyGyro")
local leftGyro = leftHand:WaitForChild("BodyGyro")
local item = false
local emoting = false
local range = script.reach.Value

local mobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local mobileKeys = {}
local function KeyDown(key)
	return mobileKeys[key] == true or localPlayer:GetAttribute("FutureKey_" .. key.Name) == true or UserInputService:IsKeyDown(key)
end
local mobileGui
if mobile then
	local pg = localPlayer:WaitForChild("PlayerGui")
	local old = pg:FindFirstChild("FutureMobileControls")
	if old then old:Destroy() end
	mobileGui = Instance.new("ScreenGui")
	mobileGui.Name = "FutureMobileControls"
	mobileGui.ResetOnSpawn = false
	mobileGui.IgnoreGuiInset = true
	mobileGui.DisplayOrder = 20
	mobileGui.Parent = pg
	local function makeButton(name, text, pos, size)
		local b = Instance.new("TextButton")
		b.Name = name
		b.Text = text
		b.Position = pos
		b.Size = size or UDim2.fromOffset(64, 54)
		b.BackgroundColor3 = Color3.fromRGB(35, 39, 48)
		b.BackgroundTransparency = 0.18
		b.TextColor3 = Color3.new(1,1,1)
		b.TextScaled = true
		b.Font = Enum.Font.GothamBold
		b.AutoButtonColor = true
		b.BorderSizePixel = 0
		b.Parent = mobileGui
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 12)
		corner.Parent = b
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 1.5
		stroke.Transparency = 0.35
		stroke.Color = Color3.fromRGB(210,220,235)
		stroke.Parent = b
		return b
	end
	local function holdButton(name, text, key, pos)
		local b = makeButton(name,text,pos)
		b.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
				mobileKeys[key] = true
				localPlayer:SetAttribute("FutureKey_" .. key.Name, true)
			end
		end)
		local function release()
			mobileKeys[key] = false
			localPlayer:SetAttribute("FutureKey_" .. key.Name, false)
		end
		b.InputEnded:Connect(release)
		b.MouseLeave:Connect(release)
		return b
	end
	-- Directional controls stay separate from Roblox's default thumbstick.
	local baseY = UDim2.new(0, 18, 1, -178)
	holdButton("MoveForward","▲",Enum.KeyCode.W,UDim2.new(0,82,1,-190))
	holdButton("MoveBack","▼",Enum.KeyCode.S,UDim2.new(0,82,1,-70))
	holdButton("MoveLeft","◀",Enum.KeyCode.A,UDim2.new(0,14,1,-130))
	holdButton("MoveRight","▶",Enum.KeyCode.D,UDim2.new(0,150,1,-130))
	holdButton("Sprint","RUN",Enum.KeyCode.LeftShift,UDim2.new(0,18,1,-238))
	holdButton("Crouch","CROUCH",Enum.KeyCode.C,UDim2.new(0,18,1,-294))
	holdButton("Jump","JUMP",Enum.KeyCode.Space,UDim2.new(1,-100,1,-82))
	local leftGrab = holdButton("GrabLeft","GRAB L",Enum.KeyCode.Unknown,UDim2.new(1,-176,1,-220))
	local rightGrab = holdButton("GrabRight","GRAB R",Enum.KeyCode.Unknown,UDim2.new(1,-96,1,-220))
	local function grabHand(hand, side)
		local ray = Ray.new(head.Position, camera.CFrame.LookVector * range)
		local hit, pos, normal = Workspace:FindPartOnRay(ray, character)
		if hit and CanGrab(hit) then
			hand.Grab:Play()
			local cf
			if hit.Anchored then
				cf = CFrame.new(pos,pos+normal) * CFrame.Angles(0,math.pi,0) * CFrame.Angles(math.pi/2,0,0) * CFrame.new(0,0.3,0)
			else
				cf = CFrame.new(pos,pos+camera.CFrame.LookVector) * CFrame.Angles(math.pi/2,0,0) * CFrame.new(0,0.3,0)
			end
			local offset = hit.CFrame:ToObjectSpace(cf)
			script.Parent.Remotes.Grab:FireServer(hit,offset,side)
			local grip = Instance.new("Motor6D")
			grip.Name = "ClientGrip"
			grip.Part0 = hit
			grip.Part1 = hand
			grip.C0 = offset
			grip.Parent = hand
		end
	end
	local function dropHand(hand, side)
		local grip = hand:FindFirstChild("ClientGrip") or hand:FindFirstChild("Grip")
		if grip and grip.Name == "ClientGrip" then grip:Destroy() end
		if grip and grip.Name == "Grip" then grip:Destroy() end
		script.Parent.Remotes.Drop:FireServer(side)
	end
	leftGrab.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			grabHand(leftHand,"Left")
		end
	end)
	leftGrab.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dropHand(leftHand,"Left") end
	end)
	rightGrab.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
			grabHand(rightHand,"Right")
		end
	end)
	rightGrab.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dropHand(rightHand,"Right") end
	end)
	local rag = makeButton("Ragdoll","RAGDOLL",UDim2.new(1,-104,0,24),UDim2.fromOffset(88,46))
	rag.Activated:Connect(function() ragdoll.Value = not ragdoll.Value end)
	local emote = makeButton("Emote","CLAP",UDim2.new(1,-104,0,78),UDim2.fromOffset(88,46))
	emote.Activated:Connect(function() Emote("Clap") end)
	local third = makeButton("Perspective","VIEW",UDim2.new(1,-104,0,132),UDim2.fromOffset(88,46))
	third.Activated:Connect(function()
		local flag = localPlayer:FindFirstChild("FutureTogglePerspective")
		if flag then flag:Fire() end
	end)
	local unl = makeButton("UnanchorLeft","UNLOCK L",UDim2.new(1,-176,1,-286))
	unl.Activated:Connect(function()
		local g=leftHand:FindFirstChild("ServerGrip") or leftHand:FindFirstChild("ClientGrip")
		if g and g.Part0 then script.Parent.Remotes.Unanchor:FireServer(g.Part0) end
	end)
	local unr = makeButton("UnanchorRight","UNLOCK R",UDim2.new(1,-96,1,-286))
	unr.Activated:Connect(function()
		local g=rightHand:FindFirstChild("ServerGrip") or rightHand:FindFirstChild("ClientGrip")
		if g and g.Part0 then script.Parent.Remotes.Unanchor:FireServer(g.Part0) end
	end)
end
local rightPart, rightOffset, leftPart, leftOffset
local emotes = {
	 Clap = function()
		local t = 1.5
		local start = tick()
		repeat
			RunService.RenderStepped:wait()
			rightPosition.Position = camera.CFrame:pointToWorldSpace(Vector3.new(2 + math.sin(tick() * 50) * 2, -1, -3))
			leftPosition.Position = camera.CFrame:pointToWorldSpace(Vector3.new(-2 - math.sin(tick() * 50) * 2, -1, -3))
			rightGyro.CFrame = camera.CFrame * CFrame.Angles(math.pi / 2, 0, 0)
			leftGyro.CFrame = camera.CFrame * CFrame.Angles(math.pi / 2, 0, 0)
		until t <= tick() - start
	end
}, function()
	local t = 1.5
	local start = tick()
	repeat
		RunService.RenderStepped:wait()
		rightPosition.Position = camera.CFrame:pointToWorldSpace(Vector3.new(2 + math.sin(tick() * 50) * 2, -1, -3))
		leftPosition.Position = camera.CFrame:pointToWorldSpace(Vector3.new(-2 - math.sin(tick() * 50) * 2, -1, -3))
		rightGyro.CFrame = camera.CFrame * CFrame.Angles(math.pi / 2, 0, 0)
		leftGyro.CFrame = camera.CFrame * CFrame.Angles(math.pi / 2, 0, 0)
	until t <= tick() - start
end
local function CanGrab(part)
	if part.Anchored then
		return true
	end
	if part.Parent:FindFirstChild("HumanoidRootPart") then
		return true
	end
	local parts = part:GetConnectedParts(true)
	return true
end
local function Emote(emote)
	if emotes[emote] and not emoting then
		emoting = true
		emotes[emote]()
		emoting = false
	end
end
UserInputService.InputBegan:connect(function(inputObject, processed)
	if not processed then
		if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
			local ray = Ray.new(head.Position, camera.CFrame.lookVector * range)
			local hit, pos, normal = game.Workspace:FindPartOnRay(ray, character)
			if hit and CanGrab(hit) then
				leftHand.Grab:Play()
				local cframe = CFrame.new()
				if hit.Anchored then
					cframe = CFrame.new(pos, pos + normal) * CFrame.Angles(0, math.pi, 0) * CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, 0.3, 0)
				else
					cframe = CFrame.new(pos, pos + camera.CFrame.lookVector) * CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, 0.3, 0)
				end
				local offset = hit.CFrame:toObjectSpace(cframe)
				script.Parent.Remotes.Grab:FireServer(hit, offset, "Left")
				local motor = Instance.new("Motor6D")
				motor.Name = "ClientGrip"
				motor.Part0 = hit
				motor.Part1 = leftHand
				motor.C0 = offset
				motor.Parent = leftHand
				end
			elseif inputObject.KeyCode == Enum.KeyCode.F then
				Emote("clap")
		elseif inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
			local ray = Ray.new(head.Position, camera.CFrame.lookVector * range)
			local hit, pos, normal = game.Workspace:FindPartOnRay(ray, character)
			if hit and CanGrab(hit) then
				rightHand.Grab:Play()
				local cframe = CFrame.new()
				if hit.Anchored then
					cframe = CFrame.new(pos, pos + normal) * CFrame.Angles(0, math.pi, 0) * CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, 0.3, 0)
				else
					cframe = CFrame.new(pos, pos + camera.CFrame.lookVector) * CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, 0.3, 0)
				end
				local offset = hit.CFrame:toObjectSpace(cframe)
				script.Parent.Remotes.Grab:FireServer(hit, offset, "Right")
				local motor = Instance.new("Motor6D")
				motor.Name = "ClientGrip"
				motor.Part0 = hit
				motor.Part1 = rightHand
				motor.C0 = offset
				motor.Parent = rightHand
			end
		end
		if inputObject.KeyCode == Enum.KeyCode.Q then
			if leftHand:FindFirstChild("ServerGrip") then
				local prop = leftHand.ServerGrip.Part0
				script.Parent.Remotes.Unanchor:FireServer(prop)
			elseif leftHand:FindFirstChild("ClientGrip") then
				local prop = leftHand.ClientGrip.Part0
				script.Parent.Remotes.Unanchor:FireServer(prop)
			end
		elseif inputObject.KeyCode == Enum.KeyCode.E then
				if rightHand:FindFirstChild("ServerGrip") then
				local prop = rightHand.ServerGrip.Part0
				script.Parent.Remotes.Unanchor:FireServer(prop)
			elseif rightHand:FindFirstChild("ClientGrip") then
				local prop = rightHand.ClientGrip.Part0
				script.Parent.Remotes.Unanchor:FireServer(prop)
			end
		end
	end
end)
UserInputService.InputEnded:connect(function(inputObject)
	if inputObject.KeyCode == Enum.KeyCode.Q then
		if leftHand:FindFirstChild("Grip") then
			local prop = leftHand.Grip.Part0.Parent
			if prop:FindFirstChild("Events") then
				prop.Events.Deactivate:FireServer()
			end
		end
	elseif inputObject.KeyCode == Enum.KeyCode.E and rightHand:FindFirstChild("Grip") then
		local prop = rightHand.Grip.Part0.Parent
		if prop:FindFirstChild("Events") then
			prop.Events.Deactivate:FireServer()
		end
	end
end)
rightHand.ChildAdded:connect(function(child)
	if child.Name == "Grip" and rightHand:FindFirstChild("ClientGrip") then
		rightHand.ClientGrip:Destroy()
	end
end)
leftHand.ChildAdded:connect(function(child)
	if child.Name == "Grip" and leftHand:FindFirstChild("ClientGrip") then
		leftHand.ClientGrip:Destroy()
	end
end)
UserInputService.InputEnded:connect(function(inputObject, processed)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		if leftHand:FindFirstChild("ClientGrip") then
			leftHand.ClientGrip:Destroy()
		end
		if leftHand:FindFirstChild("Grip") then
			leftHand.Grip:Destroy()
		end
		script.Parent.Remotes.Drop:FireServer("Left")
	elseif inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
		if rightHand:FindFirstChild("ClientGrip") then
			rightHand.ClientGrip:Destroy()
		end
		if rightHand:FindFirstChild("Grip") then
			rightHand.Grip:Destroy()
		end
		script.Parent.Remotes.Drop:FireServer("Right")
	end
end)
RunService:BindToRenderStep("Animate", Enum.RenderPriority.Character.Value, function()
	if ragdoll.Value then
		rightPosition.MaxForce = Vector3.new()
		leftPosition.MaxForce = Vector3.new()
		rightGyro.MaxTorque = Vector3.new()
		leftGyro.MaxTorque = Vector3.new()
	else
		rightPosition.MaxForce = Vector3.new(10000, 10000, 10000)
		leftPosition.MaxForce = Vector3.new(10000, 10000, 10000)
		rightGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
		leftGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
		if not emoting then
			rightPosition.Position = head.CFrame:pointToWorldSpace(Vector3.new(2, -2, -3.5))
			leftPosition.Position = head.CFrame:pointToWorldSpace(Vector3.new(-2, -2, -3.5))
			rightGyro.CFrame = head.CFrame * CFrame.Angles(math.pi / 2, 0, 0)
			leftGyro.CFrame = head.CFrame * CFrame.Angles(math.pi / 2, 0, 0)
		end
	end
end)
end)
spawn(function()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local character = script.Parent
local hips = character:WaitForChild("Hips")
local ragdoll = character:WaitForChild("Ragdoll")
local camera = Workspace.CurrentCamera
local lastUpdate = tick()
local height = 6
local right = true
local rightFoot = character:WaitForChild("Right Foot")
local leftFoot = character:WaitForChild("Left Foot")
local rightPosition = rightFoot:WaitForChild("BodyPosition")
local leftPosition = leftFoot:WaitForChild("BodyPosition")
local rightGyro = rightFoot:WaitForChild("BodyGyro")
local leftGyro = leftFoot:WaitForChild("BodyGyro")
while true do
	wait(0.125)
	local velocity = Vector3.new(hips.Velocity.X, 0, hips.Velocity.Z)
	local speed = velocity.magnitude
	if not ragdoll.Value then
		if speed >= 5 then
			right = not right
			if right then
				local hipPos = hips.CFrame:pointToWorldSpace(Vector3.new(1, 0, 0))
				local footPos = hipPos + Vector3.new(0, -height, 0) + velocity / 4
				local ray = Ray.new(hipPos, footPos - hipPos)
				local hit, pos = Workspace:FindPartOnRay(ray, character)
				if hit then
					rightPosition.MaxForce = Vector3.new(10000, 10000, 10000)
					rightGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
					rightPosition.Position = pos
					rightGyro.CFrame = CFrame.new(Vector3.new(), velocity)
					rightFoot.Boing:Play()
				else
					rightPosition.MaxForce = Vector3.new()
					rightGyro.MaxTorque = Vector3.new()
				end
			else
				local hipPos = hips.CFrame:pointToWorldSpace(Vector3.new(-1, 0, 0))
				local footPos = hipPos + Vector3.new(0, -height, 0) + velocity / 4
				local ray = Ray.new(hipPos, footPos - hipPos)
				local hit, pos = Workspace:FindPartOnRay(ray, character)
				if hit then
					leftPosition.MaxForce = Vector3.new(10000, 10000, 10000)
					leftGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
					leftPosition.Position = pos
					leftGyro.CFrame = CFrame.new(Vector3.new(), velocity)
					leftFoot.Boing:Play()
				else
					leftPosition.MaxForce = Vector3.new()
					leftGyro.MaxTorque = Vector3.new()
				end
			end
		else
			local rightRay = Ray.new(hips.CFrame:pointToWorldSpace(Vector3.new(1, 0, 0)), Vector3.new(0, -height, 0))
			local rHit, rPos = Workspace:FindPartOnRay(rightRay, character)
			if rHit then
				rightPosition.MaxForce = Vector3.new(10000, 10000, 10000)
				rightGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
				rightPosition.Position = rPos
				rightGyro.CFrame = CFrame.new(Vector3.new(), Vector3.new(hips.CFrame.lookVector.X, 0, hips.CFrame.lookVector.Z))
			else
				rightPosition.MaxForce = Vector3.new()
				rightGyro.MaxTorque = Vector3.new()
			end
			local leftRay = Ray.new(hips.CFrame:pointToWorldSpace(Vector3.new(-1, 0, 0)), Vector3.new(0, -height, 0))
			local lHit, lPos = Workspace:FindPartOnRay(leftRay, character)
			if lHit then
				leftPosition.MaxForce = Vector3.new(10000, 10000, 10000)
				leftGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
				leftPosition.Position = lPos
				leftGyro.CFrame = CFrame.new(Vector3.new(), Vector3.new(hips.CFrame.lookVector.X, 0, hips.CFrame.lookVector.Z))
			else
				leftPosition.MaxForce = Vector3.new()
				leftGyro.MaxTorque = Vector3.new()
			end
		end
	else
		rightPosition.MaxForce = Vector3.new()
		rightGyro.MaxTorque = Vector3.new()
		leftPosition.MaxForce = Vector3.new()
		leftGyro.MaxTorque = Vector3.new()
	end
end
end)
end
local a3 = function(script)
	wait()
workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
spawn(function()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local x, y = 0, 0
local thirdPerson = false
local character, head, health, ragdoll, hat, bodyGyro
local function Character(newCharacter)
	wait(0.1)
	if newCharacter and newCharacter.Parent then
		character, head, health, ragdoll, hat = nil, nil, nil, nil, nil
		head = newCharacter:WaitForChild("Head")
		health = newCharacter:WaitForChild("Health")
		ragdoll = newCharacter:WaitForChild("Ragdoll")
		bodyGyro = head:WaitForChild("BodyGyro")
		hat = newCharacter:WaitForChild("Hat")
		if not thirdPerson then
			for _, v in pairs(hat:GetChildren()) do
				if v:IsA("BasePart") then
					v.LocalTransparencyModifier = 1
				end
			end
		end
		ragdoll.Changed:connect(function()
			for _, v in pairs(hat:GetChildren()) do
				if v:IsA("BasePart") then
					v.LocalTransparencyModifier = (thirdPerson or ragdoll.Value) and v.Transparency or 1
				end
			end
		end)
		character = newCharacter
	end
end
UserInputService.InputChanged:connect(function(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement then
		x = (x - inputObject.Delta.X / 260) % (math.pi * 2)
		y = math.clamp(y - inputObject.Delta.Y / 260, -1.45, 1.45)
	elseif inputObject.UserInputType == Enum.UserInputType.Touch and not (mobileGui and inputObject.Position.X < 220 and inputObject.Position.Y > 0) then
		x = (x - inputObject.Delta.X / 260) % (math.pi * 2)
		y = math.clamp(y - inputObject.Delta.Y / 260, -1.45, 1.45)
	end
end)
UserInputService.InputBegan:connect(function(inputObject, processed)
	if not processed and inputObject.KeyCode == Enum.KeyCode.V then
		thirdPerson = not thirdPerson
	end
end)
camera.CameraType = Enum.CameraType.Scriptable
camera.FieldOfView = 90
if not UserInputService.TouchEnabled then
	UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end
local perspectiveToggle = Instance.new("BindableEvent")
perspectiveToggle.Name = "FutureTogglePerspective"
perspectiveToggle.Parent = localPlayer
perspectiveToggle.Event:Connect(function() thirdPerson = not thirdPerson end)
Character(localPlayer.Character)
spawn(function()
	while wait(.2) do
		if not UserInputService.TouchEnabled then UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter end
	end
end)
function lerp(a,b,t)
	return a + (b-a)*t
end
local ofs = 0
local trs = 1
RunService:BindToRenderStep("Camera", Enum.RenderPriority.Camera.Value, function()
	if character and head then
		if ragdoll.Value or thirdPerson then
			camera.CFrame = CFrame.new(head.Position) * CFrame.Angles(0, x, 0) * CFrame.Angles(y, 0, 0) * CFrame.new(0, 0, ofs)
			ofs = lerp(ofs,14,.1)
			trs = lerp(trs,0,.2)
		else
			camera.CFrame = CFrame.new(head.Position) * CFrame.Angles(0, x, 0) * CFrame.Angles(y, 0, 0) * CFrame.new(0, 0, ofs)
			ofs = lerp(ofs,0,.1)
			if ofs < 1.2 then
				trs = 1
			end
		end
		if health.Value > 0 and not ragdoll.Value then
			bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
			bodyGyro.CFrame = camera.CFrame
		else
			bodyGyro.MaxTorque = Vector3.new()
		end
		if hat then
			for _, v in pairs(hat:GetChildren()) do
				if v:IsA("BasePart") then
					v.LocalTransparencyModifier = trs
				end
			end
		end
	end
	camera.Focus = camera.CFrame * CFrame.new(0, 0, -20)
end)
end)
spawn(function()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local function KeyDown(key)
	return localPlayer:GetAttribute("FutureKey_" .. key.Name) == true or UserInputService:IsKeyDown(key)
end
local camera = Workspace.CurrentCamera
local height = 6
local walkspeed = 20
local jumpPower = 300
local character, hips, health, ragdoll, bodyPosition, bodyGyro, bodyVelocity
spawn(function()
	wait(0.1)
	local resetBindable = Instance.new("BindableEvent")
	resetBindable.Event:connect(function()
	workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
UserInputService.MouseBehavior = Enum.MouseBehavior.Default
		script.Parent.Remotes.Reset:FireServer()
	end)
	game:GetService("StarterGui"):SetCore("ResetButtonCallback", resetBindable)
end)
local GetParts = function(model)
	local parts = {}
	local function get(obj)
		for _, v in pairs(obj:GetChildren()) do
			if v:IsA("BasePart") then
				table.insert(parts, v)
			else
				get(v)
			end
		end
	end
	get(model)
	return parts
end
local function Character(newCharacter)
	wait(0.1)
	if newCharacter and newCharacter.Parent then
		character, hips, health, ragdoll = nil, nil, nil, nil
		bodyPosition, bodyGyro, bodyVelocity = nil, nil, nil
		hips = newCharacter:WaitForChild("Hips")
		health = newCharacter:WaitForChild("Health")
		ragdoll = newCharacter:WaitForChild("Ragdoll")
		bodyPosition = hips:WaitForChild("BodyPosition")
		bodyGyro = hips:WaitForChild("BodyGyro")
		bodyVelocity = hips:WaitForChild("BodyVelocity")
		character = newCharacter
	end
end
local function GrabbingAnchored()
	local rightGrip = character["Right Hand"]:FindFirstChild("Grip") or character["Right Hand"]:FindFirstChild("ClientGrip")
	if rightGrip and rightGrip.Part0.Anchored then
		return true
	end
	local leftGrip = character["Left Hand"]:FindFirstChild("Grip") or character["Left Hand"]:FindFirstChild("ClientGrip")
	if leftGrip and leftGrip.Part0.Anchored then
		return true
	end
	return false
end
UserInputService.InputBegan:connect(function(inputObject, processed)
	if not processed and inputObject.KeyCode == Enum.KeyCode.R and ragdoll then
		ragdoll.Value = not ragdoll.Value
	end
end)
print(localPlayer.Character.Name)
Character(localPlayer.Character)
RunService:BindToRenderStep("Control", Enum.RenderPriority.Input.Value, function()
	if character and hips then
		if health.Value > 0 and not ragdoll.Value then
			bodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
			bodyGyro.CFrame = camera.CFrame
			local h, w = height, walkspeed
			local grounded = false
			if not UserInputService:GetFocusedTextBox() then
				if KeyDown(Enum.KeyCode.LeftShift) then
					w = w * 5
					h=h*1.5
				elseif KeyDown(Enum.KeyCode.C) then
					h = h * 0.4
					w = w * 0.8
				end
			end
			local ray = Ray.new(hips.Position, Vector3.new(0, -h, 0))
			local hit, position = Workspace:FindPartOnRay(ray, character)
			if hit then
				grounded = true
				bodyPosition.MaxForce = Vector3.new(0, 10000, 0)
				bodyPosition.Position = position + Vector3.new(0, h, 0)
			else
				bodyPosition.MaxForce = Vector3.new()
			end
			local movement = Vector3.new()
			if not UserInputService:GetFocusedTextBox() then
				if KeyDown(Enum.KeyCode.W) then
					movement = movement + Vector3.new(0, 0, -1)
				end
				if KeyDown(Enum.KeyCode.S) then
					movement = movement + Vector3.new(0, 0, 1)
				end
				if KeyDown(Enum.KeyCode.D) then
					movement = movement + Vector3.new(1, 0, 0)
				end
				if KeyDown(Enum.KeyCode.A) then
					movement = movement + Vector3.new(-1, 0, 0)
				end
				if grounded and KeyDown(Enum.KeyCode.Space) and not GrabbingAnchored() then
					local force = jumpPower
					local mass = 0
					local rightGrip = character["Right Hand"]:FindFirstChild("Grip") or character["Right Hand"]:FindFirstChild("ClientGrip")
					if rightGrip then
						local parts = GetParts(rightGrip.Part0.Parent)
						for _, part in pairs(parts) do
							mass = mass + part:GetMass()
						end
					end
					local leftGrip = character["Left Hand"]:FindFirstChild("Grip") or character["Left Hand"]:FindFirstChild("ClientGrip")
					if leftGrip then
						local parts = GetParts(leftGrip.Part0.Parent)
						for _, part in pairs(parts) do
							mass = mass + part:GetMass()
						end
					end
					force = force / math.max(mass * 0.1, 1)
					character:SetPrimaryPartCFrame(hips.CFrame + Vector3.new(0, 0.5, 0))
					bodyPosition.MaxForce = Vector3.new()
					character["Right Foot"].BodyPosition.MaxForce = Vector3.new()
					character["Left Foot"].BodyPosition.MaxForce = Vector3.new()
					hips.Velocity = hips.Velocity + Vector3.new(0, force, 0)
				end
			end
			if 0 < movement.magnitude then
				movement = camera.CFrame:vectorToWorldSpace(movement)
				movement = Vector3.new(movement.X, 0, movement.Z).unit
			end
			bodyVelocity.MaxForce = Vector3.new(10000, 0, 10000)
			bodyVelocity.Velocity = movement * w
		else
			bodyGyro.MaxTorque = Vector3.new()
			bodyVelocity.MaxForce = Vector3.new()
			bodyPosition.MaxForce = Vector3.new()
		end
	end
end)
end)
end
local a4 = game:GetObjects("rbxassetid://7089500700")[1]
local a5 = a4["Future2"]
local plr = game:GetService("Players").LocalPlayer
local plname = plr.Name
local futureisntbright = a5:FindFirstChild("Future"):clone()
local jeb = futureisntbright:WaitForChild("jeb")
local jeb1 = futureisntbright:WaitForChild("jeb1")
futureisntbright.owner.Value = plname
futureisntbright.Parent = workspace
jeb1.reach.Value = "12"
jeb.Parent = futureisntbright
jeb1.Parent = futureisntbright
task.spawn(a3, jeb)
task.spawn(a2, jeb1)
task.spawn(a1, futureisntbright)
