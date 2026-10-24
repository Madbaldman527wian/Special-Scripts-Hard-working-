local qx_Pl = game:GetService("Players")
local qx_LP = qx_Pl.LocalPlayer
local qx_G = getfenv()
local qx_A = game:GetObjects("rbxassetid://6099241563")[1]
local qx_S = {}
local qx_M = {}
local qx_H = setmetatable({}, {__mode = "k"})
local qx_X = setmetatable({}, {__mode = "k"})
local qx_T = setmetatable({}, {__mode = "k"})
local qx_C = setmetatable({}, {__mode = "k"})
local qx_n = 0
local qx_R

local function qx_tk(i, th)
	local t = qx_T[i]
	if not t then
		t = {}
		qx_T[i] = t
	end
	t[th] = true
	qx_n = qx_n + 1
	if qx_n % 256 == 0 then
		for h in pairs(t) do
			if coroutine.status(h) == "dead" then
				t[h] = nil
			end
		end
	end
	return th
end

local function qx_ca(i)
	local t = qx_T[i]
	if t then
		qx_T[i] = nil
		local r = coroutine.running()
		for h in pairs(t) do
			if h == r then
				task.defer(function()
					pcall(task.cancel, h)
				end)
			else
				pcall(task.cancel, h)
			end
		end
	end
end

local function qx_mk(i)
	local e = {script = i}
	e.coroutine = setmetatable({
		create = function(f)
			return qx_tk(i, coroutine.create(f))
		end,
		wrap = function(f)
			local c = qx_tk(i, coroutine.create(f))
			return function(...)
				local r = table.pack(coroutine.resume(c, ...))
				if r[1] then
					return table.unpack(r, 2, r.n)
				end
				error(r[2], 0)
			end
		end
	}, {__index = coroutine})
	e.require = function(m)
		if typeof(m) == "Instance" and qx_M[m:GetAttribute("_k") or ""] then
			return qx_R(m)
		end
		return qx_G.require(m)
	end
	return setmetatable(e, {__index = qx_G})
end

qx_R = function(m)
	local c = qx_C[m]
	if c then
		if c.s == 1 then
			error("Requested module was required recursively", 2)
		end
		return c.v
	end
	c = {s = 1}
	qx_C[m] = c
	local f = qx_M[m:GetAttribute("_k")]()
	setfenv(f, qx_mk(m))
	local ok, r = pcall(function()
		return table.pack(f())
	end)
	if not ok then
		qx_C[m] = nil
		error(r, 0)
	end
	if r.n ~= 1 then
		qx_C[m] = nil
		error("Module code did not return exactly one value", 2)
	end
	c.s = 2
	c.v = r[1]
	return c.v
end

local function qx_RS(e, f)
	local t = qx_H[e]
	if not t then
		t = {}
		qx_H[e] = t
	end
	t[#t + 1] = f
	local d = {Connected = true}
	d.Disconnect = function()
		d.Connected = false
		local p = table.find(t, f)
		if p then
			table.remove(t, p)
		end
	end
	d.disconnect = d.Disconnect
	return d
end

local function qx_RF(e, ...)
	e:FireServer(...)
	local t = qx_H[e]
	if t then
		local a = table.pack(...)
		for _, f in ipairs(table.clone(t)) do
			task.defer(f, qx_LP, table.unpack(a, 1, a.n))
		end
	end
end

local function qx_RA(e, ...)
	if firesignal then
		return firesignal(e.OnClientEvent, ...)
	end
end

local function qx_ok(i)
	return i:GetAttribute("_r") or not i.Disabled
end

local function qx_go(i)
	local k = i:GetAttribute("_k")
	local g = k and qx_S[k]
	if not g or qx_X[i] then
		return
	end
	if not qx_ok(i) then
		local c
		c = i:GetPropertyChangedSignal("Disabled"):Connect(function()
			if qx_ok(i) then
				c:Disconnect()
				qx_go(i)
			end
		end)
		return
	end
	qx_X[i] = true
	local f = g()
	setfenv(f, qx_mk(i))
	i.Destroying:Connect(function()
		qx_ca(i)
	end)
	i.AncestryChanged:Connect(function()
		if not i:IsDescendantOf(game) then
			qx_ca(i)
		end
	end)
	task.spawn(function()
		qx_tk(i, coroutine.running())
		f()
	end)
end

qx_M["a1"] = function()
	return function()
local module = {}
function module.load(player)
	local given = script:FindFirstChildOfClass("Script"):Clone()
	given.Disabled = false
	given.Parent=game:GetService("Players")[player].Backpack
end
return module
	end
end

qx_S["a2"] = function()
	return function()
repeat wait() until script.Parent.Parent ~= nil
local Player = script.Parent.Parent
local Mouse,mouse,UserInputService,ContextActionService
do
	local CAS = {Actions={}}
	local Event = Instance.new("RemoteEvent")
	Event.Name = "UserInput_Event"
	Event.Parent = Player.Character
	local fakeEvent = function()
		local t = {_fakeEvent=true}
		t.Connect = function(self,f)self.Function=f end
		t.connect = t.Connect
		return t
	end
    local m = {Target=nil,Hit=CFrame.new(),KeyUp=fakeEvent(),KeyDown=fakeEvent(),Button1Up=fakeEvent(),Button1Down=fakeEvent()}
	local UIS = {InputBegan=fakeEvent(),InputEnded=fakeEvent()}
	function CAS:BindAction(name,fun,touch,...)
		CAS.Actions[name] = {Name=name,Function=fun,Keys={...}}
	end
	function CAS:UnbindAction(name)
		CAS.Actions[name] = nil
	end
	local function te(self,ev,...)
		local t = m[ev]
		if t and t._fakeEvent and t.Function then
			t.Function(...)
		end
	end
	m.TrigEvent = te
	UIS.TrigEvent = te
	qx_RS(Event, function(plr,io)
	    if plr~=Player then return end
		if io.isMouse then
			m.Target = io.Target
			m.Hit = io.Hit
		elseif io.UserInputType == Enum.UserInputType.MouseButton1 then
	        if io.UserInputState == Enum.UserInputState.Begin then
				m:TrigEvent("Button1Down")
			else
				m:TrigEvent("Button1Up")
			end
		else
			for n,t in pairs(CAS.Actions) do
				for _,k in pairs(t.Keys) do
					if k==io.KeyCode then
						t.Function(t.Name,io.UserInputState,io)
					end
				end
			end
	        if io.UserInputState == Enum.UserInputState.Begin then
	            m:TrigEvent("KeyDown",io.KeyCode.Name:lower())
				UIS:TrigEvent("InputBegan",io,false)
			else
				m:TrigEvent("KeyUp",io.KeyCode.Name:lower())
				UIS:TrigEvent("InputEnded",io,false)
	        end
	    end
	end)
	Mouse,mouse,UserInputService,ContextActionService = m,m,UIS,CAS
end

Player=script.Parent.Parent
Character=Player.Character
Character.Humanoid.Name = "noneofurbusiness"
hum = Character.noneofurbusiness
LeftArm=Character["Left Arm"]
LeftLeg=Character["Left Leg"]
RightArm=Character["Right Arm"]
RightLeg=Character["Right Leg"]
Root=Character["HumanoidRootPart"]
Head=Character["Head"]
Torso=Character["Torso"]
RootJoint = Root["RootJoint"]
Neck = Torso["Neck"]
RightShoulder = Torso["Right Shoulder"]
LeftShoulder = Torso["Left Shoulder"]
RightHip = Torso["Right Hip"]
LeftHip = Torso["Left Hip"]
walking = false
debounce = false
attacking = false
tauntdebounce = false
themeallow = true
secondform = false
m2hallow = false
position = nil
MseGuide = true
girl = false
equipping = false
varsp = 1
settime = 0
sine = 0
sine2 = 0
ws = 120
hpheight = 1.5
change = 1
change2 = .8
dgs = 75
RunSrv = game:GetService("RunService")
RenderStepped = game:GetService("RunService").RenderStepped
removeuseless = game:GetService("Debris")
smoothen = game:GetService("TweenService")
cam = workspace.CurrentCamera
lig = game:GetService("Lighting")
local armorparts = {1,2}
local dmt2 = {1843358057,4558398377}
local bloodfolder = Instance.new("Folder",Torso)
local introable = {4591927570,4591936781,4591937586,4591937895,4591938363,4591938832,4591941299,4591941817}
local fireable = {4611185293,4611185698,4611184354,4611184817}
local firekillable = {4611187644,4611186611,4611186138}
local damagable = {1,2}
local attackable = {4614474035,4614474491,4614474930,4614475327,4614475760,4614476430,4614477011,4614477539,4614477980,4614478550,4614479082,4614479500,4614479928,4614480500,4614481083}
local cowardable = {1,2}
local followable = {4620497575,4620498118,4620498754,4620499179,4620499755}
local killable = {4673844363,4673848773,4673849571,4673877422,4673880146,4673881182,4673881958,4673882852,4673883581,4673886551,4673887593,4673892311,4673893081,4673894021}
local roarable = {1,2}
local chargable = {1,2}
local ouchable = {1,2}
local tauntable = {4563118321,4563118321}
local tauntable2 = {4592338195,4592338768,4592339199,4592340047,4592304446,4592337281,4592337771}
local rdx = {"Really black","Really red"}
local girlemy = script.enemy:Clone()
local realhead = script.head:Clone() realhead.Parent = Torso
local realhead2 = script.secondhead:Clone()
local staff = script.staff:Clone()
local energyball = script.energb:Clone()
local spkball = script.Effects.spikeball
local shckwav = script.Effects.shockwave
local spkball2 = script.Effects.ball
local explse = script.Effects.exploseball
local cards = script.cards
local wosh = script.Effects.woosh
local dox = false
local previd = nil
pcall(function()
script.intro.Parent = game:GetService("ServerStorage")
end)

Root.Size = Vector3.new(2.623, 2.623, 1.311)
LeftArm.Size = Vector3.new(1.311, 2.623, 1.311)
Torso.Size = Vector3.new(2.623, 2.623, 1.311)
RightArm.Size = Vector3.new(1.311, 2.623, 1.311)
RightLeg.Size = Vector3.new(1.311, 2.623, 1.311)
LeftLeg.Size = Vector3.new(1.311, 2.623, 1.311)
Head.Size = Vector3.new(2.623, 1.311, 1.311)
RootJoint.Parent = Root
Neck.Parent = Torso
RightShoulder.Parent = Torso
LeftShoulder.Parent = Torso
RightHip.Parent = Torso
LeftHip.Parent = Torso
local fkhead = realhead.mainp
local fkhead2 = realhead2.mainp
local skully = script.skully:Clone()
local axe = script.pickaxe:Clone() axe.Parent = Torso
local skully2 = script.skullscript:Clone()

for i,v in pairs(Character:GetDescendants()) do
if v:IsA("Accessory") then v:Destroy() end end
for i,v in pairs(Character:GetDescendants()) do
if v:IsA("Shirt") then v:Destroy() end end
for i,v in pairs(Character:GetDescendants()) do
if v:IsA("Pants") then v:Destroy() end end
screenGui = Instance.new("ScreenGui")
screenGui.Parent = script.Parent

local HEADLERP = Instance.new("ManualWeld")
HEADLERP.Parent = Head
HEADLERP.Part0 = Head
HEADLERP.Part1 = Torso
HEADLERP.C0 = CFrame.new(0, -1.5, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local TORSOLERP = Instance.new("ManualWeld")
TORSOLERP.Parent = Root
TORSOLERP.Part0 = Torso
TORSOLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local ROOTLERP = Instance.new("ManualWeld")
ROOTLERP.Parent = Root
ROOTLERP.Part0 = Root
ROOTLERP.Part1 = Torso
ROOTLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local RIGHTARMLERP = Instance.new("ManualWeld")
RIGHTARMLERP.Parent = RightArm
RIGHTARMLERP.Part0 = RightArm
RIGHTARMLERP.Part1 = Torso
RIGHTARMLERP.C0 = CFrame.new(-1.5, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local LEFTARMLERP = Instance.new("ManualWeld")
LEFTARMLERP.Parent = LeftArm
LEFTARMLERP.Part0 = LeftArm
LEFTARMLERP.Part1 = Torso
LEFTARMLERP.C0 = CFrame.new(1.5, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local RIGHTLEGLERP = Instance.new("ManualWeld")
RIGHTLEGLERP.Parent = RightLeg
RIGHTLEGLERP.Part0 = RightLeg
RIGHTLEGLERP.Part1 = Torso
RIGHTLEGLERP.C0 = CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local LEFTLEGLERP = Instance.new("ManualWeld")
LEFTLEGLERP.Parent = LeftLeg
LEFTLEGLERP.Part0 = LeftLeg
LEFTLEGLERP.Part1 = Torso
LEFTLEGLERP.C0 = CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local AXELERP = Instance.new("ManualWeld")
AXELERP.Parent = axe
AXELERP.Part0 = axe
AXELERP.Part1 = RightArm
AXELERP.C0 = CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local STAFFLERP = Instance.new("ManualWeld")
STAFFLERP.Parent = LeftArm
STAFFLERP.Part0 = nil
STAFFLERP.Part1 = nil

local function weldBetween(a, b)
    local weld = Instance.new("ManualWeld", a)
    weld.Part0 = a
    weld.Part1 = b
    weld.C0 = a.CFrame:inverse() * b.CFrame
    return weld
end
local leftlocation = Instance.new("Part",Torso)
leftlocation.Size = Vector3.new(.1,.1,.1)
leftlocation.Anchored = false
leftlocation.Massless = true
leftlocation.Transparency = 1
leftlocation.CanCollide = false
local leftlocationweld = weldBetween(leftlocation,LeftArm)
leftlocationweld.C0 = CFrame.new(0,2.05,0)
local rightlocation = Instance.new("Part",Torso)
rightlocationSize = Vector3.new(.1,.1,.1)
rightlocation.Anchored = false
rightlocation.Massless = true
rightlocation.Transparency = 1
rightlocation.CanCollide = false
local rightlocationweld = weldBetween(rightlocation,RightArm)
rightlocationweld.C0 = CFrame.new(0,2.05,0)
local leftlocation2 = Instance.new("Part",Torso)
leftlocation2.Size = Vector3.new(.1,.1,.1)
leftlocation2.Anchored = false
leftlocation2.Massless = true
leftlocation2.Transparency = 1
leftlocation2.CanCollide = false
local leftlocationweld2 = weldBetween(leftlocation2,RightLeg)
leftlocationweld2.C0 = CFrame.new(0,1.85,0)

local hdweld = weldBetween(fkhead,Head)

local shirt = Instance.new("Shirt",Character)
shirt.ShirtTemplate = "rbxassetid://215295188"
local pants = Instance.new("Pants",Character)
pants.PantsTemplate = "rbxassetid://215295280"

local a = Instance.new("Part",Torso)
a.Size = Vector3.new(1,1,1)
a.Anchored = false
a.CanCollide = false
a.Massless = true
a.Transparency = 1
a.CFrame = Root.CFrame
local aweld = weldBetween(a,Root)
local z = 0
local cardtable={}
for i,v in pairs(cards:GetChildren()) do
	table.insert(cardtable,v)
end
for i = 1, 25 do
	z = z + 20
	local randomc = math.random(1,#cardtable)
	local pick = cardtable[randomc]
	local cardo = pick:Clone() cardo.Parent = Torso cardo.Massless = true cardo.Anchored = false
	local bweld = weldBetween(cardo,a) bweld.C0 = CFrame.new(0,0,6.25) * CFrame.Angles(0,math.rad(z),0)
	bweld.C1 = CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
	coroutine.wrap(function()
		local time = .5
		local randomtime1 = math.random(-7.5,7.5)/10
		local randomtime2 = math.random(-7.5,7.5)/10
		local randomtime3 = math.random(-7.5,7.5)/10
		local anotherrandomtime = math.random(-1,1)/18
		while game:GetService("RunService").Stepped:wait() do
			bweld.C1 = bweld.C1:lerp(CFrame.Angles(math.rad(0),math.rad(time),math.rad(0)),.2)
			bweld.C0 = bweld.C0*CFrame.new(anotherrandomtime*math.sin(sine/32),anotherrandomtime*math.sin(sine/32),anotherrandomtime*math.sin(sine/32))* CFrame.Angles(math.rad(0+randomtime1),math.rad(0+randomtime2),math.rad(0+-randomtime3))
		end
	end)()
end

function MAKETRAIL(PARENT,POSITION1,POSITION2,LIFETIME,COLOR)
local A = Instance.new("Attachment", PARENT)
A.Position = POSITION1
A.Name = "A"
local B = Instance.new("Attachment", PARENT)
B.Position = POSITION2
B.Name = "B"
local x = Instance.new("Trail", PARENT)
x.Attachment0 = A
x.Attachment1 = B
x.Enabled = true
x.Lifetime = LIFETIME
x.TextureMode = "Static"
x.LightInfluence = 0
x.Color = COLOR
x.Transparency = NumberSequence.new(0, 1)
end

function ray(pos, di, ran, ignore)
	return workspace:FindPartOnRay(Ray.new(pos, di.unit * ran), ignore)
end

function ray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return ray(StartPos, di, Distance, Ignore)
end

function colortween(a,speed,color1)
local z = {
Color = color1
}
local tween = smoothen:Create(a,TweenInfo.new(speed,Enum.EasingStyle.Linear),z)
tween:Play()
end

function takeDamage(victim,damage)
if victim.MaxHealth < 50000 and victim ~= hum then
victim.Health = victim.Health - damage
if victim.Health < 1 then
killtaunt()
end
else
victim.Parent:BreakJoints()
killtaunt()
end
end

function death(chara)
	for i,v in pairs(chara:GetDescendants()) do
		if v:IsA("Part") or v:IsA("MeshPart") then 
			v.Transparency = 1
			local mrandom = math.random(1,2)
			if mrandom == 1 then
	local randomc = math.random(1,#cardtable)
	local pick = cardtable[randomc]
	local cardz = pick:Clone() cardz.Parent = Torso
	cardz.Size = Vector3.new(1, 0.05, 1.5)
	cardz.Transparency = 0
	cardz.Material = "Neon"
	cardz.CFrame = v.CFrame
	cardz.Anchored = false
	cardz.CanCollide = true
	removeuseless:AddItem(cardz,math.random(10,20))
			end
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
if not secondform then
local bell = Instance.new("Sound",Torso)
bell.SoundId = "rbxassetid://4577865183"
bell.Volume = 10
bell.Pitch = math.random(9,10)/10
bell:Play()
repeat swait() until bell.TimePosition > 3
rdnm2 = tauntable[math.random(1,#tauntable)]
local tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = math.random(9.5,10.5)/10
tauntsound:Play()
coroutine.wrap(function()
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,6)
elseif secondform then
local rdnm2 = killable[math.random(1,#killable)]
for i = 1, 2 do
local tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
coroutine.wrap(function()
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,6)
end
end
end)()
				local soundbox = Instance.new("Part",Torso)
				soundbox.CFrame = v.CFrame
				soundbox.Anchored = true
				soundbox.CanCollide = false
				soundbox.Transparency = 1
				soundbox.Size = Vector3.new(1,1,1)
				SOUND(soundbox,4610425194,10,false,math.random(9,11)/10,5)
				removeuseless:AddItem(soundbox,5)
			local clone = v:Clone() clone.Parent = Torso clone.Transparency = 0
			local a = Instance.new("Part",Torso)
			a.Anchored = true
			a.CanCollide = false
			a.Transparency = 1
			a.CFrame = v.CFrame * CFrame.new(math.random(-10,10),math.random(-10,10),math.random(-5,10))
			coroutine.wrap(function()
				local z1 = math.random(-180,180)
				local z2 = math.random(-180,180)
				local z3 = math.random(-180,180)
				clone.Anchored = true
				clone.CanCollide = false
				for i = 1, 40 do
					clone.Transparency = clone.Transparency + .05
					clone.CFrame = clone.CFrame:lerp(CFrame.new(a.Position)*CFrame.Angles(math.rad(z1),math.rad(z2),math.rad(z3)),.125)
					swait()
				end
				a:Destroy()
				clone:Destroy()
			end)()
		end
	end
	chara:Destroy()
end

function taunt()
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
if not secondform then
local bell = Instance.new("Sound",Torso)
bell.SoundId = "rbxassetid://4577865183"
bell.Volume = 10
bell.Pitch = math.random(9,10)/10
bell:Play()
repeat swait() until bell.TimePosition > 3
rdnm2 = tauntable[math.random(1,#tauntable)]
local tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = math.random(9.5,10.5)/10
tauntsound:Play()
coroutine.wrap(function()
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,6)
elseif secondform then
local rdnm2 = tauntable2[math.random(1,#tauntable2)]
for i = 1, 2 do
local tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
coroutine.wrap(function()
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,6)
end
end
end)()
end

function attacktaunt2()
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
local rdnm2 = followable[math.random(1,#followable)]
for i = 1, 2 do
tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
coroutine.wrap(function()
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,6)
end
end)()
end

function attacktaunt()
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
local rdnm2 = attackable[math.random(1,#attackable)]
for i = 1, 2 do
tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
coroutine.wrap(function()
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,6)
end
end)()
end

function killtaunt()
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
local rdnm2 = killable[math.random(1,#killable)]
for i = 1, 3 do
coroutine.wrap(function()
tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "http://www.roblox.com/asset/?id="..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
wait(.5)
wait(tauntsound.TimeLength)
tauntsound:Destroy()
tauntdebounce = false
end)()
end
end)()
end

function velo(a,name,pos,speed)
local bov = Instance.new("BodyVelocity",a)
bov.Name = name
bov.maxForce = Vector3.new(99999,99999,99999)
a.CFrame = CFrame.new(a.Position,pos)
bov.velocity = a.CFrame.lookVector*speed
end
function bolt(parent,from,too,endtarget,color,size,mat,offset)
local function iray(pos, di, ran, ignore)
local ing={endtarget}
	return workspace:FindPartOnRayWithWhitelist(Ray.new(pos, di.unit * ran),ing)
end
local function iray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return iray(StartPos, di, Distance, Ignore)
end
lastposition = from
local step = 16
local distance = (from-too).magnitude
for i = 1,distance, step do
local from = lastposition
local too = from + -(from-too).unit*step+ Vector3.new(math.random(-offset,offset),math.random(-offset,offset),math.random(-offset,offset))
local bolt = Instance.new("Part",parent)
bolt.Size = Vector3.new(size,size,(from-too).magnitude)
bolt.Anchored = true
bolt.CanCollide = false
bolt.Name = "supeffect"
bolt.BrickColor = color
bolt.Material = mat
bolt.CFrame = CFrame.new(from:lerp(too,.5),too)
lastposition = too
coroutine.wrap(function()
for i = 1, 5 do
bolt.Transparency = bolt.Transparency + .2
wait()
end
bolt:Destroy()
end)()
end
local lastbolt = Instance.new("Part",parent)
lastbolt.Size = Vector3.new(1,1,(from-too).magnitude)
lastbolt.Anchored = true
lastbolt.CanCollide = false
lastbolt.BrickColor = color
lastbolt.Name = "supeffect"
lastbolt.Material = mat
lastbolt.CFrame = CFrame.new(lastposition,too)
lastbolt.Size = Vector3.new(size,size,size)
local start = lastposition
local hit,endp = iray2(lastposition,too,650,lastbolt)
local dis = (start - endp).magnitude
lastbolt.CFrame = CFrame.new(lastposition,too) * CFrame.new(0,0,-dis/2)
if dis < 20 then
lastbolt.Size = Vector3.new(size,size,dis)
else
lastbolt.Size = Vector3.new(size,size,20)
end
coroutine.wrap(function()
for i = 1, 5 do
lastbolt.Transparency = lastbolt.Transparency + .2
wait()
end
lastbolt:Destroy()
end)()
end
function littlebolt(parent,from,too,endtarget,color,size,mat,offset)
local function iray(pos, di, ran, ignore)
local ing={endtarget}
	return workspace:FindPartOnRayWithWhitelist(Ray.new(pos, di.unit * ran),ing)
end
local function iray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return iray(StartPos, di, Distance, Ignore)
end
lastposition = from
local step = 1
local distance = (from-too).magnitude
for i = 1,distance, step do
local from = lastposition
local too = from + -(from-too).unit*step+ Vector3.new(math.random(-offset,offset),math.random(-offset,offset),math.random(-offset,offset))
local bolt = Instance.new("Part",parent)
bolt.Size = Vector3.new(size,size,(from-too).magnitude)
bolt.Anchored = true
bolt.CanCollide = false
bolt.Name = "supeffect"
bolt.BrickColor = color
bolt.Material = mat
bolt.CFrame = CFrame.new(from:lerp(too,.5),too)
lastposition = too
coroutine.wrap(function()
for i = 1, 5 do
bolt.Transparency = bolt.Transparency + .2
wait()
end
bolt:Destroy()
end)()
end
local lastbolt = Instance.new("Part",parent)
lastbolt.Size = Vector3.new(1,1,(from-too).magnitude)
lastbolt.Anchored = true
lastbolt.CanCollide = false
lastbolt.BrickColor = color
lastbolt.Name = "supeffect"
lastbolt.Material = mat
lastbolt.CFrame = CFrame.new(lastposition,too)
lastbolt.Size = Vector3.new(size,size,size)
local start = lastposition
local hit,endp = iray2(lastposition,too,650,lastbolt)
local dis = (start - endp).magnitude
lastbolt.CFrame = CFrame.new(lastposition,too) * CFrame.new(0,0,-dis/2)
if dis < 20 then
lastbolt.Size = Vector3.new(size,size,dis)
else
lastbolt.Size = Vector3.new(size,size,20)
end
coroutine.wrap(function()
for i = 1, 5 do
lastbolt.Transparency = lastbolt.Transparency + .2
wait()
end
lastbolt:Destroy()
end)()
end
function ballshockwave(position,transparency,brickcolor,mate,transparencyincrease,size)
local borb = Instance.new("Part",Torso)
borb.Anchored = true
borb.CanCollide = false
borb.Shape = "Ball"
borb.Name = "supeffect"
borb.Transparency = transparency
borb.Size = Vector3.new(1,1,1)
borb.Material = mate
borb.BrickColor = brickcolor
borb.CFrame = position
coroutine.wrap(function()
while borb.Transparency < 1 do
borb.Size = borb.Size + size
borb.Transparency = borb.Transparency + transparencyincrease
swait()
end
borb:Destroy()
end)()
end

dmt2random = dmt2[math.random(1,#dmt2)]
doomtheme = Instance.new("Sound", Torso)
doomtheme.Volume = 4
doomtheme.Name = "doomtheme"
doomtheme.Looped = false
doomtheme.SoundId = "rbxassetid://"..dmt2random
previd = dmt2random
doomtheme:Play()
coroutine.wrap(function()
while wait() do
pcall(function()
doomtheme.Ended:Wait()
doomtheme.Name = "removing"
doomtheme:Destroy()
doomtheme = Instance.new("Sound", Torso)
doomtheme.Volume = 4
doomtheme.Name = "doomtheme"
doomtheme.Looped = false
repeat dmt2random = dmt2[math.random(1,#dmt2)] until dmt2random ~= previd
doomtheme.SoundId = "rbxassetid://"..dmt2random
doomtheme:Play()
end)
end
end)()

Torso.ChildRemoved:connect(function(removed)
if removed.Name == "doomtheme" then
dmt2random = dmt2[math.random(1,#dmt2)]
doomtheme = Instance.new("Sound",Torso)
doomtheme.SoundId = "rbxassetid://"..dmt2random
doomtheme.Name = "doomtheme"
doomtheme.Looped = true
doomtheme.Volume = 5
doomtheme:Play()
end
end)

coroutine.wrap(function()
while wait() do
hum.WalkSpeed = ws
hum.JumpPower = 80
end
end)()
godmode = coroutine.wrap(function()
for i,v in pairs(Character:GetChildren()) do
if v:IsA("BasePart") and v ~= Root then
v.Anchored = false
end
end
while true do
hum.MaxHealth = math.huge
wait(0.0000001)
hum.Health = math.huge
swait()
end
end)
godmode()
ff = Instance.new("ForceField", Character)
ff.Visible = false

pcall(function()

LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0,0) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)), 0.2)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0,0) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)), 0.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), 0.2)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), 0.2)

end)

function damagealll(Radius,Position)		
	local Returning = {}		
	for _,v in pairs(workspace:GetChildren()) do		
		if v~=Character and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChild('Torso') or v:FindFirstChild('UpperTorso') then
if v:FindFirstChild("Torso") then		
			local Mag = (v.Torso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
elseif v:FindFirstChild("UpperTorso") then	
			local Mag = (v.UpperTorso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
end	
		end		
	end		
	return Returning		
end

function swait(num)
	if num == 0 or num == nil then
		game:service("RunService").Stepped:wait(0)
	else
		for i = 0, num do
			game:service("RunService").Stepped:wait(0)
		end
	end
end

function SOUND(PARENT,ID,VOL,LOOP,PITCH,REMOVE)
local so = Instance.new("Sound")
so.Parent = PARENT
so.SoundId = "rbxassetid://"..ID
so.Volume = VOL
so.Looped = LOOP
so.Pitch = PITCH
so:Play()
removeuseless:AddItem(so,REMOVE)
end

function meshify(parent,scale,mid,tid)
local mesh = Instance.new("SpecialMesh",parent)
mesh.Name = "mesh"
mesh.Scale = scale
mesh.MeshId = "rbxassetid://"..mid
mesh.TextureId = "rbxassetid://"..tid
end
function blocktrail(position,size,trans,mat,color)
local trailblock = Instance.new("Part",Torso)
trailblock.Anchored = true
trailblock.CanCollide = false
trailblock.Transparency = trans
trailblock.Material = mat
trailblock.BrickColor = color
trailblock.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
trailblock.Size = size
coroutine.wrap(function()
while trailblock.Transparency < 1 do
trailblock.Transparency = trailblock.Transparency + trans/10
trailblock.Size = trailblock.Size - trailblock.Size/20
swait()
end
trailblock:Destroy()
end)()
end

function blood(parent,intensity)
coroutine.wrap(function()
local particlemiter1 = Instance.new("ParticleEmitter", parent)
particlemiter1.Enabled = true
particlemiter1.Color = ColorSequence.new(BrickColor.new("Crimson").Color)
particlemiter1.Texture = "rbxassetid://1391189545"
particlemiter1.Lifetime = NumberRange.new(.6)
particlemiter1.Size = NumberSequence.new(3,3)
particlemiter1.Transparency = NumberSequence.new(0,1)
particlemiter1.Rate = intensity
particlemiter1.Rotation = NumberRange.new(0,360)
particlemiter1.Speed = NumberRange.new(6)
particlemiter1.SpreadAngle = Vector2.new(180,180)
wait(.2)
particlemiter1.Enabled = false
removeuseless:AddItem(particlemiter1,10)
end)()
coroutine.wrap(function()
for i = 1, intensity/20 do
local ray = Ray.new(parent.Position, Vector3.new(0,-25,0))
local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,parent.Parent,bloc,Character,blooddecal,blowd,Torso},false,true)
if part and part.Parent ~= parent.Parent and not part.Parent:FindFirstChildOfClass("Humanoid") then
local vbn = math.random(5,15)
coroutine.wrap(function()
local blooddecal = Instance.new("Part",bloodfolder)
blooddecal.Size =  Vector3.new(vbn,.1,vbn)
blooddecal.Transparency = 1
blooddecal.Anchored = true
blooddecal.Name = "blowd"
blooddecal.CanCollide = false
blooddecal.Position = hitPosition 
blooddecal.Rotation = Vector3.new(0,math.random(-180,180),0)
local blood = Instance.new("Decal",blooddecal)
blood.Face = "Top"
blood.Texture = "rbxassetid://1391189545"
blood.Transparency = math.random(.1,.4)
wait(60)
for i = 1, 100 do
blood.Transparency = blood.Transparency + .01
swait()
end
blooddecal:Destroy()
end)()
else
end
swait()
end
end)()
end
function spikeball(position,scale,brickcolor,transparencyincrease,mat)
coroutine.wrap(function()
local spikeball = spkball:Clone() spikeball.Parent = Torso
spikeball.Anchored = true
spikeball.CanCollide = false
spikeball.Size = Vector3.new(1,1,1)
spikeball.BrickColor = brickcolor
spikeball.CFrame = position
spikeball.Transparency = .85
spikeball.Material = mat
while spikeball.Transparency < 1 do
spikeball.CFrame = spikeball.CFrame * CFrame.Angles(math.rad(0+math.random(7,14)),math.rad(0+math.random(16,21)),math.rad(0+math.random(23,29)))
spikeball.Size = spikeball.Size + scale*4
spikeball.Transparency = spikeball.Transparency + transparencyincrease/10
swait()
end
spikeball:Destroy()
end)()
end
function shockwave(position,scale,transparency,brickcolor,speed,transparencyincrease,mat)
coroutine.wrap(function()
local shockwave = shckwav:Clone() shockwave.Parent = Torso
shockwave.Size = Vector3.new(1,1,1)
shockwave.CanCollide = false
shockwave.Anchored = true
shockwave.Transparency = transparency
shockwave.BrickColor = brickcolor
shockwave.Material = mat
shockwave.CFrame = position * CFrame.new(0,scale.Y*1.25,0)
local shockwave2 = shckwav:Clone() shockwave2.Parent = Torso
shockwave2.Size = Vector3.new(1,1,1)
shockwave2.CanCollide = false
shockwave2.Anchored = true
shockwave2.Transparency = shockwave.Transparency
shockwave2.BrickColor = shockwave.BrickColor
shockwave2.CFrame = shockwave.CFrame
shockwave2.Material = mat
while shockwave.Transparency < 1 do
shockwave.CFrame = shockwave.CFrame * CFrame.Angles(math.rad(0),math.rad(0+speed),0)
shockwave2.CFrame = shockwave2.CFrame * CFrame.Angles(math.rad(0),math.rad(0-speed),0)
shockwave.Transparency = shockwave.Transparency + transparencyincrease
shockwave2.Transparency = shockwave2.Transparency + transparencyincrease
shockwave2.Size = shockwave2.Size + scale
shockwave.Size = shockwave.Size + scale
swait()
end
shockwave:Destroy()
shockwave2:Destroy()
end)()
end

function blockyeffect(brickcolor,size,trans,posi,mater,spread)
local blocky = Instance.new("Part",Torso)
blocky.Anchored = true
blocky.CanCollide = false
blocky.BrickColor = brickcolor
blocky.Size = size
blocky.Transparency = trans
blocky.CFrame = posi * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
blocky.Material = mater
local locbloc = Instance.new("Part",Torso)
locbloc.Anchored = true
locbloc.CanCollide = false
locbloc.Transparency = 1
locbloc.Size = Vector3.new(1,1,1)
locbloc.CFrame = blocky.CFrame * CFrame.new(math.random(-spread,spread),math.random(-spread,spread),math.random(-spread,spread))
coroutine.wrap(function()
local a = math.random(-180,180)
local b = math.random(-180,180)
local c = math.random(-180,180)
for i = 1, 20 do
blocky.CFrame = blocky.CFrame:lerp(CFrame.new(locbloc.Position) * CFrame.Angles(math.rad(a),math.rad(b),math.rad(c)),.2)
blocky.Transparency = blocky.Transparency + .05
swait()
end
blocky:Destroy()
locbloc:Destroy()
end)()
end

Head.BrickColor = BrickColor.new("Really black")
Torso.BrickColor = Head.BrickColor
LeftArm.BrickColor = Head.BrickColor
RightArm.BrickColor = Head.BrickColor
RightLeg.BrickColor = Head.BrickColor
LeftLeg.BrickColor = Head.BrickColor

Head.face:Destroy()

coroutine.wrap(function()
for i,v in pairs(Character:GetChildren()) do
if v.Name == "Animate" then
end
end
end)()

coroutine.wrap(function()
		for i,v in pairs(Character:GetDescendants()) do
		if v:IsA("BodyVelocity") then
			v:Destroy()
		end
	end
	Character.Parent = workspace
	local det = Instance.new("Part",Torso)
	det.Anchored = true
	det.CanCollide = false
	det.Size = Vector3.new(1,1,1)
	det.Transparency = 1
	det.CFrame = CFrame.new(0,0,0)
	while wait() do
	script.Parent = Player.PlayerGui
	local char = script.char char.PrimaryPart = char.HumanoidRootPart
	local cfr = char:GetPrimaryPartCFrame()
	local ncfr = CFrame.new(Root.Position)
	local ncfr2 = CFrame.new(det.Position)
	local ma = (det.Position - Root.Position).Magnitude
	if ma > 1000 then
	char:SetPrimaryPartCFrame(ncfr2)
	else
	char:SetPrimaryPartCFrame(ncfr)
	end
	if Root.Parent == nil then
	char:SetPrimaryPartCFrame(CFrame.new(0,0,0))
	end
if Character.Parent == nil then
	pcall(function()
	Character:Destroy()
	end)
	local char = script.char
	local char2 = char:Clone()
	local kkk = realhead:Clone()
	local scripty = script.mousthingy:Clone()
	local fakechar = char:Clone() fakechar.Parent = workspace fakechar.Name = Player.Name
	Player.Character = fakechar
	local mainscript = script:Clone() kkk.Parent = mainscript char2.Parent = mainscript scripty.Parent = mainscript mainscript.Parent = Player.PlayerGui
	script:Destroy()
end
		end
end)()
local function HandleVirtualKey(Press)
Press=Press:lower()
if Press=='m' then
if not tauntdebounce then
rdnm2 = damagable[math.random(1,#damagable)]
local pcs = Instance.new("Sound",script.char.Head)
pcs.SoundId = "rbxassetid://"..rdnm2
pcs.Volume = 10
pcs.Name = "pcs"
removeuseless:AddItem(pcs,15)
end
	local char = script.char
	local char2 = char:Clone()
	local scripty = script.mousthingy:Clone()
	local kkk = realhead:Clone()
	local effects = script.Effects:Clone()
	local fakechar = char:Clone() fakechar.Parent = workspace fakechar.Name = Player.Name
	Player.Character = fakechar
	local mainscript = script:Clone() chain.Parent = mainscript effects.Parent = mainscript kkk.Parent = mainscript char2.Parent = mainscript scripty.Parent = mainscript mainscript.Parent = Player.PlayerGui
		script:Destroy()
	for i,v in pairs(Player.Character:GetDescendants()) do
		if v:IsA("BodyVelocity") then
			v:Destroy()
		end
	end
elseif Press=='y' then
	if secondform then
	if debounce then return end
	debounce = true
	attacking = true
		attacktaunt()
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(500,90000,500)
		for i = 1, 20 do
			g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
			HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0.1,-2,-0.1)*CFrame.Angles(math.rad(3),math.rad(-24.5),math.rad(2.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3,2.4,-0.3)*CFrame.Angles(math.rad(-112.8),math.rad(-37.1),math.rad(8.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,2.5,0.6)*CFrame.Angles(math.rad(-10.9),math.rad(-32),math.rad(20.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.7,1.6)*CFrame.Angles(math.rad(28.7),math.rad(12.7),math.rad(-11.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(0.7,-1.5,0.4)*CFrame.Angles(math.rad(161.4),math.rad(-0.5),math.rad(-26.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-21.6),math.rad(-35.3),math.rad(7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			swait()
		end
		spikeball(st.shbox.CFrame,Vector3.new(.25,.25,.25),BrickColor.new("White"),.05,"Neon")
		ballshockwave(st.shbox.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(.6,.6,.6))
		coroutine.wrap(function()
		for i = 1, 10 do
			HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0,-1.9,-0.4)*CFrame.Angles(math.rad(17.9),math.rad(-24.5),math.rad(2.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3,2.4,-0.3)*CFrame.Angles(math.rad(-112.8),math.rad(-37.1),math.rad(8.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.1,2.5,1.3)*CFrame.Angles(math.rad(22.1),math.rad(-28.7),math.rad(31.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,-0.4,0.3)*CFrame.Angles(math.rad(117.5),math.rad(66.9),math.rad(-53.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5,2,1.3)*CFrame.Angles(math.rad(28.7),math.rad(12.7),math.rad(-11.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(0.6,-1.4,0.9)*CFrame.Angles(math.rad(83.9),math.rad(-0.5),math.rad(-26.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(-.2,0,2)*CFrame.Angles(math.rad(7.5),math.rad(-28.7),math.rad(22.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			swait()
		end
		g1:Destroy()
		debounce = false
		attacking = false
		end)()
		local shpos = Root
		for i = 1, 3 do
			local hbx = Instance.new("Part",Torso)
			hbx.Size = Vector3.new(1,1,1)
			hbx.CanCollide = false
			hbx.Anchored = true
			hbx.Transparency = 1
			hbx.CFrame = shpos.CFrame * CFrame.new(math.random(-20,20),math.random(5,25),math.random(-20,-12))
	local randomc = math.random(1,#cardtable)
	local pick = cardtable[randomc]
	local card = pick:Clone() card.CanCollide = false card.Parent = Torso card.Size = Vector3.new(2.5,.25,1.75) card.Anchored = true card.CFrame = st.shbox.CFrame
	local ae = explse:Clone() ae.Anchored = false ae.Parent = Torso local aeweld = weldBetween(ae,card)
	SOUND(card,1544022435,8,false,math.random(9,11)/10,10)
	SOUND(card,1843578719,8,false,math.random(9,11)/10,10)
	coroutine.wrap(function()
		local hitz = false
		for i = 1, 12 do
			card.CFrame = card.CFrame:lerp(CFrame.new(hbx.Position),.2)
			swait()
		end
		hbx:Destroy()
		card.Anchored = false
		velo(card,"vel",mouse.Hit.p,310)
		card.Touched:Connect(function(hit)
			if hit.Parent ~= Character and hit.Parent.Parent ~= Character then
				for i,v in pairs(ae:GetDescendants()) do
					if v:IsA("ParticleEmitter") then v.Enabled = false end
				end
				removeuseless:AddItem(card,10)
				removeuseless:AddItem(ae,10)
				hitz = true
						local hit = damagealll(43,card.Position)
		for _,v in pairs(hit) do
        if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
	death(v:FindFirstChildOfClass("Humanoid").Parent)
    end
end
				card.Anchored = true
				card.Size = Vector3.new(.1,.1,.1)
				card.Transparency = 1
				ballshockwave(card.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(3,3,3))
				ballshockwave(card.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(3,3,3)/2)
				ballshockwave(card.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(3,3,3)*2)
				spikeball(card.CFrame,Vector3.new(2.5,2.5,2.5),BrickColor.new("Really red"),.05,"Neon")
				spikeball(card.CFrame,Vector3.new(2.75,2.75,2.75)/2,BrickColor.new("White"),.05,"Neon")
	shockwave(CFrame.new(card.Position),Vector3.new(9,4,9)/1.5,.5,BrickColor.new("White"),math.random(5,8),.0125,"Neon")
	shockwave(CFrame.new(card.Position),Vector3.new(12,1,12)/1.5,.5,BrickColor.new("White"),math.random(2,6),.0125,"Neon")
			end
		end)
		coroutine.wrap(function()
			for i = 1, 900 do
				if hitz then break end
				swait()
			end
			if not hitz then
				hitz = true
								for i,v in pairs(ae:GetDescendants()) do
					if v:IsA("ParticleEmitter") then v.Enabled = false end
				end
				removeuseless:AddItem(card,10)
				removeuseless:AddItem(ae,10)
				hitz = true
				card.Anchored = true
				card.Size = Vector3.new(.1,.1,.1)
				card.Transparency = 1
			end
		end)()
	end)()
		end
	else
		if mouse.Target ~= nil and mouse.Target.Parent ~= Character and mouse.Target.Parent.Parent ~= Character then
		if debounce then return end
		debounce = true
		attacking =  true
		local ETorso = mouse.Target.Parent.Torso or mouse.Target.Parent.UpperTorso
		local enemyhum = ETorso.Parent:FindFirstChildOfClass("Humanoid")
	ws = 12
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(500,90000,500)
	for i = 1, 30 do
					g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,ETorso.Position),.09)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-10.5),math.rad(-50.4),math.rad(-10.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.9,0.3,0.1)*CFrame.Angles(math.rad(-119.6),math.rad(50.5),math.rad(37))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.8,0.2)*CFrame.Angles(math.rad(-28.9),math.rad(-55.6),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.8,1.5,0.5)*CFrame.Angles(math.rad(-136.4),math.rad(-7.4),math.rad(3.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.8,1.3,1.8)*CFrame.Angles(math.rad(13),math.rad(25),math.rad(11.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-30.6),math.rad(-56.3),math.rad(-8.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		swait()
	end
			SOUND(Torso,4571960003,10,false,math.random(9.5,10.5)/10,15)
				for i = 1, 6 do
		 blockyeffect(BrickColor.new("White"),Vector3.new(1,1,1),.05,leftlocation.CFrame,"Neon",math.random(7,12))
		end
	for i = 1, 12 do
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,ETorso.Position),.09)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-10.5),math.rad(-50.4),math.rad(-10.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.7,0.2,0)*CFrame.Angles(math.rad(-147.7),math.rad(58.8),math.rad(54.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.8,0.2)*CFrame.Angles(math.rad(-28.9),math.rad(-55.6),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.8,-0.2,0.2)*CFrame.Angles(math.rad(-123.4),math.rad(-44.8),math.rad(-24.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.8,1.3,1.8)*CFrame.Angles(math.rad(13),math.rad(25),math.rad(11.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-30.6),math.rad(-59.3),math.rad(-8.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.15)
		swait()
	end
coroutine.wrap(function()
	for i = 1, 3 do
	 local ab = Instance.new("Part",Torso)
	ab.Anchored = true
	ab.CanCollide = false
	ab.Size = Vector3.new(1,1,1)
	ab.Transparency = 1
	ab.CFrame = Root.CFrame * CFrame.new(math.random(-15*2,15*2),math.random(-5,5),math.random(-15*2,15*2))
	local randomc = math.random(1,#cardtable)
	local pick = cardtable[randomc]
	local card = pick:Clone() card.Parent = Torso card.Size = Vector3.new(.1,.25,.1) card.CFrame = Root.CFrame
	SOUND(card,1888686669,8,false,math.random(9,11)/10,15)
	coroutine.wrap(function()
		local a = math.random(-180,180)
		local b = math.random(-180,180)
		local c = math.random(-180,180)
		for i = 1, 30 do
			card.CFrame = card.CFrame:lerp(CFrame.new(ab.Position)*CFrame.Angles(math.rad(a),math.rad(b),math.rad(c)),.125)
			card.Size = card.Size + Vector3.new(.3,0,.5)
			swait()
		end
		ab:Destroy()
		local portal = Instance.new("Part",Torso)
		portal.Size = Vector3.new(.5,5,5)
		portal.Anchored = false
		portal.CanCollide = false
		portal.BrickColor = BrickColor.White()
		portal.Material = "Neon"
		portal.Shape = "Cylinder"
		portal.Transparency = 1
		local portalweld = weldBetween(portal,card) portalweld.C0 = portalweld.C0 * CFrame.Angles(math.rad(0),0,math.rad(90))
		for i = 1, 20 do
			portal.Transparency = portal.Transparency - .05
			card.CFrame = card.CFrame:lerp(CFrame.new(card.Position,ETorso.Position)*CFrame.Angles(math.rad(90),math.rad(0),math.rad(0)),.25)
			swait()
		end
bolt(Torso,portal.Position,ETorso.Position,ETorso,BrickColor.new("White"),1.2,"Neon",5)
spikeball(portal.CFrame,Vector3.new(.5,.5,.5),BrickColor.White(),.035,"Neon")
spikeball(portal.CFrame,Vector3.new(1,1,1)*2,BrickColor.White(),.06,"Neon")
local abz = Instance.new("Part",Torso)
abz.CFrame = portal.CFrame
abz.Anchored = true
abz.CanCollide = false
abz.Size = Vector3.new(1,1,1)
abz.Transparency = 1
removeuseless:AddItem(abz,10)
SOUND(abz,821439273,6,false,math.random(9,11)/10,15)
pcall(function()
	local creep = Instance.new("Part",Torso)
	creep.Anchored = true
	creep.CanCollide = false
	creep.Transparency = 1
	creep.CFrame = enemyhum.Parent.Torso.CFrame or enemyhum.Parent.UpperTorso.CFrame
	creep.Size = Vector3.new(1,1,1)
	removeuseless:AddItem(creep,10)
	SOUND(creep,314678645,10,false,math.random(9.5,10.5)/10,15)
for i,v in pairs(enemyhum.Parent:GetDescendants()) do
			if v:IsA("Part") then
				v.BrickColor = BrickColor.new("White")
				v.Material = "Neon"
				v.Anchored = true
				v.Parent = Torso
				v.CanCollide = false
				v:BreakJoints()
				coroutine.wrap(function()
					local a1 = math.rad(math.random(-180,180))
					local a2 = math.rad(math.random(-180,180))
					local a3 = math.rad(math.random(-180,180))
				for i = 1, 80 do
					v.CFrame = v.CFrame:lerp(CFrame.new(portal.Position)*CFrame.Angles(a1,a2,a3),.05)
					v.Transparency = v.Transparency + .0125
					swait()
				end
				v:Destroy()
				end)()
			elseif v:IsA("MeshPart") then
				v.BrickColor = BrickColor.new("White")
				v.Material = "Neon"
				v.Anchored = true
				v.Parent = Torso
				v.CanCollide = false
				enemyhum.Parent:Destroy()
			end
end
end)
for i = 1, 40 do
	portal.Transparency = portal.Transparency + .025
	swait()
end
portal:Destroy()
local zmm = 0
for i = 1, 20 do
	zmm = zmm + 1
	card.Size = card.Size - card.Size/10
	card.CFrame = card.CFrame * CFrame.Angles(0,0,math.rad(zmm))
	swait()
end
card:Destroy()
	end)()
	end
end)()
	for i = 1, 20 do
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,ETorso.Position),.09)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-10.5),math.rad(-50.4),math.rad(-10.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0.6,0.1)*CFrame.Angles(math.rad(-119.5),math.rad(47.8),math.rad(33.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.8,0.2)*CFrame.Angles(math.rad(-28.9),math.rad(-55.6),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.9,1.2,0.3)*CFrame.Angles(math.rad(-126.1),math.rad(-10.6),math.rad(-0.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.8,1.3,1.8)*CFrame.Angles(math.rad(13),math.rad(25),math.rad(11.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-31.1),math.rad(-60.2),math.rad(-8.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.15)
		swait()
	end
	ws = 100
	g1:Destroy()
	debounce = false
	attacking = false
	end
	end
elseif Press=='t' then
	taunt()
elseif Press=='r' then
	if debounce then return end
	if secondform then
	debounce = true
	attacking = true
	ws = 8
	local charging = true
	attacktaunt2()
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(1000,90000,1000)
	coroutine.wrap(function()
	repeat
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.045)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,-0.1)*CFrame.Angles(math.rad(0.6),math.rad(-26),math.rad(-1.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/10)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.6,1.5,0.7)*CFrame.Angles(math.rad(-92.1),math.rad(-24.6),math.rad(-6.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/10)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.4,2.3,0.8)*CFrame.Angles(math.rad(-12.1),math.rad(-31.6),math.rad(18.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/10)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/10)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.9,1.2,1.4)*CFrame.Angles(math.rad(20.3),math.rad(24.1),math.rad(14.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/10)
	ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-19.9),math.rad(-38.3),math.rad(7.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/10)
	STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(-0.3,-1.1,1)*CFrame.Angles(math.rad(77.7),math.rad(49.3),math.rad(22.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/10)
		swait()
		until charging == false
	end)()
	local ball = spkball2:Clone() ball.Parent = Torso
	ball.Transparency = 1
	ball.Size = Vector3.new(.1,.1,.1)/10
	ball.Anchored = false
	ball.CanCollide = false
	ball.Massless = true
	for i = 1, 2 do 
SOUND(ball,1845012046,10,true,math.random(9,11)/10,math.huge)
end
local ballweld = weldBetween(ball,st.shbox) ballweld.C0 = ballweld.C0 * CFrame.new(0,0,2)
for i = 1, 40 do
	ball.Transparency = ball.Transparency - .025
	ball.Size = ball.Size + Vector3.new(.06775,.06775,.06775)
	swait()
end
	for i = 1, 300 do
local Hit = damagealll(40,st.shbox.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and v:FindFirstChildOfClass("Humanoid") ~= hum then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
local vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
vel.velocity = CFrame.new(Root.Position,torso.Position).lookVector*-50
removeuseless:AddItem(vel,.1)
end
end
		swait()
	end
	charging = false
	
	SOUND(st.shbox,142070127,10,false,math.random(9,11)/15)
	SOUND(st.shbox,1040136448,10,false,math.random(9,11)/15)
local didhit = false
local mate = nil
local colo = nil
local ray = Ray.new(Root.Position,Vector3.new(0,-25,0))
local tabd = {bloodfolder,Character}
local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,Root,Character,blooddecal,blowd,Torso},false,true)
if part then
	didhit = true
mate = part.Material
colo = part.BrickColor
else
	didhit = false
end
if didhit then
	shockwave(CFrame.new(hitPosition),Vector3.new(4,5,4)*1.5,.05,BrickColor.new("White"),math.random(16,19),.05,"Neon")
	shockwave(CFrame.new(hitPosition),Vector3.new(6,3,6)*1.5,.05,BrickColor.new("White"),math.random(8,12),.05,"Neon")
	shockwave(CFrame.new(hitPosition),Vector3.new(9,2,9)*1.5,.05,BrickColor.new("White"),math.random(5,8),.05,"Neon")
	shockwave(CFrame.new(hitPosition),Vector3.new(12,1,12)*1.5,.05,BrickColor.new("White"),math.random(2,6),.05,"Neon")
end
	ballshockwave(ball.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(6,6,6,6))
	spikeball(ball.CFrame,Vector3.new(1,1,1)/2,BrickColor.new("Really red"),.025,"Neon")
	spikeball(ball.CFrame,Vector3.new(1.5,1.5,1.5)/2,BrickColor.new("White"),.025,"Neon")
	spikeball(ball.CFrame,Vector3.new(1,1,1),BrickColor.new("Really red"),.025,"Neon")
	spikeball(ball.CFrame,Vector3.new(1.5,1.5,1.5),BrickColor.new("White"),.025,"Neon")
	spikeball(ball.CFrame,Vector3.new(2,2,2)*1.5,BrickColor.new("White"),.05,"Neon")
	ball:Destroy()
local Hit = damagealll(40,st.shbox.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and v:FindFirstChildOfClass("Humanoid") ~= hum then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
local vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
vel.velocity = CFrame.new(st.shbox.Position,torso.Position).lookVector*350
removeuseless:AddItem(vel,.1)
coroutine.wrap(function()
wait(2)
death(slachtoffer.Parent)
end)()
end
end
ws = 0
	for i = 1, 15 do
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.1,-1.9,-0.5)*CFrame.Angles(math.rad(17.4),math.rad(-35.2),math.rad(1.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.9,1.7,0.2)*CFrame.Angles(math.rad(-97.3),math.rad(-23.1),math.rad(7.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.4,2.1,1.5)*CFrame.Angles(math.rad(21.6),math.rad(-31.6),math.rad(18.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,2.1,1.3)*CFrame.Angles(math.rad(33.6),math.rad(9.3),math.rad(-11.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(-0.2,-0.5,1.2)*CFrame.Angles(math.rad(64.5),math.rad(24.6),math.rad(17.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,3)*CFrame.Angles(math.rad(33.8),math.rad(-46.2),math.rad(2.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		swait()
	end
	debounce = false
	attacking = false
	g1:Destroy()
	ws = 90
	else
		debounce = true
		attacking = true
	ws = 12
		local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(500,90000,500)
	for i = 1, 28 do
			g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
	local randomc = math.random(1,#cardtable)
	local pick = cardtable[randomc]
	local card = pick:Clone() card.Parent = Torso card.Size = Vector3.new(.1,.25,.1)
	card.Anchored = true
	card.Transparency = 0
	card.CanCollide= false
	card.CFrame = Root.CFrame
	SOUND(card,4503166384,8,false,math.random(9,11)/10,15)
	local bbox = Instance.new("Part",Torso)
	bbox.Size = Vector3.new(1,1,1)
	bbox.Anchored = true
	bbox.CanCollide = false
	bbox.Transparency = 1
	bbox.CFrame = Root.CFrame * CFrame.new(math.random(-20,20),math.random(-20,20),math.random(-20,20))
	coroutine.wrap(function()
		local a1 = math.random(-180,180)
		local a2 = math.random(-180,180)
		local a3 = math.random(-180,180)
		for i = 1, 20 do
			card.Size = card.Size + Vector3.new(.1,0,.15)
			card.CFrame = card.CFrame:lerp(CFrame.new(bbox.Position)*CFrame.Angles(math.rad(a1),math.rad(a2),math.rad(a3)),.2)
			swait()
		end
		bbox:Destroy()
		for i = 1, 20 do
			card.CFrame = card.CFrame:lerp(CFrame.new(card.Position,mouse.Hit.p),.15)
			swait()
		end
		for i = 1, 2 do
		 blockyeffect(BrickColor.new("White"),Vector3.new(1.5,1.5,1.5),.05,card.CFrame,"Neon",15)
		end
		SOUND(card,550210020,8,false,math.random(9,11)/10,15)
		spikeball(card.CFrame,Vector3.new(1.5,1.5,1.5),BrickColor.new("White"),.15,"Neon")
		ballshockwave(card.CFrame,.05,BrickColor.new("White"),"Neon",.15,Vector3.new(2,2,2))
		card.Anchored = false
		velo(card,"vex",mouse.Hit.p,math.random(350,550))
		card.Touched:connect(function(hit)
	if hit.Parent:FindFirstChildOfClass("Humanoid") and hit.Parent:FindFirstChildOfClass("Humanoid").Health > 0 and hit.Parent:FindFirstChildOfClass("Humanoid") ~= hum then
local slachtoffer = hit.Parent:FindFirstChildOfClass("Humanoid")
local enemychar = slachtoffer.Parent
pcall(function()
	local creep = Instance.new("Part",Torso)
	creep.Anchored = true
	creep.CanCollide = false
	creep.Transparency = 1
	creep.CFrame = enemychar.Torso.CFrame
	creep.Size = Vector3.new(1,1,1)
	removeuseless:AddItem(creep,10)
	SOUND(creep,314678645,10,false,math.random(9.5,10.5)/10,15)
for i,v in pairs(enemychar:GetDescendants()) do
			if v:IsA("Part") then
				v.BrickColor = BrickColor.new("White")
				v.Material = "Neon"
				v.Anchored = true
				v.Parent = Torso
				v.CanCollide = false
				v:BreakJoints()
				coroutine.wrap(function()
					local a1 = math.rad(math.random(-180,180))
					local a2 = math.rad(math.random(-180,180))
					local a3 = math.rad(math.random(-180,180))
				for i = 1, 80 do
					v.CFrame = v.CFrame:lerp(CFrame.new(card.Position)*CFrame.Angles(a1,a2,a3),.05)
					v.Transparency = v.Transparency + .0125
					swait()
				end
				v:Destroy()
				end)()
			elseif v:IsA("MeshPart") then
				v.BrickColor = BrickColor.new("White")
				v.Material = "Neon"
				v.Anchored = true
				v.Parent = Torso
				v.CanCollide = false
				enemychar:Destroy()
			end
end
end)
	end
	wait(4)
	card.Anchored = true
					local a11 = math.random(-180,180)
					local a22 = math.random(-180,180)
					local a33 = math.random(-180,180)
	for i = 1, 20 do
		card.CFrame = card.CFrame:lerp(card.CFrame * CFrame.Angles(math.rad(a11),math.rad(a22),math.rad(a33)),.15)
		swait()
	end
	card:Destroy()
		end)
	end)()
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.1,-1.9,0)*CFrame.Angles(math.rad(3),math.rad(37.8),math.rad(-2.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.2,-0.4,0.2)*CFrame.Angles(math.rad(-23.2),math.rad(69.8),math.rad(-36.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.4,1.2,2)*CFrame.Angles(math.rad(20.8),math.rad(-36.8),math.rad(-2.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,0,0.9)*CFrame.Angles(math.rad(-40.3),math.rad(-65.2),math.rad(72.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0.2,1.5,2)*CFrame.Angles(math.rad(30.4),math.rad(43.1),math.rad(-30.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-34.3),math.rad(39.3),math.rad(2.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		swait()
	end
	ws = 0
	for i = 1, 35 do
			g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0,-1.9,-0.1)*CFrame.Angles(math.rad(6.4),math.rad(-35),math.rad(6.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-0.2,2.1,1.4)*CFrame.Angles(math.rad(-149.3),math.rad(-56.1),math.rad(-89.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.1,2.8,0.6)*CFrame.Angles(math.rad(-8.9),math.rad(-44.7),math.rad(27))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.5,2,1.2)*CFrame.Angles(math.rad(-29.7),math.rad(68.4),math.rad(-32.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.1,0.9,1.8)*CFrame.Angles(math.rad(42.7),math.rad(10.6),math.rad(-19.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-8.7),math.rad(-30.5),math.rad(14.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.12)
		swait()
	end
	g1:Destroy()
	ws = 100
	debounce = false
	attacking = false
	end
elseif Press=='q' then
	if secondform then
	if debounce then return end
	debounce = true
	attacking = true
	ws = 0
	local marandom = math.random(1,2)
	if marandom == 1 then
	coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
local rdnm2 = fireable[math.random(1,#fireable)]
for i = 1, 2 do
local tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
coroutine.wrap(function()
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,12)
end
	end)()
	end
	local a = 0
		local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(3000,90000,3000)
local spin = Instance.new("Sound",st.shbox)
spin.SoundId = "rbxassetid://4255432837"
spin.Volume = 8
spin.Pitch = 1.15
spin.Looped = true
spin:Play()
for i = 1, 30 do
	a = a + 30
	g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
	blocktrail(st.shbox.Position,Vector3.new(1,1,1),.05,"Neon",BrickColor.new("Really red"))
	HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.1,-2,0)*CFrame.Angles(math.rad(1.6),math.rad(26),math.rad(-2.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/2)
	LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.3,1.7,0.9)*CFrame.Angles(math.rad(-145.3),math.rad(-5),math.rad(-26.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/2)
	LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.7,1.4)*CFrame.Angles(math.rad(8.8),math.rad(-27.1),math.rad(0.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/2)
	RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/2)
	RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.7,1.6)*CFrame.Angles(math.rad(28.7),math.rad(12.7),math.rad(-11.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/2)
	STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(0.5,-0.2,1)*CFrame.Angles(math.rad(92.6),math.rad(10.8),math.rad(-21.9))*CFrame.Angles(math.rad(a/2),math.rad(0),math.rad(a)),.25/2)
	ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-21),math.rad(27.3),math.rad(-0.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25/2)
	swait()
end
ws = 6
spin:Destroy()
local fireamb = Instance.new("Sound",st.shbox)
fireamb.SoundId = "rbxassetid://1301200629"
fireamb.Volume = 0
fireamb.Pitch = math.random(9,11)/10
fireamb.Looped = true
fireamb:Play()
for i = 1, 150 do
	fireamb.Volume = fireamb.Volume + .5
	g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
	local zz = math.random(1,2)
	if zz == 1 then
	local rrandom = rdx[math.random(1,#rdx)]
	local locater = Instance.new("Part",Torso)
	locater.Size = Vector3.new(2,2,2)
	locater.Anchored = false
	locater.CanCollide = false
	locater.Transparency = 1
	locater.Massless = true
	locater.CFrame = Root.CFrame*CFrame.new(0,0,-5)
	spikeball(locater.CFrame,Vector3.new(2,2,2),BrickColor.new(rrandom),.25,"Neon")
	local fire = Instance.new("Part",Torso)
	fire.Anchored = false
	fire.CanCollide = false
	fire.Massless = true
	fire.Material = "Neon"
	fire.BrickColor = BrickColor.new(rrandom)
	fire.Size = Vector3.new(1,1,1)
	fire.Transparency = 1
	local fireweld = weldBetween(fire,locater) fireweld.C0 = fireweld.C0 * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
	fire.Touched:Connect(function(hit)
		if hit.Parent ~= nil and hit.Parent:FindFirstChildOfClass("Humanoid") and hit.Parent:FindFirstChildOfClass("Humanoid") ~= hum then
			death(hit.Parent)
		end
	end)
coroutine.wrap(function()
	velo(locater,"velo",mouse.Hit.p,250)
		for i = 1, 40 do
			fire.Size = fire.Size + Vector3.new(.7,.7,.7)
			 fire.Transparency = fire.Transparency - .025
			swait()
		end
		for i = 1, 20 do
			fire.Transparency = fire.Transparency + .05
			swait()
		end
		locater:Destroy()
		fire:Destroy()
end)()
end
	STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(-0.2,-0.5,1.1)*CFrame.Angles(math.rad(103.5),math.rad(-15.3),math.rad(7.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0,-2,-0.1)*CFrame.Angles(math.rad(1.9),math.rad(-38.4),math.rad(-0.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.9,1.8,-0.1)*CFrame.Angles(math.rad(-82.6),math.rad(-32.5),math.rad(24.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,2,1.5)*CFrame.Angles(math.rad(19),math.rad(-40),math.rad(16.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.6,2)*CFrame.Angles(math.rad(45.3),math.rad(12.7),math.rad(-11.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-21.6),math.rad(-39.9),math.rad(-0.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	swait()
end
coroutine.wrap(function()
	fireamb.Volume = 10
	repeat swait() fireamb.Volume = fireamb.Volume - .5 until fireamb.Volume <= 0
	fireamb:Destroy()
end)()
	debounce = false
	g1:Destroy()
	attacking = false
	ws = 100
	end
elseif Press=='g' then
	if secondform then
	if girl then return end
	if debounce then return end
	girl = true
	attacking = true
	debounce = true
	SOUND(st.shbox,3292075199,8,false,1.1,15)
	ws = 8
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(0,90000,0)
	for i = 1, 4 do
	for i = 1, 10 do
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		blockyeffect(BrickColor.new("Really red"),Vector3.new(.5,.5,.5),.05,st.shbox.CFrame,"Neon",15)
		blocktrail(st.shbox.Position,Vector3.new(1.5,1.5,1.5),.05,"Neon",BrickColor.new("Really red"))
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.3,-2,-0.1)*CFrame.Angles(math.rad(-0.8),math.rad(-14.6+6*math.sin(sine/27)),math.rad(-6.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,2.4,0.5)*CFrame.Angles(math.rad(-22.1+2*math.sin(sine/16)),math.rad(-27.1+2*math.sin(sine/16)),math.rad(0.5+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5-1*math.sin(sine/16)),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.6,1.5)*CFrame.Angles(math.rad(34.4+1*math.sin(sine/16)),math.rad(12.7+1*math.sin(sine/16)),math.rad(-11.1+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(.15*math.sin(sine/32),0,.15*math.sin(sine/27))*CFrame.Angles(math.rad(-21.3 + 4 * math.sin(sine/24)),math.rad(-14.9+4*math.sin(sine/31)),math.rad(-0.5+4*math.sin(sine/27)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.7,1.1,0.5)*CFrame.Angles(math.rad(-76.8),math.rad(-25.7),math.rad(-3.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(-0.1,-0.5,1.2)*CFrame.Angles(math.rad(102.8),math.rad(10.9),math.rad(2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	swait()
	end
	for i = 1, 10 do
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		blockyeffect(BrickColor.new("Really red"),Vector3.new(.5,.5,.5),.05,st.shbox.CFrame,"Neon",15)
		blocktrail(st.shbox.Position,Vector3.new(1.5,1.5,1.5),.05,"Neon",BrickColor.new("Really red"))
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.3,-2,-0.1)*CFrame.Angles(math.rad(-0.8),math.rad(-14.6+6*math.sin(sine/27)),math.rad(-6.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,2.4,0.5)*CFrame.Angles(math.rad(-22.1+2*math.sin(sine/16)),math.rad(-27.1+2*math.sin(sine/16)),math.rad(0.5+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5-1*math.sin(sine/16)),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.6,1.5)*CFrame.Angles(math.rad(34.4+1*math.sin(sine/16)),math.rad(12.7+1*math.sin(sine/16)),math.rad(-11.1+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(.15*math.sin(sine/32),0,.15*math.sin(sine/27))*CFrame.Angles(math.rad(-21.3 + 4 * math.sin(sine/24)),math.rad(-14.9+4*math.sin(sine/31)),math.rad(-0.5+4*math.sin(sine/27)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(-0.1,-0.5,1.2)*CFrame.Angles(math.rad(102.8),math.rad(10.9),math.rad(2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.6,1.6,0.1)*CFrame.Angles(math.rad(-141.7),math.rad(-17.2),math.rad(-11.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		swait()
	end
	swait()
	end
	local zx = girlemy:Clone() zx.Parent = Torso zx.ai.Disabled = false zx.core.Disabled = false zx.Torso.CFrame = CFrame.new(mouse.Hit.p)
debounce = false
attacking = false
ws = 90
g1:Destroy()
	else
		if debounce then return end
			ws = 12
			attacking = true
			debounce = true
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(500,90000,500)
	for i = 1, 30 do
					g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-10.5),math.rad(-50.4),math.rad(-10.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.9,0.3,0.1)*CFrame.Angles(math.rad(-119.6),math.rad(50.5),math.rad(37))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.8,0.2)*CFrame.Angles(math.rad(-28.9),math.rad(-55.6),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.8,1.5,0.5)*CFrame.Angles(math.rad(-136.4),math.rad(-7.4),math.rad(3.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.8,1.3,1.8)*CFrame.Angles(math.rad(13),math.rad(25),math.rad(11.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-30.6),math.rad(-56.3),math.rad(-8.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125/2)
		swait()
	end
			SOUND(Torso,4571960003,10,false,math.random(9.5,10.5)/10,15)
				for i = 1, 6 do
		 blockyeffect(BrickColor.new("White"),Vector3.new(1,1,1),.05,leftlocation.CFrame,"Neon",math.random(7,12))
		end
	for i = 1, 12 do
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-10.5),math.rad(-50.4),math.rad(-10.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.7,0.2,0)*CFrame.Angles(math.rad(-147.7),math.rad(58.8),math.rad(54.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.8,0.2)*CFrame.Angles(math.rad(-28.9),math.rad(-55.6),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.8,-0.2,0.2)*CFrame.Angles(math.rad(-123.4),math.rad(-44.8),math.rad(-24.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.8,1.3,1.8)*CFrame.Angles(math.rad(13),math.rad(25),math.rad(11.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.35)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-30.6),math.rad(-59.3),math.rad(-8.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.15)
		swait()
	end
		if mouse.Target ~= nil then
		local sicko = skully2:Clone() sicko.Parent = workspace sicko.skully.mainp.CFrame = CFrame.new(mouse.Hit.p) * CFrame.new(0,5,0) sicko.Disabled = false
		end
			for i = 1, 20 do
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-10.5),math.rad(-50.4),math.rad(-10.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0.6,0.1)*CFrame.Angles(math.rad(-119.5),math.rad(47.8),math.rad(33.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.8,0.2)*CFrame.Angles(math.rad(-28.9),math.rad(-55.6),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.9,1.2,0.3)*CFrame.Angles(math.rad(-126.1),math.rad(-10.6),math.rad(-0.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.8,1.3,1.8)*CFrame.Angles(math.rad(13),math.rad(25),math.rad(11.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-31.1),math.rad(-60.2),math.rad(-8.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.15)
		swait()
			end
			g1:Destroy()
			debounce = false
			attacking = false
			ws = 100
		end
elseif Press=='f' then
	if debounce  then return end
	if secondform then return end
	ballshockwave(Torso.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(2,2,2))
	spikeball(Torso.CFrame,Vector3.new(1.5,1.5,1.5),BrickColor.White(),.05,"Neon")
	realhead.Parent = nil
	realhead2.Parent = Torso
	local hdweld2 = weldBetween(fkhead2,Head)
	shirt.ShirtTemplate = "rbxassetid://238537827"
	pants.PantsTemplate = "rbxassetid://486031443"
	st = staff:Clone() st.Parent = Torso 
    STAFFLERP.Part0 = st.t
    STAFFLERP.Part1 = LeftArm
secondform = true
doomtheme.SoundId = "rbxassetid://1382488262"
doomtheme.TimePosition = 20.7
doomtheme:Play()
dmt2 = {1382488262,4592815034,4593898734,4627771248}
coroutine.wrap(function()
if tauntdebounce then return end
tauntdebounce = true
local rdnm2 = introable[math.random(1,#introable)]
for i = 1, 2 do
local tauntsound = Instance.new("Sound", Head)
tauntsound.Volume = 10
tauntsound.SoundId = "rbxassetid://"..rdnm2
tauntsound.Looped = false
tauntsound.Pitch = 1
tauntsound:Play()
coroutine.wrap(function()
	wait(.5)
repeat swait() until tauntsound.IsPlaying == false
tauntsound:Destroy()
wait()
tauntdebounce = false
end)()
removeuseless:AddItem(tauntsound,15)
end
end)()
elseif Press=='z' then
	if debounce then return end
	debounce = true
	attacking = true
	ws = 120
	axe.Transparency = 0
	realhead.beard.Transparency = 0
	doomtheme.SoundId = "rbxassetid://187042245"
	doomtheme:Play()
	doomtheme.Volume = 10
	doomtheme.Pitch = .98
	doomtheme.TimePosition = 3
local light = Instance.new("PointLight", Torso)
light.Color = Color3.new(0,0,0)
light.Range = 0
light.Brightness = 0
light.Range = 35
light.Brightness = 20
light.Color = BrickColor.Random().Color
local b1 = Instance.new("BillboardGui",Head)
b1.Size = UDim2.new(0,100,0,40)
b1.StudsOffset = Vector3.new(0,3,0)
b1.Adornee = Head
local b2 = Instance.new("TextLabel",b1)
b2.BackgroundTransparency = 1
coroutine.wrap(function()
while wait(.15) do
	light.Color = BrickColor.Random().Color
b2.Text = "DIGGY DIGGY HOLE!!!"
b2.TextColor3 = BrickColor.Random().Color
end
end)()
b2.Font = "Arcade"
b2.TextSize = 30
b2.TextStrokeTransparency = 0
b2.TextColor3 = BrickColor.new("Lime green").Color
b2.TextStrokeColor3 = Color3.new(0,0,0)
b2.Size = UDim2.new(1,0,0.5,0)
	while wait() do
		for i = 1, 9 do
			HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-8.9),math.rad(-41),math.rad(-8.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.6,1.6,-0.2)*CFrame.Angles(math.rad(-49),math.rad(-15.7),math.rad(35.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,2.6,0.1)*CFrame.Angles(math.rad(-38.5),math.rad(-40.6),math.rad(-1.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.9,1.4,-1.2)*CFrame.Angles(math.rad(-129.1),math.rad(30.5),math.rad(-34.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.3,1.5,1.8)*CFrame.Angles(math.rad(23.5),math.rad(15.5),math.rad(-18.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-27.6),math.rad(-40.7),math.rad(-28.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			AXELERP.C0 = AXELERP.C0:lerp(CFrame.new(2.1,-0.2,-0.2)*CFrame.Angles(math.rad(-78.1),math.rad(0.9),math.rad(-125.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			swait()
		end
				for i = 1, 9 do
					AXELERP.C0 = AXELERP.C0:lerp(CFrame.new(2.5,0.5,-1.3)*CFrame.Angles(math.rad(-118.9),math.rad(-23.3),math.rad(-86))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
					HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.2,-2,0)*CFrame.Angles(math.rad(-7.6),math.rad(-27.9),math.rad(-5.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
					LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(2,1.1,0.5)*CFrame.Angles(math.rad(26.5),math.rad(-15.7),math.rad(35.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
					LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,1.7,2)*CFrame.Angles(math.rad(8.2),math.rad(-40.6),math.rad(-1.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
					RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-2,0.4,-0.4)*CFrame.Angles(math.rad(-149),math.rad(-23.9),math.rad(-50.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
					RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.3,1.5,1.8)*CFrame.Angles(math.rad(23.5),math.rad(15.5),math.rad(-18.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
					ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-27.6),math.rad(-40.7),math.rad(16.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
			swait()
		end
	end
elseif Press=='e' then
	if debounce then return end
	debounce = true
	attacking = true
	if secondform then
		ws = 8
		attacktaunt()
local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(0,90000,0)
		for i = 1, 20 do
			g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.2)
			HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.1,-2,-0.1)*CFrame.Angles(math.rad(2.9),math.rad(30.1),math.rad(-1.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-0.9,2.3,0.5)*CFrame.Angles(math.rad(107),math.rad(-57.9),math.rad(-165.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.6,1.7)*CFrame.Angles(math.rad(14.2),math.rad(-27.1),math.rad(0.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,1.7,1.7)*CFrame.Angles(math.rad(31.1),math.rad(28.5),math.rad(-18.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(-0.6,0,1.1)*CFrame.Angles(math.rad(96),math.rad(-12.6),math.rad(35.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-17),math.rad(31.2),math.rad(-14.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			swait()
		end
		local a = Instance.new("Part",Torso)
		a.Size = Vector3.new(1,1,1)
		a.Anchored = true
		a.CanCollide = false
		a.Transparency = 1
		a.CFrame = Root.CFrame * CFrame.new(0,0,-5)
		for i = 1, 2 do
		local am = Instance.new("Sound",a)
		am.SoundId = "rbxassetid://4086041756"
		am.Volume = 10
		am.Pitch = .95
		am.TimePosition = .25
		am:Play()
		removeuseless:AddItem(am,15)
		end
		coroutine.wrap(function()
			local xx = 20
			for i = 1, 200 do
				a.CFrame = a.CFrame * CFrame.new(0,0,-xx)
local didhit = false
local mate = nil
local colo = nil
local ray = Ray.new(a.Position,Vector3.new(0,-25,0))
local tabd = {bloodfolder,Character}
local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,Root,Character,blooddecal,blowd,Torso},false,true)
if part then
	didhit = true
mate = part.Material
colo = part.BrickColor
else
	didhit = false
end
if didhit then
	local randomc = math.random(1,#cardtable)
	local pick = cardtable[randomc] local card = pick:Clone() card.Parent = Torso card.Size = Vector3.new(.1,.25,.1)
	card.CFrame = CFrame.new(hitPosition) * CFrame.new(math.random(-5,5),0,math.random(-5,5))
	coroutine.wrap(function()
		local az = math.random(-180,180)
		for i = 1, 40 do
			card.CFrame = card.CFrame:lerp(card.CFrame*CFrame.Angles(0,math.rad(az),0),.09)
			card.Size = card.Size + Vector3.new(.175,0,.32)
			swait()
		end
		local explo = Instance.new("Part",Torso)
		explo.BrickColor = BrickColor.new("Really black")
		explo.Material = "Neon"
		explo.Anchored = true
		explo.CanCollide = false
		explo.CFrame = card.CFrame * CFrame.Angles(math.rad(90),math.rad(90),0)
		explo.Size = Vector3.new(3,3,3)
		local explom = Instance.new("SpecialMesh",explo)
		explom.MeshType = "Sphere"
		SOUND(explo,3855293277,4,false,math.random(9,11)/10,15)
		local hit = damagealll(15,card.Position)
		for _,v in pairs(hit) do
        if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
	death(v:FindFirstChildOfClass("Humanoid").Parent)
    end
end
		local explo2 = explo:Clone() explo2.Parent = Torso explo2.BrickColor = BrickColor.new("White") explo2.Transparency = .5
			spikeball(CFrame.new(explo.Position),Vector3.new(2,2,2),BrickColor.new("White"),.1,"Neon")
			shockwave(CFrame.new(explo.Position),Vector3.new(2,.75,2),.05,BrickColor.new("Really black"),math.random(16,21),.1,"Neon")
			shockwave(CFrame.new(explo.Position),Vector3.new(3,.25,3),.05,BrickColor.new("White"),math.random(2,5),.05,"Neon")
			for i = 1, 20 do
				explo.Size = explo.Size + Vector3.new(5,1,1)
				explo.Transparency = explo.Transparency + .05
				explo2.Size = explo.Size + Vector3.new(5,1,1)*1.1
				explo2.Transparency = explo.Transparency + .025
				swait()
			end
			explo.Transparency = 1
			removeuseless:AddItem(explo,3)
			explo2:Destroy()
		local az2 = math.random(-180,180)
		for i = 1, 40 do
			card.CFrame = card.CFrame:lerp(card.CFrame*CFrame.Angles(0,math.rad(az2),0),.09)
			card.Size = card.Size - Vector3.new(.175,0,.32)
			swait()
		end
		card:Destroy()
		end)()
end
				swait()
			end
			a:Destroy()
		end)()
		for i = 1, 26 do
			blocktrail(st.shbox.Position,Vector3.new(1.5,1.5,1.5),.05,"Neon",BrickColor.new("Really red"))
			HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0.1,-2,0.2)*CFrame.Angles(math.rad(-6.8),math.rad(-42.2),math.rad(2.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.9,0.9,0.5)*CFrame.Angles(math.rad(-100.2),math.rad(28.8),math.rad(5.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.1,2.8,0.4)*CFrame.Angles(math.rad(-32.7),math.rad(-50.3),math.rad(9.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.1,0.5,2)*CFrame.Angles(math.rad(64.5),math.rad(28.5),math.rad(-18.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(-0.1,-0.6,1.2)*CFrame.Angles(math.rad(113.2),math.rad(13.1),math.rad(-0.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-36.8),math.rad(-44.8),math.rad(4.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
			swait()
		end
		g1:Destroy()
		debounce = false
		attacking = false
		ws = 90
		else
	ws = 8
	local g1 = Instance.new("BodyGyro", nil)
g1.CFrame = Root.CFrame
g1.Parent = Root
g1.D = 175
g1.P = 20000
g1.MaxTorque = Vector3.new(3000,90000,3000)
SOUND(Torso,1888686669,10,false,math.random(9,11)/10,15)
coroutine.wrap(function()
for i = 1, 20 do
	HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0.1,-1.9,0.5)*CFrame.Angles(math.rad(-15.7),math.rad(-46.7),math.rad(2.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1,2.7,-0.5)*CFrame.Angles(math.rad(-105.8),math.rad(-50.1),math.rad(24.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.8,0.2)*CFrame.Angles(math.rad(-28.9),math.rad(-55.6),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,1.3,1.3)*CFrame.Angles(math.rad(4),math.rad(46),math.rad(-35.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.8,1.3,1.8)*CFrame.Angles(math.rad(13),math.rad(25),math.rad(11.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-30.6),math.rad(-56.3),math.rad(2.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	swait()
end
end)()
	local randomc = math.random(1,#cardtable)
	local pick = cardtable[randomc]
	local bigcard = pick:Clone() bigcard.Parent = Torso bigcard.Size = Vector3.new(.1,.25,.1) bigcard.Transparency = 0
	bigcard.Anchored = false
	bigcard.CanCollide = false
	bigcard.Massless = true
	bigcard.Material = "Neon"
    local bigcardweld = weldBetween(bigcard,Root) bigcardweld.C0 =  CFrame.Angles(math.rad(90),0,math.rad(0))* CFrame.new(0,0,5) 
local titt = 0
spikeball(bigcard.CFrame,Vector3.new(.5,.5,.5),BrickColor.new("White"),.035,"Neon")
spikeball(bigcard.CFrame,Vector3.new(1,1,1),BrickColor.new("White"),.05,"Neon")
ballshockwave(bigcard.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(1.5,1.5,1.5))
	for i = 1, 40 do
		titt = titt + 2
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		bigcard.Size = bigcard.Size + Vector3.new(.175,0,.3)
		bigcardweld.C0 = bigcardweld.C0:lerp(bigcardweld.C0 * CFrame.Angles(math.rad(0),math.rad(0),math.rad(titt)),.09)
		swait()
	end
    local blackhole = Instance.new("Sound",bigcard)
blackhole.SoundId = "rbxassetid://1835334344"
blackhole.Volume = 8
blackhole.Pitch = 1
blackhole:Play()
	local portal = Instance.new("Part",Torso)
	portal.Anchored = false
	portal.CanCollide = false
	portal.Size = Vector3.new(.35,4.5,4.5)
	portal.Material = "Neon"
	portal.BrickColor = BrickColor.new("White")
	portal.Shape = "Cylinder"
	portal.Transparency = 1
	local portalweld = weldBetween(portal,bigcard) portalweld.C0 = portalweld.C0 * CFrame.Angles(math.rad(0),math.rad(0),math.rad(90))
	for i = 1, 10 do
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		portal.Transparency = portal.Transparency - .05
		bigcard.Size = bigcard.Size + Vector3.new(.175/2,0,.3/2)
		bigcardweld.C0 = bigcardweld.C0:lerp(bigcardweld.C0 * CFrame.Angles(math.rad(0),math.rad(0),math.rad(titt)),.09)
		swait()
	end
		for i = 1, 10 do
			g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		portal.Transparency = portal.Transparency - .05
		bigcard.Size = bigcard.Size - Vector3.new(.175/2,0,.3/2)
		bigcardweld.C0 = bigcardweld.C0:lerp(bigcardweld.C0 * CFrame.Angles(math.rad(0),math.rad(0),math.rad(titt)),.09)
		swait()
	end
	titt = titt + 4
	local hitbox = Instance.new("Part",Torso)
	hitbox.Size = Vector3.new(1,1,1)
	hitbox.Anchored = true
	hitbox.CanCollide = false
	hitbox.CFrame = Root.CFrame * CFrame.new(0,0,-10)
	hitbox.Transparency = 1
	for i = 1, 500 do
		local zv = math.random(1,2)
		if zv == 1 then
			local blc = Instance.new("Part",Torso)
			blc.Anchored = true
			blc.CanCollide = false
			blc.CFrame = hitbox.CFrame * CFrame.new(0,0,-10) * CFrame.new(math.random(-20,20),math.random(-20,20),math.random(-20,20)) * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
			blc.Material = "Neon"
			blc.Transparency = 0
			blc.BrickColor = BrickColor.new("White")
			blc.Size = Vector3.new(2,2,2)
			coroutine.wrap(function()
				for i = 1, 20 do
					blc.Size = blc.Size - Vector3.new(.1,.1,.1)
					blc.CFrame = blc.CFrame:lerp(CFrame.new(portal.Position),.2)
					blc.Transparency = blc.Transparency + .05
					swait()
				end
				blc:Destroy()
			end)()
		end
		local hit = damagealll(27,hitbox.Position)
		for _,v in pairs(hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
local enemychar = slachtoffer.Parent
pcall(function()
	local creep = Instance.new("Part",Torso)
	creep.Anchored = true
	creep.CanCollide = false
	creep.Transparency = 1
	creep.CFrame = enemychar.Torso.CFrame
	creep.Size = Vector3.new(1,1,1)
	removeuseless:AddItem(creep,10)
	SOUND(creep,314678645,10,false,math.random(9.5,10.5)/10,15)
for i,v in pairs(enemychar:GetDescendants()) do
			if v:IsA("Part") then
				v.BrickColor = BrickColor.new("White")
				v.Material = "Neon"
				v.Anchored = true
				v.Parent = Torso
				v.CanCollide = false
				v:BreakJoints()
				coroutine.wrap(function()
					local a1 = math.rad(math.random(-180,180))
					local a2 = math.rad(math.random(-180,180))
					local a3 = math.rad(math.random(-180,180))
				for i = 1, 80 do
					v.CFrame = v.CFrame:lerp(CFrame.new(portal.Position)*CFrame.Angles(a1,a2,a3),.05)
					v.Transparency = v.Transparency + .0125
					swait()
				end
				v:Destroy()
				end)()
			elseif v:IsA("MeshPart") then
				v.BrickColor = BrickColor.new("White")
				v.Material = "Neon"
				v.Anchored = true
				v.Parent = Torso
				v.CanCollide = false
				enemychar:Destroy()
			end
end
end)
end
		end
		g1.CFrame = g1.CFrame:lerp(CFrame.new(Root.Position,mouse.Hit.p),.09)
		hitbox.CFrame = Root.CFrame * CFrame.new(0,0,-25)
		bigcardweld.C0 = bigcardweld.C0:lerp(bigcardweld.C0 * CFrame.Angles(math.rad(0),math.rad(0),math.rad(titt)),.25)
		swait()
	end
	bigcardweld:Destroy()
	bigcard.Anchored = true
	coroutine.wrap(function()
		SOUND(portal,4086044079,10,false,math.random(9.5,10.5)/10,15)
		for i = 1, 20 do
			portal.Transparency = portal.Transparency + .05
			portal.Size = portal.Size - portal.size/20
			bigcard.Size = bigcard.Size - bigcard.Size/10
			bigcard.Transparency = bigcard.Transparency + .05
			swait()
		end
		removeuseless:AddItem(portal,10)
		bigcard:Destroy()
	end)()
	g1:Destroy()
	ws = 100
	debounce = false
	attacking = false
	end
end
end

-- Teclado virtual: chama diretamente o mesmo manipulador das teclas,
-- sem fabricar InputObject, disparar UserInputService ou enviar UserInput_Event.
mouse.KeyDown:connect(HandleVirtualKey)

task.spawn(function()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local localPlayer = Players.LocalPlayer or Player
    local playerGui = localPlayer:WaitForChild("PlayerGui")

    local oldGui = playerGui:FindFirstChild("AllInOneVirtualKeyboard")
    if oldGui then oldGui:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "AllInOneVirtualKeyboard"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 1000
    gui.Parent = playerGui

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Size = UDim2.new(0, 255, 0, 245)
    panel.Position = UDim2.new(1, -270, 0.5, -122)
    panel.BackgroundColor3 = Color3.fromRGB(28, 30, 38)
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90, 98, 125)
    stroke.Thickness = 1
    stroke.Parent = panel

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -44, 0, 34)
    title.Position = UDim2.new(0, 10, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "CONTROLES VIRTUAIS"
    title.TextColor3 = Color3.fromRGB(240, 242, 255)
    title.TextSize = 13
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = panel

    local minimize = Instance.new("TextButton")
    minimize.Name = "Minimize"
    minimize.Size = UDim2.new(0, 30, 0, 26)
    minimize.Position = UDim2.new(1, -35, 0, 4)
    minimize.BackgroundColor3 = Color3.fromRGB(54, 58, 72)
    minimize.Text = "—"
    minimize.TextColor3 = Color3.new(1,1,1)
    minimize.TextSize = 16
    minimize.Font = Enum.Font.GothamBold
    minimize.Parent = panel
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(0, 6)

    local keys = {
        {"M", "Transformação / reiniciar personagem"},
        {"Y", "Ataque especial"},
        {"T", "Provocação"},
        {"R", "Ataque / carregar"},
        {"Q", "Habilidade Q"},
        {"G", "Habilidade G"},
        {"F", "Habilidade F"},
        {"Z", "Habilidade Z"},
        {"E", "Habilidade E"},
    }

    local grid = Instance.new("Frame")
    grid.Name = "KeyGrid"
    grid.BackgroundTransparency = 1
    grid.Position = UDim2.new(0, 9, 0, 42)
    grid.Size = UDim2.new(1, -18, 1, -51)
    grid.Parent = panel

    local layout = Instance.new("UIGridLayout")
    layout.CellSize = UDim2.new(0, 74, 0, 54)
    layout.CellPadding = UDim2.new(0, 5, 0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = grid

    for index, data in ipairs(keys) do
        local keyName, description = data[1], data[2]
        local button = Instance.new("TextButton")
        button.Name = "Key_" .. keyName
        button.LayoutOrder = index
        button.BackgroundColor3 = Color3.fromRGB(55, 61, 79)
        button.BorderSizePixel = 0
        button.Text = keyName .. "\n" .. description
        button.TextColor3 = Color3.fromRGB(245, 246, 255)
        button.TextSize = 10
        button.TextWrapped = true
        button.Font = Enum.Font.GothamSemibold
        button.Parent = grid
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 7)

        button.Activated:Connect(function()
            -- Chamada direta da lógica original; não simula input do Roblox.
            local ok, err = pcall(HandleVirtualKey, keyName:lower())
            if not ok then warn("[Teclado virtual] " .. keyName .. ": " .. tostring(err)) end
        end)
    end

    local minimized = false
    minimize.Activated:Connect(function()
        minimized = not minimized
        grid.Visible = not minimized
        panel.Size = minimized and UDim2.new(0, 255, 0, 38) or UDim2.new(0, 255, 0, 245)
        minimize.Text = minimized and "+" or "—"
    end)

    -- Arrastar o painel pelo cabeçalho.
    local dragging, dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = panel.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end)


checks1 = coroutine.wrap(function() 
while true do
if Root.Velocity.Magnitude < 8 and not attacking then
position = "Idle"
elseif Root.Velocity.Magnitude > 8 and not attacking then
position = "Walking"
else
end
wait()
end
end)
checks1()

immortal = {}
for i,v in pairs(Character:GetDescendants()) do
	if v:IsA("BasePart") and v.Name ~= "lmagic" and v.Name ~= "rmagic" then
		if v ~= Root and v ~= Torso and v ~= Head and v ~= RightArm and v ~= LeftArm and v ~= RightLeg and v.Name ~= "lmagic" and v.Name ~= "rmagic" and v ~= LeftLeg then
			v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0, 0, 0)
		end
		table.insert(immortal,{v,v.Parent,v.Material,v.Color,v.Transparency})
	elseif v:IsA("JointInstance") then
		table.insert(immortal,{v,v.Parent,nil,nil,nil})
	end
end
for e = 1, #immortal do
if immortal[e] ~= nil then
local STUFF = immortal[e]
local PART = STUFF[1]
local PARENT = STUFF[2]
local MATERIAL = STUFF[3]
local COLOR = STUFF[4]
local TRANSPARENCY = STUFF[5]
if levitate then
if PART.ClassName == "Part" and PART ~= Root and PART.Name ~= eyo1 and PART.Name ~= eyo2 and PART.Name ~= "lmagic" and PART.Name ~= "rmagic" then
PART.Material = MATERIAL
PART.Color = COLOR
PART.Transparency = TRANSPARENCY
end
PART.AncestryChanged:connect(function()
PART.Parent = PARENT
end)
else
if PART.ClassName == "Part" and PART ~= Root and PART.Name ~= "lmagic" and PART.Name ~= "rmagic" then
PART.Material = MATERIAL
PART.Color = COLOR
PART.Transparency = TRANSPARENCY
end
PART.AncestryChanged:connect(function()
PART.Parent = PARENT
end)
end
end
end
function immortality()
for e = 1, #immortal do
if immortal[e] ~= nil then
local STUFF = immortal[e]
local PART = STUFF[1]
local PARENT = STUFF[2]
local MATERIAL = STUFF[3]
local COLOR = STUFF[4]
local TRANSPARENCY = STUFF[5]
if PART.ClassName == "Part" and PART == Root then
PART.Material = MATERIAL
PART.Color = COLOR
PART.Transparency = TRANSPARENCY
end
if PART.Parent ~= PARENT then
hum:Remove()
PART.Parent = PARENT
hum = Instance.new("Humanoid",Character)
hum.Name = "noneofurbusiness"
end
end
end
end
if Character:FindFirstChild"CharacterMesh" then
	Character:FindFirstChild"CharacterMesh":Destroy()
end
if Character:FindFirstChild"Body Colors" then
Character:FindFirstChild"Body Colors".HeadColor = BrickColor.new("Really black")
Character:FindFirstChild"Body Colors".TorsoColor = BrickColor.new("Really black")
Character:FindFirstChild"Body Colors".LeftArmColor = BrickColor.new("Really black")
Character:FindFirstChild"Body Colors".RightArmColor = BrickColor.new("Really black")
Character:FindFirstChild"Body Colors".LeftLegColor = BrickColor.new("Really black")
Character:FindFirstChild"Body Colors".RightLegColor = BrickColor.new("Really black")
end
coroutine.wrap(function()
	while wait(.25) do
				local t = wosh:Clone() t.Parent = Torso
	t.CFrame = Root.CFrame * CFrame.new(0,math.random(-5,5),0) * CFrame.Angles(0,math.rad(math.random(-180,180)),0)
	t.Anchored = false
	t.Massless = true
	t.CanCollide = false
	t.Transparency = 1
local tweld = weldBetween(t,Torso)
	coroutine.wrap(function()
		local mthrandom = math.random(-5,5)
		local xci = math.random(-1,1)/40
		local xci2 = math.random(.8,1)
				for i = 1, 100 do
			t.Size = t.Size + Vector3.new(.8,.05,.8)/10
			t.Transparency = t.Transparency - .00125/2
			tweld.C0 = tweld.C0 * CFrame.new(0,xci,0) * CFrame.Angles(0,math.rad(0+mthrandom),0)
			swait()
		end
		for i = 1, 100 do
			t.Size = t.Size + Vector3.new(.8,.05,.8)/10
			t.Transparency = t.Transparency + .00125/2
			tweld.C0 = tweld.C0 * CFrame.new(0,xci,0) * CFrame.Angles(0,math.rad(0+mthrandom),0)
			swait()
		end
		t:Destroy()
	end)()
	end
end)()
coroutine.wrap(function()
while game:GetService("RunService").Stepped:wait() do
hpheight = 4 + 1 * math.sin(sine/16)
hum.HipHeight = hpheight
Head.Transparency = 1
Head.BrickColor = BrickColor.new("Really black")
Torso.BrickColor = Head.BrickColor
LeftArm.BrickColor = Head.BrickColor
RightArm.BrickColor = Head.BrickColor
LeftLeg.BrickColor = Head.BrickColor
RightLeg.BrickColor = Head.BrickColor
hum:SetStateEnabled("Dead",false) hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
if Torso:FindFirstChild("Neck") == nil then
immortality()
end
swait()
end
end)()

local anims = coroutine.wrap(function()
while true do
settime = 0.05
sine = sine + change
sine2 = sine2 + change2
if position == "Walking" and attacking == false then
change = 1
walking = true
if ws < 100 then
	ws = ws + 1
end
if secondform then
	local plant2 = hum.MoveDirection*Torso.CFrame.LookVector
local plant3 = hum.MoveDirection*Torso.CFrame.RightVector
local plant = plant2.Z + plant2.X
local plant4 = plant3.Z + plant3.X
	    STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(0.5,-0.2,1)*CFrame.Angles(math.rad(92.6),math.rad(10.8),math.rad(-21.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.3,-1.9,0.5)*CFrame.Angles(math.rad(-14.8),math.rad(-14.6+5*math.sin(sine/16)),math.rad(-6.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,1.5,0.7)*CFrame.Angles(math.rad(-86.9 + 4 * math.sin(sine/16)),math.rad(-25.1+1*math.sin(sine/16)),math.rad(-5.3+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,1.6,1.8)*CFrame.Angles(math.rad(17.1+3*math.sin(sine/16)),math.rad(-27.1+1*math.sin(sine/16)),math.rad(0.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5-1*math.sin(sine/16)),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.2,1.9)*CFrame.Angles(math.rad(49.9+2*math.sin(sine/16)),math.rad(12.7+1*math.sin(sine/16)),math.rad(-11.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(.15*math.sin(sine/32),0,.15*math.sin(sine/27))*CFrame.Angles(math.rad(4 * math.sin(sine/24)+ Root.RotVelocity.Y / 20),math.rad(-14.9+4*math.sin(sine/31)),math.rad(4*math.sin(sine/27)+ Root.RotVelocity.Y / 20))*CFrame.Angles(math.rad(-plant - plant/5)*32.1,math.rad(-plant4 - plant4/5),math.rad(-plant4 - plant4/5)*15),.125)
	else
local plant2 = hum.MoveDirection*Torso.CFrame.LookVector
local plant3 = hum.MoveDirection*Torso.CFrame.RightVector
local plant = plant2.Z + plant2.X
local plant4 = plant3.Z + plant3.X
HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0,-2,0.2)*CFrame.Angles(math.rad(-5.6-1*math.sin(sine/16)),math.rad(-48.9),math.rad(1.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.1,-0.3,0.4)*CFrame.Angles(math.rad(-42.9 + 3*math.sin(sine/16)),math.rad(68.2 - 1 * math.sin(sine/16)),math.rad(-35.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,0.5,2.1)*CFrame.Angles(math.rad(48.2 + 2 * math.sin(sine/16)),math.rad(-55.6 + 3 * math.sin(sine/16)),math.rad(9.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,1.3,1)*CFrame.Angles(math.rad(4),math.rad(46-3*math.sin(sine/16)),math.rad(-35.1-2*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0.4,2.1,1.5)*CFrame.Angles(math.rad(27.9+1.5*math.sin(sine/16)),math.rad(1.2),math.rad(-47.5+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-30),math.rad(-47.1),math.rad(10.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(.25 * math.sin(sine/19),0,.25*math.sin(sine/22))*CFrame.Angles(math.rad(0+ 2 * math.sin(sine/16)+ Root.RotVelocity.Y / 20),math.rad(-50),math.rad(3)+ Root.RotVelocity.Y / 20)*CFrame.Angles(math.rad(plant - -plant/5)*-27.5,0,math.rad(plant4 - -plant4/5)*-29.4),.25)
end
elseif position == "Idle" and attacking == false then
change = 1
if ws > 11 then
	ws = ws - 1
end
if secondform then
		STAFFLERP.C0 = STAFFLERP.C0:lerp(CFrame.new(0.5,-0.2,1)*CFrame.Angles(math.rad(92.6),math.rad(10.8),math.rad(-21.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(-0.3,-2,-0.1)*CFrame.Angles(math.rad(-0.8),math.rad(-14.6+6*math.sin(sine/27)),math.rad(-6.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,1.5,0.7)*CFrame.Angles(math.rad(-86.9 + 4 * math.sin(sine/16)),math.rad(-25.1+1*math.sin(sine/16)),math.rad(-5.3+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3,2.4,0.5)*CFrame.Angles(math.rad(-22.1+2*math.sin(sine/16)),math.rad(-27.1+2*math.sin(sine/16)),math.rad(0.5+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.8,-0.7,0.3)*CFrame.Angles(math.rad(171.5-1*math.sin(sine/16)),math.rad(79.5),math.rad(-109.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.6,1.5)*CFrame.Angles(math.rad(34.4+1*math.sin(sine/16)),math.rad(12.7+1*math.sin(sine/16)),math.rad(-11.1+1*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(.15*math.sin(sine/32),0,.15*math.sin(sine/27))*CFrame.Angles(math.rad(-21.3 + 4 * math.sin(sine/24)),math.rad(-14.9+4*math.sin(sine/31)),math.rad(-0.5+4*math.sin(sine/27)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.125)
	else
HEADLERP.C0 = HEADLERP.C0:lerp(CFrame.new(0,-2,-0.1)*CFrame.Angles(math.rad(3-1*math.sin(sine/16)),math.rad(-40.2),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.8,1.5+.1,.2)*CFrame.Angles(math.rad(12.7+3*math.sin(sine/16)),math.rad(-3.5+2*math.sin(sine/16)),math.rad(49.2+3*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.3 + .1 * math.sin(sine/16),2.7,0.3 - .1 * math.sin(sine/16))*CFrame.Angles(math.rad(-22.1 - 4 * math.sin(sine/16)),math.rad(-55.6 + 1.5 * math.sin(sine/16)),math.rad(13 - 2.5 * math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.7,1.7+.15*math.sin(sine/16),0.3)*CFrame.Angles(math.rad(-16.1-2*math.sin(sine/16)),math.rad(20.9),math.rad(-44.3-3*math.sin(sine/16)))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.4,1.5)*CFrame.Angles(math.rad(22.6 + 3 * math.sin(sine/16)),math.rad(22.1-2*math.sin(sine/16)),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(.25*math.sin(sine/26),0,.25*math.sin(sine/31))*CFrame.Angles(math.rad(-14.9 + 6 * math.sin(sine/25)),math.rad(-43.1+6*math.sin(sine/32)),math.rad(4.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
end
end
swait()
end
end)
anims()
warn("Surprising resurrection. Made by Supr14")
if game:GetService("ServerStorage").intro.Value == false then
	dox = true
end
	end
end

qx_S["a3"] = function()
	return function()
print("Hello world!")
	end
end

qx_S["a4"] = function()
	return function()
local Figure = script.Parent
local Torso = Figure:WaitForChild("Torso")
local RightShoulder = Torso:WaitForChild("Right Shoulder")
local LeftShoulder = Torso:WaitForChild("Left Shoulder")
local RightHip = Torso:WaitForChild("Right Hip")
local LeftHip = Torso:WaitForChild("Left Hip")
local Neck = Torso:WaitForChild("Neck")
local Humanoid = Figure:WaitForChild("Humanoid")
local pose = "Standing"

local currentAnim = ""
local currentAnimInstance = nil
local currentAnimTrack = nil
local currentAnimKeyframeHandler = nil
local currentAnimSpeed = 1.0
local animTable = {}
local animNames = { 
	idle = 	{	
				{ id = "http://www.roblox.com/asset/?id=180435571", weight = 9 },
				{ id = "http://www.roblox.com/asset/?id=180435792", weight = 1 }
			},
	walk = 	{ 	
				{ id = "http://www.roblox.com/asset/?id=180426354", weight = 10 } 
			}, 
	run = 	{
				{ id = "run.xml", weight = 10 } 
			}, 
	jump = 	{
				{ id = "http://www.roblox.com/asset/?id=125750702", weight = 10 } 
			}, 
	fall = 	{
				{ id = "http://www.roblox.com/asset/?id=180436148", weight = 10 } 
			}, 
	climb = {
				{ id = "http://www.roblox.com/asset/?id=180436334", weight = 10 } 
			}, 
	sit = 	{
				{ id = "http://www.roblox.com/asset/?id=178130996", weight = 10 } 
			},	
	toolnone = {
				{ id = "http://www.roblox.com/asset/?id=182393478", weight = 10 } 
			},
	toolslash = {
				{ id = "http://www.roblox.com/asset/?id=129967390", weight = 10 } 

			},
	toollunge = {
				{ id = "http://www.roblox.com/asset/?id=129967478", weight = 10 } 
			},
	wave = {
				{ id = "http://www.roblox.com/asset/?id=128777973", weight = 10 } 
			},
	point = {
				{ id = "http://www.roblox.com/asset/?id=128853357", weight = 10 } 
			},
	dance1 = {
				{ id = "http://www.roblox.com/asset/?id=182435998", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=182491037", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=182491065", weight = 10 } 
			},
	dance2 = {
				{ id = "http://www.roblox.com/asset/?id=182436842", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=182491248", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=182491277", weight = 10 } 
			},
	dance3 = {
				{ id = "http://www.roblox.com/asset/?id=182436935", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=182491368", weight = 10 }, 
				{ id = "http://www.roblox.com/asset/?id=182491423", weight = 10 } 
			},
	laugh = {
				{ id = "http://www.roblox.com/asset/?id=129423131", weight = 10 } 
			},
	cheer = {
				{ id = "http://www.roblox.com/asset/?id=129423030", weight = 10 } 
			},
}
local dances = {"dance1", "dance2", "dance3"}


local emoteNames = { wave = false, point = false, dance1 = true, dance2 = true, dance3 = true, laugh = false, cheer = false}

function configureAnimationSet(name, fileList)
	if (animTable[name] ~= nil) then
		for _, connection in pairs(animTable[name].connections) do
			connection:disconnect()
		end
	end
	animTable[name] = {}
	animTable[name].count = 0
	animTable[name].totalWeight = 0	
	animTable[name].connections = {}

	
	local config = script:FindFirstChild(name)
	if (config ~= nil) then

		table.insert(animTable[name].connections, config.ChildAdded:connect(function(child) configureAnimationSet(name, fileList) end))
		table.insert(animTable[name].connections, config.ChildRemoved:connect(function(child) configureAnimationSet(name, fileList) end))
		local idx = 1
		for _, childPart in pairs(config:GetChildren()) do
			if (childPart:IsA("Animation")) then
				table.insert(animTable[name].connections, childPart.Changed:connect(function(property) configureAnimationSet(name, fileList) end))
				animTable[name][idx] = {}
				animTable[name][idx].anim = childPart
				local weightObject = childPart:FindFirstChild("Weight")
				if (weightObject == nil) then
					animTable[name][idx].weight = 1
				else
					animTable[name][idx].weight = weightObject.Value
				end
				animTable[name].count = animTable[name].count + 1
				animTable[name].totalWeight = animTable[name].totalWeight + animTable[name][idx].weight
	
				idx = idx + 1
			end
		end
	end

	
	if (animTable[name].count <= 0) then
		for idx, anim in pairs(fileList) do
			animTable[name][idx] = {}
			animTable[name][idx].anim = Instance.new("Animation")
			animTable[name][idx].anim.Name = name
			animTable[name][idx].anim.AnimationId = anim.id
			animTable[name][idx].weight = anim.weight
			animTable[name].count = animTable[name].count + 1
			animTable[name].totalWeight = animTable[name].totalWeight + anim.weight

		end
	end
end


function scriptChildModified(child)
	local fileList = animNames[child.Name]
	if (fileList ~= nil) then
		configureAnimationSet(child.Name, fileList)
	end	
end

script.ChildAdded:connect(scriptChildModified)
script.ChildRemoved:connect(scriptChildModified)


for name, fileList in pairs(animNames) do 
	configureAnimationSet(name, fileList)
end	




local toolAnim = "None"
local toolAnimTime = 0

local jumpAnimTime = 0
local jumpAnimDuration = 0.3

local toolTransitionTime = 0.1
local fallTransitionTime = 0.3
local jumpMaxLimbVelocity = 0.75



function stopAllAnimations()
	local oldAnim = currentAnim

	
	if (emoteNames[oldAnim] ~= nil and emoteNames[oldAnim] == false) then
		oldAnim = "idle"
	end

	currentAnim = ""
	currentAnimInstance = nil
	if (currentAnimKeyframeHandler ~= nil) then
		currentAnimKeyframeHandler:disconnect()
	end

	if (currentAnimTrack ~= nil) then
		currentAnimTrack:Stop()
		currentAnimTrack:Destroy()
		currentAnimTrack = nil
	end
	return oldAnim
end

function setAnimationSpeed(speed)
	if speed ~= currentAnimSpeed then
		currentAnimSpeed = speed
		currentAnimTrack:AdjustSpeed(currentAnimSpeed)
	end
end

function keyFrameReachedFunc(frameName)
	if (frameName == "End") then

		local repeatAnim = currentAnim
		
		if (emoteNames[repeatAnim] ~= nil and emoteNames[repeatAnim] == false) then
			repeatAnim = "idle"
		end
		
		local animSpeed = currentAnimSpeed
		playAnimation(repeatAnim, 0.0, Humanoid)
		setAnimationSpeed(animSpeed)
	end
end


function playAnimation(animName, transitionTime, humanoid) 
		
	local roll = math.random(1, animTable[animName].totalWeight) 
	local origRoll = roll
	local idx = 1
	while (roll > animTable[animName][idx].weight) do
		roll = roll - animTable[animName][idx].weight
		idx = idx + 1
	end

	local anim = animTable[animName][idx].anim

	
	if (anim ~= currentAnimInstance) then
		
		if (currentAnimTrack ~= nil) then
			currentAnimTrack:Stop(transitionTime)
			currentAnimTrack:Destroy()
		end

		currentAnimSpeed = 1.0
	
		
		currentAnimTrack = humanoid:LoadAnimation(anim)
		currentAnimTrack.Priority = Enum.AnimationPriority.Core
		 
		
		currentAnimTrack:Play(transitionTime)
		currentAnim = animName
		currentAnimInstance = anim

		
		if (currentAnimKeyframeHandler ~= nil) then
			currentAnimKeyframeHandler:disconnect()
		end
		currentAnimKeyframeHandler = currentAnimTrack.KeyframeReached:connect(keyFrameReachedFunc)
		
	end

end




local toolAnimName = ""
local toolAnimTrack = nil
local toolAnimInstance = nil
local currentToolAnimKeyframeHandler = nil

function toolKeyFrameReachedFunc(frameName)
	if (frameName == "End") then

		playToolAnimation(toolAnimName, 0.0, Humanoid)
	end
end


function playToolAnimation(animName, transitionTime, humanoid, priority)	 
		
		local roll = math.random(1, animTable[animName].totalWeight) 
		local origRoll = roll
		local idx = 1
		while (roll > animTable[animName][idx].weight) do
			roll = roll - animTable[animName][idx].weight
			idx = idx + 1
		end

		local anim = animTable[animName][idx].anim

		if (toolAnimInstance ~= anim) then
			
			if (toolAnimTrack ~= nil) then
				toolAnimTrack:Stop()
				toolAnimTrack:Destroy()
				transitionTime = 0
			end
					
			
			toolAnimTrack = humanoid:LoadAnimation(anim)
			if priority then
				toolAnimTrack.Priority = priority
			end
			 
			
			toolAnimTrack:Play(transitionTime)
			toolAnimName = animName
			toolAnimInstance = anim

			currentToolAnimKeyframeHandler = toolAnimTrack.KeyframeReached:connect(toolKeyFrameReachedFunc)
		end
end

function stopToolAnimations()
	local oldAnim = toolAnimName

	if (currentToolAnimKeyframeHandler ~= nil) then
		currentToolAnimKeyframeHandler:disconnect()
	end

	toolAnimName = ""
	toolAnimInstance = nil
	if (toolAnimTrack ~= nil) then
		toolAnimTrack:Stop()
		toolAnimTrack:Destroy()
		toolAnimTrack = nil
	end


	return oldAnim
end





function onRunning(speed)
	if speed > 0.01 then
		playAnimation("walk", 0.1, Humanoid)
		if currentAnimInstance and currentAnimInstance.AnimationId == "http://www.roblox.com/asset/?id=180426354" then
			setAnimationSpeed(speed / 14.5)
		end
		pose = "Running"
	else
		if emoteNames[currentAnim] == nil then
			playAnimation("idle", 0.1, Humanoid)
			pose = "Standing"
		end
	end
end

function onDied()
	pose = "Dead"
end

function onJumping()
	playAnimation("jump", 0.1, Humanoid)
	jumpAnimTime = jumpAnimDuration
	pose = "Jumping"
end

function onClimbing(speed)
	playAnimation("climb", 0.1, Humanoid)
	setAnimationSpeed(speed / 12.0)
	pose = "Climbing"
end

function onGettingUp()
	pose = "GettingUp"
end

function onFreeFall()
	if (jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	end
	pose = "FreeFall"
end

function onFallingDown()
	pose = "FallingDown"
end

function onSeated()
	pose = "Seated"
end

function onPlatformStanding()
	pose = "PlatformStanding"
end

function onSwimming(speed)
	if speed > 0 then
		pose = "Running"
	else
		pose = "Standing"
	end
end

function getTool()	
	for _, kid in ipairs(Figure:GetChildren()) do
		if kid.className == "Tool" then return kid end
	end
	return nil
end

function getToolAnim(tool)
	for _, c in ipairs(tool:GetChildren()) do
		if c.Name == "toolanim" and c.className == "StringValue" then
			return c
		end
	end
	return nil
end

function animateTool()
	
	if (toolAnim == "None") then
		playToolAnimation("toolnone", toolTransitionTime, Humanoid, Enum.AnimationPriority.Idle)
		return
	end

	if (toolAnim == "Slash") then
		playToolAnimation("toolslash", 0, Humanoid, Enum.AnimationPriority.Action)
		return
	end

	if (toolAnim == "Lunge") then
		playToolAnimation("toollunge", 0, Humanoid, Enum.AnimationPriority.Action)
		return
	end
end

function moveSit()
	RightShoulder.MaxVelocity = 0.15
	LeftShoulder.MaxVelocity = 0.15
	RightShoulder:SetDesiredAngle(3.14 /2)
	LeftShoulder:SetDesiredAngle(-3.14 /2)
	RightHip:SetDesiredAngle(3.14 /2)
	LeftHip:SetDesiredAngle(-3.14 /2)
end

local lastTick = 0

function move(time)
	local amplitude = 1
	local frequency = 1
  	local deltaTime = time - lastTick
  	lastTick = time

	local climbFudge = 0
	local setAngles = false

  	if (jumpAnimTime > 0) then
  		jumpAnimTime = jumpAnimTime - deltaTime
  	end

	if (pose == "FreeFall" and jumpAnimTime <= 0) then
		playAnimation("fall", fallTransitionTime, Humanoid)
	elseif (pose == "Seated") then
		playAnimation("sit", 0.5, Humanoid)
		return
	elseif (pose == "Running") then
		playAnimation("walk", 0.1, Humanoid)
	elseif (pose == "Dead" or pose == "GettingUp" or pose == "FallingDown" or pose == "Seated" or pose == "PlatformStanding") then

		stopAllAnimations()
		amplitude = 0.1
		frequency = 1
		setAngles = true
	end

	if (setAngles) then
		local desiredAngle = amplitude * math.sin(time * frequency)

		RightShoulder:SetDesiredAngle(desiredAngle + climbFudge)
		LeftShoulder:SetDesiredAngle(desiredAngle - climbFudge)
		RightHip:SetDesiredAngle(-desiredAngle)
		LeftHip:SetDesiredAngle(-desiredAngle)
	end

	
	local tool = getTool()
	if tool and tool:FindFirstChild("Handle") then
	
		local animStringValueObject = getToolAnim(tool)

		if animStringValueObject then
			toolAnim = animStringValueObject.Value
			
			animStringValueObject.Parent = nil
			toolAnimTime = time + .3
		end

		if time > toolAnimTime then
			toolAnimTime = 0
			toolAnim = "None"
		end

		animateTool()		
	else
		stopToolAnimations()
		toolAnim = "None"
		toolAnimInstance = nil
		toolAnimTime = 0
	end
end


Humanoid.Died:connect(onDied)
Humanoid.Running:connect(onRunning)
Humanoid.Jumping:connect(onJumping)
Humanoid.Climbing:connect(onClimbing)
Humanoid.GettingUp:connect(onGettingUp)
Humanoid.FreeFalling:connect(onFreeFall)
Humanoid.FallingDown:connect(onFallingDown)
Humanoid.Seated:connect(onSeated)
Humanoid.PlatformStanding:connect(onPlatformStanding)
Humanoid.Swimming:connect(onSwimming)


game:GetService("Players").LocalPlayer.Chatted:connect(function(msg)
	local emote = ""
	if msg == "/e dance" then
		emote = dances[math.random(1, #dances)]
	elseif (string.sub(msg, 1, 3) == "/e ") then
		emote = string.sub(msg, 4)
	elseif (string.sub(msg, 1, 7) == "/emote ") then
		emote = string.sub(msg, 8)
	end
	
	if (pose == "Standing" and emoteNames[emote] ~= nil) then
		playAnimation(emote, 0.1, Humanoid)
	end

end)





playAnimation("idle", 0.1, Humanoid)
pose = "Standing"

while Figure.Parent ~= nil do
	local _, time = wait(0.1)
	move(time)
end
	end
end

qx_S["a5"] = function()
	return function()
local REGEN_RATE = 1/100 
local REGEN_STEP = 1 



local Character = script.Parent
local Humanoid = Character:WaitForChild'Humanoid'



while true do
	while Humanoid.Health < Humanoid.MaxHealth do
		local dt = wait(REGEN_STEP)
		local dh = dt*REGEN_RATE*Humanoid.MaxHealth
		Humanoid.Health = math.min(Humanoid.Health + dh, Humanoid.MaxHealth)
	end
	Humanoid.HealthChanged:Wait()
end
	end
end

qx_S["a6"] = function()
	return function()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SOUND_EVENT_FOLDER_NAME = "DefaultSoundEvents"
local DEFAULT_SERVER_SOUND_EVENT_NAME = "DefaultServerSoundEvent"

local SoundEventFolder = ReplicatedStorage:FindFirstChild(SOUND_EVENT_FOLDER_NAME)
local DefaultServerSoundEvent = nil

if not SoundEventFolder then
    SoundEventFolder = Instance.new("Folder")
    SoundEventFolder.Name = SOUND_EVENT_FOLDER_NAME
    SoundEventFolder.Archivable = false
    SoundEventFolder.Parent = ReplicatedStorage
end

DefaultServerSoundEvent = SoundEventFolder:FindFirstChild(DEFAULT_SERVER_SOUND_EVENT_NAME)

if not DefaultServerSoundEvent then
    DefaultServerSoundEvent = Instance.new("RemoteEvent", SoundEventFolder)

	DefaultServerSoundEvent.Name = DEFAULT_SERVER_SOUND_EVENT_NAME
	qx_RS(DefaultServerSoundEvent, function() end)
end

local function CreateNewSound(name, id, looped, pitch, parent)
	local sound = Instance.new("Sound")
	sound.SoundId = id
	sound.Name = name
	sound.archivable = false
	sound.Pitch = pitch
	sound.Looped = looped
	sound.MinDistance = 5
	sound.MaxDistance = 150
	sound.Volume = 0.65
	sound.Parent = parent

	if DefaultServerSoundEvent then
		local CharacterSoundEvent = Instance.new("RemoteEvent", sound)
		CharacterSoundEvent.Name = "CharacterSoundEvent"
		qx_RS(CharacterSoundEvent, function(player, playing, resetPosition)
			if type(playing) ~= "boolean" then
				return
			end
			if type(resetPosition) ~= "boolean" then
				return
			end

			if player.Character ~= script.Parent then
				return
			end
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player then
					
                    SoundEventFolder:FindFirstChild("SoundDispatcher"):Fire(p, sound, playing, resetPosition)
				end
			end
		end)
	end
	return sound
end

local head = script.Parent:FindFirstChild("Head")
if not head then
	error("Sound script parent has no child Head.")
	return
end

CreateNewSound("GettingUp", "rbxasset://sounds/action_get_up.mp3", false, 1, head)
CreateNewSound("Died", "rbxasset://sounds/uuhhh.mp3", false, 1, head) 
CreateNewSound("FreeFalling", "rbxasset://sounds/action_falling.mp3", true, 1, head)
CreateNewSound("Jumping", "rbxasset://sounds/action_jump.mp3", false, 1, head)
CreateNewSound("Landing", "rbxasset://sounds/action_jump_land.mp3", false, 1, head)
CreateNewSound("Splash", "rbxasset://sounds/impact_water.mp3", false, 1, head)
CreateNewSound("Running", "rbxasset://sounds/action_footsteps_plastic.mp3", true, 1.85, head)
CreateNewSound("Swimming", "rbxasset://sounds/action_swim.mp3", true, 1.6, head)
CreateNewSound("Climbing", "rbxasset://sounds/action_footsteps_plastic.mp3", true, 1, head)
	end
end

qx_S["a7"] = function()
	return function()
local SFX = {
	Died = 0;
	Running = 1;
	Swimming = 2;
	Climbing = 3,
	Jumping = 4;
	GettingUp = 5;
	FreeFalling = 6;
	FallingDown = 7;
	Landing = 8;
	Splash = 9;
}

local Humanoid = nil
local Head = nil

local Sounds = {}
local SoundService = game:GetService("SoundService")
local soundEventFolderName = "DefaultSoundEvents"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddCharacterLoadedEvent = nil
local RemoveCharacterEvent = nil
local soundEventFolder = ReplicatedStorage:FindFirstChild(soundEventFolderName)

if not soundEventFolder then
    soundEventFolder = Instance.new("Folder", ReplicatedStorage)
    soundEventFolder.Name = soundEventFolderName
    soundEventFolder.Archivable = false
end


RemoveCharacterEvent = soundEventFolder:FindFirstChild("RemoveCharacterEvent")
if RemoveCharacterEvent == nil then
    RemoveCharacterEvent = Instance.new("RemoteEvent", soundEventFolder)
    RemoveCharacterEvent.Name = "RemoveCharacterEvent"
end

AddCharacterLoadedEvent = soundEventFolder:FindFirstChild("AddCharacterLoadedEvent")
if AddCharacterLoadedEvent == nil then
    AddCharacterLoadedEvent = Instance.new("RemoteEvent", soundEventFolder)
    AddCharacterLoadedEvent.Name = "AddCharacterLoadedEvent"
end


qx_RF(AddCharacterLoadedEvent)


game.Players.LocalPlayer.CharacterRemoving:connect(function(character)
    qx_RF(RemoveCharacterEvent, game.Players.LocalPlayer)
end)

do
	local Figure = script.Parent.Parent
	Head = Figure:WaitForChild("Head")
	while not Humanoid do
		for _,NewHumanoid in pairs(Figure:GetChildren()) do
			if NewHumanoid:IsA("Humanoid") then
				Humanoid = NewHumanoid
				break
			end
		end
		if Humanoid then break end
		Figure.ChildAdded:wait()
	end
	Sounds[SFX.Died] = 			Head:WaitForChild("Died")
	Sounds[SFX.Running] = 		Head:WaitForChild("Running")
	Sounds[SFX.Swimming] = 	Head:WaitForChild("Swimming")
	Sounds[SFX.Climbing] = 	Head:WaitForChild("Climbing")
	Sounds[SFX.Jumping] = 		Head:WaitForChild("Jumping")
	Sounds[SFX.GettingUp] = 	Head:WaitForChild("GettingUp")
	Sounds[SFX.FreeFalling] = 	Head:WaitForChild("FreeFalling")
	Sounds[SFX.Landing] = 		Head:WaitForChild("Landing")
	Sounds[SFX.Splash] = 		Head:WaitForChild("Splash")

	local DefaultServerSoundEvent = soundEventFolder:FindFirstChild("DefaultServerSoundEvent")

	if DefaultServerSoundEvent then
		DefaultServerSoundEvent.OnClientEvent:connect(function(sound, playing, resetPosition)
			if resetPosition and sound.TimePosition ~= 0 then
				sound.TimePosition = 0
			end
			if sound.IsPlaying ~= playing then
				sound.Playing = playing
			end
		end)
	end
end

local IsSoundFilteringEnabled = function()
	return game.Workspace.FilteringEnabled and SoundService.RespectFilteringEnabled
end

local Util
Util = {

	
	YForLineGivenXAndTwoPts = function(x,pt1x,pt1y,pt2x,pt2y)
		
		local m = (pt1y - pt2y) / (pt1x - pt2x)
		
		local b = (pt1y - m * pt1x)
		return m * x + b
	end;

	
	Clamp = function(val,min,max)
		return math.min(max,math.max(min,val))	
	end;

	
	HorizontalSpeed = function(Head)
		local hVel = Head.Velocity + Vector3.new(0,-Head.Velocity.Y,0)
		return hVel.magnitude	
	end;

	
	VerticalSpeed = function(Head)
		return math.abs(Head.Velocity.Y)
	end;

	
	
	Play = function(sound)	
		if IsSoundFilteringEnabled() then
			qx_RF(sound.CharacterSoundEvent, true, true)
		end
		if sound.TimePosition ~= 0 then
			sound.TimePosition = 0
		end
		if not sound.IsPlaying then
			sound.Playing = true
		end
	end;

	Pause = function(sound)
		if IsSoundFilteringEnabled() then
			qx_RF(sound.CharacterSoundEvent, false, false)
		end
		if sound.IsPlaying then
			sound.Playing = false
		end
	end;

	Resume = function(sound)
		if IsSoundFilteringEnabled() then
			qx_RF(sound.CharacterSoundEvent, true, false)
		end
		if not sound.IsPlaying then
			sound.Playing = true
		end
	end;

	Stop = function(sound)
		if IsSoundFilteringEnabled() then
			qx_RF(sound.CharacterSoundEvent, false, true)
		end
		if sound.IsPlaying then
			sound.Playing = false
		end
		if sound.TimePosition ~= 0 then
			sound.TimePosition = 0
		end
	end;
}

do
	
	local playingLoopedSounds = {}

	
	local activeState = nil

	local fallSpeed = 0

	
	function setSoundInPlayingLoopedSounds(sound)
		for i=1, #playingLoopedSounds do
			if playingLoopedSounds[i] == sound then
				return
			end
		end	
		table.insert(playingLoopedSounds,sound)
	end

	
	function stopPlayingLoopedSoundsExcept(except)
		for i=#playingLoopedSounds,1,-1 do
			if playingLoopedSounds[i] ~= except then
				Util.Pause(playingLoopedSounds[i])			
				table.remove(playingLoopedSounds,i)	
			end
		end
	end

	
	local stateUpdateHandler = {
		[Enum.HumanoidStateType.Dead] = function()
			stopPlayingLoopedSoundsExcept()
			local sound = Sounds[SFX.Died]
			Util.Play(sound)
		end;

		[Enum.HumanoidStateType.RunningNoPhysics] = function(speed)
			stateUpdated(Enum.HumanoidStateType.Running, speed)
		end;

		[Enum.HumanoidStateType.Running] = function(speed)	
			local sound = Sounds[SFX.Running]
			stopPlayingLoopedSoundsExcept(sound)

			if(activeState == Enum.HumanoidStateType.Freefall and fallSpeed > 0.1) then
				
				local vol = math.min(1.0, math.max(0.0, (fallSpeed - 50) / 110))
				local freeFallSound = Sounds[SFX.FreeFalling]
				freeFallSound.Volume = vol
				Util.Play(freeFallSound)
				fallSpeed = 0
			end
            if speed ~= nil and speed > 0.5 then
                Util.Resume(sound)
                setSoundInPlayingLoopedSounds(sound)
            elseif speed ~= nil then
                stopPlayingLoopedSoundsExcept()
            end
		end;

		[Enum.HumanoidStateType.Swimming] = function(speed)
		    local threshold = speed
			if activeState ~= Enum.HumanoidStateType.Swimming and threshold > 0.1 then
				local splashSound = Sounds[SFX.Splash]
				splashSound.Volume = Util.Clamp(
					Util.YForLineGivenXAndTwoPts(
						Util.VerticalSpeed(Head), 
						100, 0.28, 
						350, 1),
					0,1)
				Util.Play(splashSound)
			end

			do
				local sound = Sounds[SFX.Swimming]
				stopPlayingLoopedSoundsExcept(sound)
				Util.Resume(sound)
				setSoundInPlayingLoopedSounds(sound)
			end
		end;

		[Enum.HumanoidStateType.Climbing] = function(speed)
			local sound = Sounds[SFX.Climbing]
            if speed ~= nil and math.abs(speed) > 0.1 then
                Util.Resume(sound)
                stopPlayingLoopedSoundsExcept(sound)
            else
                Util.Pause(sound)
                stopPlayingLoopedSoundsExcept(sound)
            end

			setSoundInPlayingLoopedSounds(sound)
		end;

		[Enum.HumanoidStateType.Jumping] = function()
			if activeState == Enum.HumanoidStateType.Jumping then
				return
			end		
			stopPlayingLoopedSoundsExcept()
			local sound = Sounds[SFX.Jumping]
			Util.Play(sound)
		end;

		[Enum.HumanoidStateType.GettingUp] = function()
			stopPlayingLoopedSoundsExcept()
			local sound = Sounds[SFX.GettingUp]
			Util.Play(sound)
		end;

		[Enum.HumanoidStateType.Freefall] = function()
			if activeState == Enum.HumanoidStateType.Freefall then
				return
			end
			local sound = Sounds[SFX.FreeFalling]
			sound.Volume = 0
			stopPlayingLoopedSoundsExcept()

			fallSpeed = math.max(fallSpeed, math.abs(Head.Velocity.y))
		end;

		[Enum.HumanoidStateType.FallingDown] = function()
			stopPlayingLoopedSoundsExcept()
		end;

		[Enum.HumanoidStateType.Landed] = function()
			stopPlayingLoopedSoundsExcept()
			if Util.VerticalSpeed(Head) > 75 then
				local landingSound = Sounds[SFX.Landing]
				landingSound.Volume = Util.Clamp(
					Util.YForLineGivenXAndTwoPts(
						Util.VerticalSpeed(Head), 
						50, 0, 
						100, 1),
					0,1)
				Util.Play(landingSound)			
			end
		end;

		[Enum.HumanoidStateType.Seated] = function()
			stopPlayingLoopedSoundsExcept()
		end;	
	}

	

	
	function stateUpdated(state, speed)
		if stateUpdateHandler[state] ~= nil then
			if (state == Enum.HumanoidStateType.Running
				or state == Enum.HumanoidStateType.Climbing
				or state == Enum.HumanoidStateType.Swimming
				or state == Enum.HumanoidStateType.RunningNoPhysics) then
				stateUpdateHandler[state](speed)
			else
				stateUpdateHandler[state]()
			end
		end
		activeState = state
	end

	Humanoid.Died:connect(			function() stateUpdated(Enum.HumanoidStateType.Dead) 			end)
	Humanoid.Running:connect(		function(speed) stateUpdated(Enum.HumanoidStateType.Running, speed) end)
	Humanoid.Swimming:connect(		function(speed) stateUpdated(Enum.HumanoidStateType.Swimming, speed) end)
	Humanoid.Climbing:connect(		function(speed) stateUpdated(Enum.HumanoidStateType.Climbing, speed) end)
	Humanoid.Jumping:connect(		function() stateUpdated(Enum.HumanoidStateType.Jumping) 		end)
	Humanoid.GettingUp:connect(		function() stateUpdated(Enum.HumanoidStateType.GettingUp) 		end)
	Humanoid.FreeFalling:connect(	function() stateUpdated(Enum.HumanoidStateType.Freefall) 		end)
	Humanoid.FallingDown:connect(	function() stateUpdated(Enum.HumanoidStateType.FallingDown) 	end)

	

	

	Humanoid.StateChanged:connect(function(old, new)
		stateUpdated(new)
	end)

	

	function onUpdate(stepDeltaSeconds, tickSpeedSeconds)
		local stepScale = stepDeltaSeconds / tickSpeedSeconds
		do
			local sound = Sounds[SFX.FreeFalling]
			if activeState == Enum.HumanoidStateType.Freefall then
				if Head.Velocity.Y < 0 and Util.VerticalSpeed(Head) > 75 then
					Util.Resume(sound)

					
					local ANIMATION_LENGTH_SECONDS = 1.1

					local normalizedIncrement = tickSpeedSeconds / ANIMATION_LENGTH_SECONDS									
					sound.Volume = Util.Clamp(sound.Volume + normalizedIncrement * stepScale, 0, 1)
				else
					sound.Volume = 0
				end			
			else
				Util.Pause(sound)
			end
		end

		do
			local sound = Sounds[SFX.Running]
			if activeState == Enum.HumanoidStateType.Running then
				if Util.HorizontalSpeed(Head) < 0.5 then
					Util.Pause(sound)
				end
			end
		end		
	end

	
	local lastTick = tick()
	local TICK_SPEED_SECONDS = 0.25
	while true do
		onUpdate(tick() - lastTick,TICK_SPEED_SECONDS)
		lastTick = tick()
		wait(TICK_SPEED_SECONDS)
	end

end
	end
end

qx_S["a8"] = function()
	return function()
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local cam = workspace.CurrentCamera
cam.CameraType = "Custom"
cam.CameraSubject = Humanoid
	
	local Char = Player.Character
	local Event = Char:WaitForChild("UserInput_Event")
	
	local UIS = game:GetService("UserInputService")
	
	local input = function(io,a)
	    if a then return end
		local io = {KeyCode=io.KeyCode,UserInputType=io.UserInputType,UserInputState=io.UserInputState}
		qx_RF(Event, io)
	end
	UIS.InputBegan:Connect(input)
	UIS.InputEnded:Connect(input)
	local Changed = false
	local Mouse = Player:GetMouse()
	local h,t = Mouse.Hit,Mouse.Target
	while wait(1/30) do
		if h~=Mouse.Hit or t~=Mouse.Target then
			qx_RF(Event, {isMouse=true,Target=Mouse.Target,Hit=Mouse.Hit})
            h,t=Mouse.Hit,Mouse.Target
		end
	end
	end
end

qx_S["a9"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
		if v.BrickColor == "Really red" and v.Material == "ForceField" then v.Transparency = .85
			
		end
	end
end

weld()
script:Remove()
	end
end

qx_S["a10"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
		if v.BrickColor == "Really red" and v.Material == "ForceField" then v.Transparency = .85
			
		end
	end
end

weld()
script:Remove()
	end
end

qx_S["a11"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
		if v.BrickColor == "Really red" and v.Material == "ForceField" then v.Transparency = .85
			
		end
	end
end

weld()
script:Remove()
	end
end

qx_S["a12"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
		if v.BrickColor == "Really red" and v.Material == "ForceField" then v.Transparency = .85
			
		end
	end
end

weld()
script:Remove()
	end
end

qx_S["a13"] = function()
	return function()
repeat wait() until script.Parent:FindFirstChildOfClass("Humanoid")
Character=script.Parent
hum = Character.Humanoid
LeftArm=Character["Left Arm"]
LeftLeg=Character["Left Leg"]
RightArm=Character["Right Arm"]
RightLeg=Character["Right Leg"]
Root=Character["HumanoidRootPart"]
Head=Character["Head"]
Torso=Character["Torso"]
Neck=Torso["Neck"]
walking = false
jumping = false
settime = 0
change = 0
sine = 0
debounce = false
attacking = false
MseGuide = true
RunSrv = game:GetService("RunService")
RenderStepped = game:GetService("RunService").RenderStepped
removeuseless = game:GetService("Debris")
smoothen = game:GetService("TweenService")
cam = workspace.CurrentCamera
local hammr3 = script.hammrmodel
hammr3.hammr.Anchored = false
local hammr2 = hammr3:Clone() hammr2.Parent = Torso
local hammr = hammr2.hammr
ws = 17
combo1 = true
combo2 = false
combo3 = false
combo4 = false
local slashable = {161006212,161006195}
local introable = {4603694566,4603695046,4603695248,4603695464,4603695687,4603695909}
hum.MaxHealth = 375
hum.Health = 375
local hitbx = hammr.hammr.hitbox
local fkhead = script.head:Clone() fkhead.Parent = Torso fkhead.Headz.Anchored = false
local shirt = Instance.new("Shirt", Character)
shirt.Name = "Shirt"
local pants = Instance.new("Pants", Character)
pants.Name = "Pants"
shirt.ShirtTemplate = "rbxassetid://717904969"
pants.PantsTemplate = "rbxassetid://1618484003"

screenGui = Instance.new("ScreenGui")
screenGui.Parent = script.Parent

local HEADLERP = Instance.new("ManualWeld")
HEADLERP.Parent = Head
HEADLERP.Part0 = Head
HEADLERP.Part1 = Head
HEADLERP.C0 = CFrame.new(0, -1.5, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local TORSOLERP = Instance.new("ManualWeld")
TORSOLERP.Parent = Root
TORSOLERP.Part0 = Torso
TORSOLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local ROOTLERP = Instance.new("ManualWeld")
ROOTLERP.Parent = Root
ROOTLERP.Part0 = Root
ROOTLERP.Part1 = Torso
ROOTLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local RIGHTARMLERP = Instance.new("ManualWeld")
RIGHTARMLERP.Parent = RightArm
RIGHTARMLERP.Part0 = RightArm
RIGHTARMLERP.Part1 = Torso
RIGHTARMLERP.C0 = CFrame.new(-1.5, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local LEFTARMLERP = Instance.new("ManualWeld")
LEFTARMLERP.Parent = LeftArm
LEFTARMLERP.Part0 = LeftArm
LEFTARMLERP.Part1 = Torso
LEFTARMLERP.C0 = CFrame.new(1.5, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local RIGHTLEGLERP = Instance.new("ManualWeld")
RIGHTLEGLERP.Parent = RightLeg
RIGHTLEGLERP.Part0 = RightLeg
RIGHTLEGLERP.Part1 = Torso
RIGHTLEGLERP.C0 = CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local LEFTLEGLERP = Instance.new("ManualWeld")
LEFTLEGLERP.Parent = LeftLeg
LEFTLEGLERP.Part0 = LeftLeg
LEFTLEGLERP.Part1 = Torso
LEFTLEGLERP.C0 = CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local HAMMRLERP = Instance.new("ManualWeld")
HAMMRLERP.Parent = hammr
HAMMRLERP.Part0 = hammr
HAMMRLERP.Part1 = RightArm
HAMMRLERP.C0 = CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local function weldBetween(a, b)
    local weld = Instance.new("ManualWeld", a)
    weld.Part0 = a
    weld.Part1 = b
    weld.C0 = a.CFrame:inverse() * b.CFrame
    return weld
end
local fkweld = weldBetween(fkhead.Headz,Head)

slash = function()
	local random = slashable[math.random(1,#slashable)]
	local so = Instance.new("Sound",hammr)
	so.Volume = 4
	so.Pitch = math.random(6,7)/10
	so.Looped = false
	so.SoundId = "rbxassetid://"..random
	so:Play()
end

function MAKETRAIL(PARENT,POSITION1,POSITION2,LIFETIME,COLOR)
A = Instance.new("Attachment", PARENT)
A.Position = POSITION1
A.Name = "A"
B = Instance.new("Attachment", PARENT)
B.Position = POSITION2
B.Name = "B"
x = Instance.new("Trail", PARENT)
x.Attachment0 = A
x.Attachment1 = B
x.Enabled = true
x.Lifetime = LIFETIME
x.TextureMode = "Static"
x.LightInfluence = 0
x.Color = COLOR
x.Transparency = NumberSequence.new(0, 1)
end

function ray(pos, di, ran, ignore)
	return workspace:FindPartOnRay(Ray.new(pos, di.unit * ran), ignore)
end

function ray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return ray(StartPos, di, Distance, Ignore)
end

function colortween(a,speed,color1)
local z = {
Color = color1
}
local tween = smoothen:Create(a,TweenInfo.new(speed,Enum.EasingStyle.Linear),z)
tween:Play()
end

function takeDamage(victim,damage)
if victim.MaxHealth < math.huge and victim ~= hum then
victim.Health = victim.Health - damage
if victim.Health < 1 then
end
else
victim.Parent:BreakJoints()
end
end

function enabletrail()
	hammr.hammr.Trail.Enabled = true
	hammr.hammr.Trail2.Enabled = true
	hammr.hammr.Trail3.Enabled = true
	hammr.hammr.Trail4.Enabled = true
end
function disabletrail()
	hammr.hammr.Trail.Enabled = false
	hammr.hammr.Trail2.Enabled = false
	hammr.hammr.Trail3.Enabled = false
	hammr.hammr.Trail4.Enabled = false
end
disabletrail()
local Fo = Instance.new("Sound",Torso)
Fo.SoundId = "rbxassetid://2329042320"
Fo.Volume = 3
Fo.Looped = true
Fo:Play()
function velo(a,name,pos,speed)
local bov = Instance.new("BodyVelocity",a)
bov.Name = name
bov.maxForce = Vector3.new(99999,99999,99999)
a.CFrame = CFrame.new(a.Position,pos)
bov.velocity = a.CFrame.lookVector*speed
end
function bolt(parent,from,too,endtarget,color,size,mat,offset)
local function iray(pos, di, ran, ignore)
local ing={endtarget}
	return workspace:FindPartOnRayWithWhitelist(Ray.new(pos, di.unit * ran),ing)
end
local function iray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return iray(StartPos, di, Distance, Ignore)
end
lastposition = from
local step = 16
local distance = (from-too).magnitude
for i = 1,distance, step do
local from = lastposition
local too = from + -(from-too).unit*step+ Vector3.new(math.random(-offset,offset),math.random(-offset,offset),math.random(-offset,offset))
local bolt = Instance.new("Part",parent)
bolt.Size = Vector3.new(size,size,(from-too).magnitude)
bolt.Anchored = true
bolt.CanCollide = false
bolt.Name = "supeffect"
bolt.BrickColor = color
bolt.Material = mat
bolt.CFrame = CFrame.new(from:lerp(too,.5),too)
lastposition = too
coroutine.wrap(function()
for i = 1, 5 do
bolt.Transparency = bolt.Transparency + .2
wait()
end
bolt:Destroy()
end)()
end
local lastbolt = Instance.new("Part",parent)
lastbolt.Size = Vector3.new(1,1,(from-too).magnitude)
lastbolt.Anchored = true
lastbolt.CanCollide = false
lastbolt.BrickColor = color
lastbolt.Name = "supeffect"
lastbolt.Material = mat
lastbolt.CFrame = CFrame.new(lastposition,too)
lastbolt.Size = Vector3.new(size,size,size)
local start = lastposition
local hit,endp = iray2(lastposition,too,650,lastbolt)
local dis = (start - endp).magnitude
lastbolt.CFrame = CFrame.new(lastposition,too) * CFrame.new(0,0,-dis/2)
if dis < 20 then
lastbolt.Size = Vector3.new(size,size,dis)
else
lastbolt.Size = Vector3.new(size,size,20)
end
coroutine.wrap(function()
for i = 1, 5 do
lastbolt.Transparency = lastbolt.Transparency + .2
wait()
end
lastbolt:Destroy()
end)()
end
function littlebolt(parent,from,too,endtarget,color,size,mat,offset)
local function iray(pos, di, ran, ignore)
local ing={endtarget}
	return workspace:FindPartOnRayWithWhitelist(Ray.new(pos, di.unit * ran),ing)
end
local function iray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return iray(StartPos, di, Distance, Ignore)
end
lastposition = from
local step = 1
local distance = (from-too).magnitude
for i = 1,distance, step do
local from = lastposition
local too = from + -(from-too).unit*step+ Vector3.new(math.random(-offset,offset),math.random(-offset,offset),math.random(-offset,offset))
local bolt = Instance.new("Part",parent)
bolt.Size = Vector3.new(size,size,(from-too).magnitude)
bolt.Anchored = true
bolt.CanCollide = false
bolt.Name = "supeffect"
bolt.BrickColor = color
bolt.Material = mat
bolt.CFrame = CFrame.new(from:lerp(too,.5),too)
lastposition = too
coroutine.wrap(function()
for i = 1, 5 do
bolt.Transparency = bolt.Transparency + .2
wait()
end
bolt:Destroy()
end)()
end
local lastbolt = Instance.new("Part",parent)
lastbolt.Size = Vector3.new(1,1,(from-too).magnitude)
lastbolt.Anchored = true
lastbolt.CanCollide = false
lastbolt.BrickColor = color
lastbolt.Name = "supeffect"
lastbolt.Material = mat
lastbolt.CFrame = CFrame.new(lastposition,too)
lastbolt.Size = Vector3.new(size,size,size)
local start = lastposition
local hit,endp = iray2(lastposition,too,650,lastbolt)
local dis = (start - endp).magnitude
lastbolt.CFrame = CFrame.new(lastposition,too) * CFrame.new(0,0,-dis/2)
if dis < 20 then
lastbolt.Size = Vector3.new(size,size,dis)
else
lastbolt.Size = Vector3.new(size,size,20)
end
coroutine.wrap(function()
for i = 1, 5 do
lastbolt.Transparency = lastbolt.Transparency + .2
wait()
end
lastbolt:Destroy()
end)()
end
function ballshockwave(position,transparency,brickcolor,mate,transparencyincrease,size)
local borb = Instance.new("Part",Torso)
borb.Anchored = true
borb.CanCollide = false
borb.Shape = "Ball"
borb.Name = "supeffect"
borb.Transparency = transparency
borb.Size = Vector3.new(1,1,1)
borb.Material = mate
borb.BrickColor = brickcolor
borb.CFrame = position
coroutine.wrap(function()
while borb.Transparency < 1 do
borb.Size = borb.Size + size
borb.Transparency = borb.Transparency + transparencyincrease
swait()
end
borb:Destroy()
end)()
end

pcall(function()

LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0,0) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)), 0.2)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.5,0,0) * CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)), 0.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), 0.2)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5, 2, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0)), 0.2)

end)

function damagealll(Radius,Position)		
	local Returning = {}		
	for _,v in pairs(workspace:GetChildren()) do		
		if v~=Character and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChild('Torso') or v:FindFirstChild('UpperTorso') then
if v:FindFirstChild("Torso") then		
			local Mag = (v.Torso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
elseif v:FindFirstChild("UpperTorso") then	
			local Mag = (v.UpperTorso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
end	
		end		
	end		
	return Returning		
end

function swait(num)
	if num == 0 or num == nil then
		game:service("RunService").Stepped:wait(0)
	else
		for i = 0, num do
			game:service("RunService").Stepped:wait(0)
		end
	end
end

function SOUND(PARENT,ID,VOL,LOOP,PITCH,REMOVE)
local so = Instance.new("Sound")
so.Parent = PARENT
so.SoundId = "rbxassetid://"..ID
so.Volume = VOL
so.Looped = LOOP
so.Pitch = PITCH
so:Play()
removeuseless:AddItem(so,REMOVE)
end

function meshify(parent,scale,mid,tid)
local mesh = Instance.new("SpecialMesh",parent)
mesh.Name = "mesh"
mesh.Scale = scale
mesh.MeshId = "rbxassetid://"..mid
mesh.TextureId = "rbxassetid://"..tid
end
function blocktrail(position,size,trans,mat,color)
local trailblock = Instance.new("Part",Torso)
trailblock.Anchored = true
trailblock.CanCollide = false
trailblock.Transparency = trans
trailblock.Material = mat
trailblock.BrickColor = color
trailblock.CFrame = CFrame.new(position) * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
trailblock.Size = size
coroutine.wrap(function()
while trailblock.Transparency < 1 do
trailblock.Transparency = trailblock.Transparency + trans/10
trailblock.Size = trailblock.Size - trailblock.Size/20
swait()
end
trailblock:Destroy()
end)()
end

function blood(parent,intensity)
coroutine.wrap(function()
local particlemiter1 = Instance.new("ParticleEmitter", parent)
particlemiter1.Enabled = true
particlemiter1.Color = ColorSequence.new(BrickColor.new("Crimson").Color)
particlemiter1.Texture = "rbxassetid://1391189545"
particlemiter1.Lifetime = NumberRange.new(.6)
particlemiter1.Size = NumberSequence.new(3,3)
particlemiter1.Transparency = NumberSequence.new(0,1)
particlemiter1.Rate = intensity
particlemiter1.Rotation = NumberRange.new(0,360)
particlemiter1.Speed = NumberRange.new(6)
particlemiter1.SpreadAngle = Vector2.new(180,180)
wait(.2)
particlemiter1.Enabled = false
removeuseless:AddItem(particlemiter1,10)
end)()
coroutine.wrap(function()
for i = 1, intensity/20 do
local ray = Ray.new(parent.Position, Vector3.new(0,-25,0))
local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,parent.Parent,bloc,Character,blooddecal,blowd,Torso},false,true)
if part and part.Parent ~= parent.Parent and not part.Parent:FindFirstChildOfClass("Humanoid") then
local vbn = math.random(5,15)
coroutine.wrap(function()
local blooddecal = Instance.new("Part",bloodfolder)
blooddecal.Size =  Vector3.new(vbn,.1,vbn)
blooddecal.Transparency = 1
blooddecal.Anchored = true
blooddecal.Name = "blowd"
blooddecal.CanCollide = false
blooddecal.Position = hitPosition 
blooddecal.Rotation = Vector3.new(0,math.random(-180,180),0)
local blood = Instance.new("Decal",blooddecal)
blood.Face = "Top"
blood.Texture = "rbxassetid://1391189545"
blood.Transparency = math.random(.1,.4)
wait(60)
for i = 1, 100 do
blood.Transparency = blood.Transparency + .01
swait()
end
blooddecal:Destroy()
end)()
else
end
swait()
end
end)()
end
function spikeball(position,scale,brickcolor,transparencyincrease)
coroutine.wrap(function()
local spikeball = Instance.new("Part",Torso)
spikeball.Anchored = true
spikeball.CanCollide = false
spikeball.Size = Vector3.new(1,1,1)
spikeball.BrickColor = brickcolor
spikeball.CFrame = position
spikeball.Transparency = .85
local spikemesh = Instance.new("SpecialMesh",spikeball)
spikemesh.MeshId = "rbxassetid://9982590"
spikemesh.Scale = Vector3.new(1,1,1)
while spikeball.Transparency < 1 do
spikeball.CFrame = spikeball.CFrame * CFrame.Angles(math.rad(0+math.random(7,14)),math.rad(0+math.random(16,21)),math.rad(0+math.random(23,29)))
spikemesh.Scale = spikemesh.Scale + scale
spikeball.Transparency = spikeball.Transparency + transparencyincrease/10
swait()
end
spikeball:Destroy()
end)()
end
function shockwave(position,scale,transparency,brickcolor,speed,transparencyincrease)
coroutine.wrap(function()
local shockwave = Instance.new("Part", Torso)
shockwave.Size = Vector3.new(1,1,1)
shockwave.CanCollide = false
shockwave.Anchored = true
shockwave.Transparency = transparency
shockwave.BrickColor = brickcolor
shockwave.CFrame = position
local shockwavemesh = Instance.new("SpecialMesh", shockwave)
shockwavemesh.Scale = Vector3.new(.5,.125,.5)
shockwavemesh.MeshId = "rbxassetid://20329976"
local shockwave2 = Instance.new("Part", Torso)
shockwave2.Size = Vector3.new(1,1,1)
shockwave2.CanCollide = false
shockwave2.Anchored = true
shockwave2.Transparency = shockwave.Transparency
shockwave2.BrickColor = shockwave.BrickColor
shockwave2.CFrame = shockwave.CFrame
local shockwavemesh2 = Instance.new("SpecialMesh", shockwave2)
shockwavemesh2.Scale = Vector3.new(.5,.125,.5)
shockwavemesh2.MeshId = "rbxassetid://20329976"
while shockwave.Transparency < 1 do
shockwave.CFrame = shockwave.CFrame * CFrame.Angles(math.rad(0),math.rad(0+speed),0)
shockwave2.CFrame = shockwave2.CFrame * CFrame.Angles(math.rad(0),math.rad(0-speed),0)
shockwave.Transparency = shockwave.Transparency + transparencyincrease
shockwave2.Transparency = shockwave2.Transparency + transparencyincrease
shockwavemesh2.Scale = shockwavemesh2.Scale + scale
shockwavemesh.Scale = shockwavemesh.Scale + scale
swait()
end
shockwave:Destroy()
shockwave2:Destroy()
end)()
end

function blockyeffect(brickcolor,size,trans,posi,mater,spread)
local blocky = Instance.new("Part",Torso)
blocky.Anchored = true
blocky.CanCollide = false
blocky.BrickColor = brickcolor
blocky.Size = size
blocky.Transparency = trans
blocky.CFrame = posi * CFrame.Angles(math.rad(math.random(-180,180)),math.rad(math.random(-180,180)),math.rad(math.random(-180,180)))
blocky.Material = mater
local locbloc = Instance.new("Part",Torso)
locbloc.Anchored = true
locbloc.CanCollide = false
locbloc.Transparency = 1
locbloc.Size = Vector3.new(1,1,1)
locbloc.CFrame = blocky.CFrame * CFrame.new(math.random(-spread,spread),math.random(-spread,spread),math.random(-spread,spread))
coroutine.wrap(function()
local a = math.random(-180,180)
local b = math.random(-180,180)
local c = math.random(-180,180)
for i = 1, 20 do
blocky.CFrame = blocky.CFrame:lerp(CFrame.new(locbloc.Position) * CFrame.Angles(math.rad(a),math.rad(b),math.rad(c)),.2)
blocky.Transparency = blocky.Transparency + .05
swait()
end
blocky:Destroy()
locbloc:Destroy()
end)()
end

leftlocation = Instance.new("Part",LeftArm)
leftlocation.Size = Vector3.new(1,1,1)
leftlocation.Transparency = 1
leftlocation.CanCollide = false
leftlocationweld = weldBetween(leftlocation,LeftArm)
leftlocationweld.C0 = CFrame.new(0,1.2,0)
rightlocation = Instance.new("Part",RightArm)
rightlocation.Size = Vector3.new(1,1,1)
rightlocation.Transparency = 1
rightlocation.CanCollide = false
rightlocationweld = weldBetween(rightlocation,RightArm)
rightlocationweld.C0 = CFrame.new(0,1.2,0)


function ray(POSITION, DIRECTION, RANGE, IGNOREDECENDANTS)
	return workspace:FindPartOnRay(Ray.new(POSITION, DIRECTION.unit * RANGE), IGNOREDECENDANTS)
end

function ray2(StartPos, EndPos, Distance, Ignore)
local DIRECTION = CFrame.new(StartPos,EndPos).lookVector
return ray(StartPos, DIRECTION, Distance, Ignore)
end

function attack()
	if debounce then return end
	if combo1 then
		combo1 = false
		combo2 = true
		combo3 = false
		combo4 = false
	debounce = true
	attacking = true
	ws = 1
	for i = 1, 20 do
		HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(1,-1.9,-0.4)*CFrame.Angles(math.rad(22.4),math.rad(17.2),math.rad(-118.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.2)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-1,0.9,0.8)*CFrame.Angles(math.rad(-27.2),math.rad(33.9),math.rad(-179.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.2)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.1,1,1.5)*CFrame.Angles(math.rad(46.3),math.rad(1.9),math.rad(20.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.2)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.9,0.1,0.5)*CFrame.Angles(math.rad(-63.4),math.rad(-46.4),math.rad(31.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.2)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0.1,2.2,0.5)*CFrame.Angles(math.rad(26.2),math.rad(44.3),math.rad(-38))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.2)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,-.1,0)*CFrame.Angles(math.rad(30.8),math.rad(38.4),math.rad(-25.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.2)
		swait()
	end
		slash()
		enabletrail()
		local hitbox = Instance.new("Part",Torso)
		hitbox.Size = Vector3.new(1,1,1)
		hitbox.Anchored = true
		hitbox.Transparency = 1
		hitbox.CanCollide = false
		hitbox.CFrame = Root.CFrame * CFrame.new(0,-3,-5.5)
		SOUND(hitbox,1388740053,10,false,math.random(9,11)/10,10)
local Hit = damagealll(7,hitbox.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
takeDamage(slachtoffer,math.random(53,68))
local vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
vel.velocity = CFrame.new(hitbx.Position,torso.Position).lookVector*60
removeuseless:AddItem(vel,.01)
blood(torso,50)
SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
end
end
		spikeball(hitbox.CFrame,Vector3.new(1.5,1.5,1.5),BrickColor.new("White"),.05)
		spikeball(hitbox.CFrame,Vector3.new(1.5*2,1.5*2,1.5*2),BrickColor.new("White"),.05*2)
		ballshockwave(hitbox.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(2,2,2))
		shockwave(hitbox.CFrame,Vector3.new(1.5,1.5,1.5),.05,BrickColor.new("White"),math.random(16,19),05)
		shockwave(hitbox.CFrame,Vector3.new(3,1,3),.05,BrickColor.new("White"),math.random(16,19),05)
	for i = 1, 12 do
		HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0,-2.4,-0.5)*CFrame.Angles(math.rad(12.3),math.rad(-38.6),math.rad(163.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
		LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-1,-0.1,-0.3)*CFrame.Angles(math.rad(-96.1),math.rad(-33.4),math.rad(173.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
		LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5,0.9,1.4)*CFrame.Angles(math.rad(43.9),math.rad(-16.4),math.rad(2.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
		RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.9,0.1,0.5)*CFrame.Angles(math.rad(-63.4),math.rad(-46.4),math.rad(31.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
		RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2,-0.2)*CFrame.Angles(math.rad(-42.6),math.rad(39.7),math.rad(-3.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
		ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-29.1),math.rad(-21.7),math.rad(-39))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.4)
		swait()
	end
	disabletrail()
	ws = 17
	removeuseless:AddItem(hitbox,10)
	debounce = false
	attacking = false
	elseif combo2 then
		combo1 = false
		combo2 = false
		combo3 = true
		combo4 = false
		attacking = true
		debounce = true
		ws = 1
		for i = 1, 20 do
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-2.2),math.rad(-59.2),math.rad(19.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.5,-0.9,-0.3)*CFrame.Angles(math.rad(16.4),math.rad(12.3),math.rad(-169.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-0.7,1.8,-0.4)*CFrame.Angles(math.rad(-111.2),math.rad(61.9),math.rad(-154.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0,2,0.5)*CFrame.Angles(math.rad(16.9),math.rad(-66),math.rad(35))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.1,-0.5,0.6)*CFrame.Angles(math.rad(-63.4),math.rad(-46.4),math.rad(31.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2,0.5)*CFrame.Angles(math.rad(3.3),math.rad(39.7),math.rad(-3.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			swait()
		end
		slash()
		enabletrail()
				local hitbox = Instance.new("Part",Torso)
		hitbox.Size = Vector3.new(1,1,1)
		hitbox.Anchored = true
		hitbox.Transparency = 1
		hitbox.CanCollide = false
		hitbox.CFrame = Root.CFrame * CFrame.new(0,0,-5.7)
		local Hit = damagealll(5,hitbox.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
takeDamage(slachtoffer,math.random(47,59))
local vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
vel.velocity = CFrame.new(hitbx.Position,torso.Position).lookVector*70
removeuseless:AddItem(vel,.01)
blood(torso,50)
SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
end
end
		for i = 1, 20 do
			HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.4,-2.5,0)*CFrame.Angles(math.rad(5.7),math.rad(-1.1),math.rad(-171.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-0.7,0.8,-1.4)*CFrame.Angles(math.rad(-172.9),math.rad(61.9),math.rad(-154.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,1.8,0.2)*CFrame.Angles(math.rad(-0.5),math.rad(-23.8),math.rad(9.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.3,1.8,0.5)*CFrame.Angles(math.rad(-39.1),math.rad(75.8),math.rad(-41))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0.5,1.6,0.7)*CFrame.Angles(math.rad(99.9),math.rad(67.5),math.rad(-104.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,-.5,0)*CFrame.Angles(math.rad(45.1),math.rad(71),math.rad(-42.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			swait()
		end
		disabletrail()
		ws = 17
		removeuseless:AddItem(hitbox,10)
		debounce = false
		attacking = false
	elseif combo3 then
		combo1 = false
		combo2 = false
		combo3 = false
		combo4 = true
		attacking = true
		debounce = true
		ws = 1
		for i = 1, 20 do
			HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(1,-0.6,0)*CFrame.Angles(math.rad(-164.5),math.rad(17.8),math.rad(-56.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0.7,0.1,0.4)*CFrame.Angles(math.rad(-76.6),math.rad(74.8),math.rad(-13))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,2.1,0.5)*CFrame.Angles(math.rad(-1.3),math.rad(-57.7),math.rad(10.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1,1.3,-0.5)*CFrame.Angles(math.rad(-58.7),math.rad(59.6),math.rad(-55.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5,1.9,0.3)*CFrame.Angles(math.rad(3),math.rad(20),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(-55.7),math.rad(5.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			swait()
		end
				slash()
		enabletrail()
		local hitbox = Instance.new("Part",Torso)
		hitbox.Size = Vector3.new(1,1,1)
		hitbox.Anchored = true
		hitbox.Transparency = 1
		hitbox.CanCollide = false
		hitbox.CFrame = Root.CFrame * CFrame.new(0,0,-5.7)
local Hit = damagealll(5,hitbox.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
takeDamage(slachtoffer,math.random(47,59))
local vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
vel.velocity = CFrame.new(hitbx.Position,torso.Position).lookVector*70
removeuseless:AddItem(vel,.01)
blood(torso,50)
SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
end
end
		for i = 1, 20 do
			HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.2,-2.7,0.1)*CFrame.Angles(math.rad(158.4),math.rad(-23.2),math.rad(-9.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.5,0,0.3)*CFrame.Angles(math.rad(-79.9),math.rad(31.8),math.rad(-5.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.2,1.6,0.6)*CFrame.Angles(math.rad(14.6),math.rad(4.3),math.rad(16))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-0.9,-0.2,0.5)*CFrame.Angles(math.rad(-47.4),math.rad(-43),math.rad(32.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.2,2.1,0.5)*CFrame.Angles(math.rad(2.2),math.rad(62.1),math.rad(-12.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-4.3),math.rad(55.4),math.rad(-5.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			swait()
		end
		disabletrail()
		ws = 17
		removeuseless:AddItem(hitbox,10)
		debounce = false
		attacking = false
	elseif combo4 then
		combo1 = true
		combo2 = false
		combo3 = false
		combo4 = false
		attacking = true
		debounce = true
		ws = 1
		for i = 1, 20 do
			HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(-0.7,-2,0.7)*CFrame.Angles(math.rad(134.3),math.rad(-26.8),math.rad(47.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.6,1.1,0.5)*CFrame.Angles(math.rad(-132.9),math.rad(12.4),math.rad(11.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(-0.1,2,0.4)*CFrame.Angles(math.rad(52.2),math.rad(-78.3),math.rad(62.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0.8,0.1)*CFrame.Angles(math.rad(-116.6),math.rad(-24.1),math.rad(-5.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,1.2,0.8)*CFrame.Angles(math.rad(17.7),math.rad(31.2),math.rad(-1.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(10.2),math.rad(28.9),math.rad(4.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			swait()

		end
				slash()
		enabletrail()
				local hitbox = Instance.new("Part",Torso)
		hitbox.Size = Vector3.new(1,1,1)
		hitbox.Anchored = true
		hitbox.Transparency = 1
		hitbox.CanCollide = false
		hitbox.CFrame = Root.CFrame * CFrame.new(0,0,-5.7)
local Hit = damagealll(5,hitbox.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
takeDamage(slachtoffer,math.random(47,59))
local vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
vel.velocity = CFrame.new(hitbx.Position,torso.Position).lookVector*70
removeuseless:AddItem(vel,.01)
blood(torso,50)
SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
end
end
		for i = 1, 20 do
			HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(1,-2.3,0.2)*CFrame.Angles(math.rad(158.6),math.rad(7),math.rad(-42.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.2,-0.4,0.5)*CFrame.Angles(math.rad(-63),math.rad(57),math.rad(-23.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.7,2.1,0)*CFrame.Angles(math.rad(-31.5),math.rad(-32.6),math.rad(-9.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0.4,0.3)*CFrame.Angles(math.rad(-78),math.rad(-25.2),math.rad(5.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,2.1,0.1)*CFrame.Angles(math.rad(-18.1),math.rad(30),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-25.9),math.rad(-36.9),math.rad(-16.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
			swait()
		end
		disabletrail()
		ws = 17
		removeuseless:AddItem(hitbox,10)
		debounce = false
		attacking = false
	end
end
local spdebounce = false
function specialattack()
		if spdebounce or debounce then return end
		spdebounce = true
		qx_RA(game:GetService("ReplicatedStorage").spabilityremote)
		coroutine.wrap(function()
			debounce = true
			attacking = true
			local spinny = 0
			local spinny2 = 0
			ballshockwave(Root.CFrame,.05,BrickColor.new("White"),"Neon",.05,Vector3.new(2,2,2))
			spikeball(Root.CFrame,Vector3.new(2,2,2),BrickColor.new("White"),.05)
			SOUND(Torso,160740121,4,false,1,15)
			SOUND(Torso,3206852726,4,false,1,15)
			coroutine.wrap(function()
				for i = 1, 200 do
					spinny = spinny + .1
					swait()
				end
			end)()
			for i = 1, 400 do
				spinny2 = spinny2 + spinny
				blocktrail(hitbx.Position,Vector3.new(2,2,2),.05,"Neon",BrickColor.new("Really red"))
				HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.8,-2.9,0)*CFrame.Angles(math.rad(179.8),math.rad(0),math.rad(-40.3))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
				LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.1,0.1,0.4)*CFrame.Angles(math.rad(-61.6),math.rad(37.5),math.rad(-18.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
				LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.4,1.8,0.3)*CFrame.Angles(math.rad(15.3),math.rad(-3.7),math.rad(2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
				RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,0,0.5)*CFrame.Angles(math.rad(-62.8),math.rad(-37),math.rad(17.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
				RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,1.1,1)*CFrame.Angles(math.rad(39.4),math.rad(3.8),math.rad(-12.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
				ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-21.4),math.rad(0),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
				ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(spinny2),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
local Hit = damagealll(5,hitbx.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
takeDamage(slachtoffer,math.random(1+spinny,2+spinny*1.1))
local vel = Instance.new("BodyVelocity",v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")) 
vel.maxForce = Vector3.new(9999999999999,9999999999999,9999999999999)
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
vel.velocity = CFrame.new(hitbx.Position,torso.Position).lookVector*60
removeuseless:AddItem(vel,.01)
blood(torso,20)
SOUND(torso,2801263,5,false,math.random(7,8)/10,6)
end
end
				swait()
			end
			ROOTLERP.C1 = CFrame.new(0,0,0)*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0))
			debounce = false
			attacking = false
		end)()
		wait(20)
		print"spattack ready"
		spdebounce = false
	end

checks1 = coroutine.wrap(function() 
while true do
	hum.WalkSpeed = ws
hf = ray(Root.Position,(CFrame.new(Root.Position,Root.Position+Vector3.new(0,-1,0))).lookVector,4 * 1,Character)
if Root.Velocity.y > 1 and hf == nil then
position = "Jump"
elseif Root.Velocity.y < -1 and hf == nil then
position = "Falling"
elseif Root.Velocity.Magnitude < 5 and hf ~= nil then
position = "Idle"
elseif Root.Velocity.Magnitude > 5 and hf ~= nil then
position = "Walking"
else
end
wait()
end
end)
checks1()

OrgnC0 = Neck.C0
local movelimbs = coroutine.wrap(function()
while wait() do
Character.Parent = workspace
Head.BrickColor = BrickColor.new("Really black")
Torso.BrickColor = Head.BrickColor
LeftArm.BrickColor = Head.BrickColor
RightArm.BrickColor = Head.BrickColor
LeftLeg.BrickColor = Head.BrickColor
RightLeg.BrickColor = Head.BrickColor
TrsoLV = Torso.CFrame.lookVector
Dist = nil
Diff = nil
if not MseGuide then
print("Failed to recognize")
else
end
end
end)
movelimbs()

local anims = coroutine.wrap(function()
while true do
settime = 0.05
sine = sine + change
if position == "Jump" and not attacking then
change = 1
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.8,-1.6,-0.6)*CFrame.Angles(math.rad(47.2),math.rad(13.3),math.rad(-128.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-1.4,0.8,-0.4)*CFrame.Angles(math.rad(-82),math.rad(-13.2),math.rad(179.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,0,0.4)*CFrame.Angles(math.rad(-49.9),math.rad(-27.7),math.rad(21))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(-20), math.rad(0), math.rad(0)), 0.09)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5, 2, 0) * CFrame.Angles(math.rad(10), math.rad(0), math.rad(0)), 0.2)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.5, 1.0, .9) * CFrame.Angles(math.rad(20), math.rad(0), math.rad(0)), 0.2)
elseif position == "Falling" and not attacking then
change = 1
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(20), math.rad(0), math.rad(0)), 0.09)
HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.8,-1.6,-0.6)*CFrame.Angles(math.rad(47.2),math.rad(13.3),math.rad(-128.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-1.4,0.8,-0.4)*CFrame.Angles(math.rad(-82),math.rad(-13.2),math.rad(179.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,0,0.4)*CFrame.Angles(math.rad(-49.9),math.rad(-27.7),math.rad(21))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.54, 1.4 + .1 * math.sin(sine/12), .4) * CFrame.Angles(math.rad(9 + 2 * math.cos(sine/12)), math.rad(0), math.rad(0)), 0.25)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.54, 2 + .02 * math.sin(sine/12), 0.2 + .1 * math.sin(sine/12)) * CFrame.Angles(math.rad(25 + 5 * math.sin(sine/12)), math.rad(20), math.rad(0)), 0.25)
elseif position == "Walking" and not attacking then
change = 1.4
walking = true
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.8,-1.6,-0.6)*CFrame.Angles(math.rad(47.2),math.rad(13.3),math.rad(-128.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-1.4,0.8,-0.4)*CFrame.Angles(math.rad(-82),math.rad(-13.2),math.rad(179.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,0,0.4)*CFrame.Angles(math.rad(-49.9),math.rad(-27.7),math.rad(21))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTLEGLERP.C1 = LEFTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.1)
RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),0,0),.1)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2 + 0.29*math.sin(sine/4), 0) * CFrame.Angles(math.rad(-15), math.rad(12 * -math.cos(sine/8)), math.rad(0) + Root.RotVelocity.Y / 30, math.cos(25 * math.cos(sine/8))), 0.1)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.52, 1.62 - .54 * math.cos(sine/8)/2.8,.2 - .5 * math.sin(sine/8)) * CFrame.Angles(math.rad(20 - 60* math.sin(sine/8)), math.rad(9-16)*math.cos(sine/8), math.rad(0), math.cos(65 * math.cos(sine/8))), 0.3)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.52, 1.62 + .54 * math.cos(sine/8)/2.8,.2 + .5 * math.sin(sine/8)) * CFrame.Angles(math.rad(20 + 60* math.sin(sine/8)), math.rad(-9+16)*math.cos(sine/8), math.rad(0), math.cos(65 * math.cos(sine/8))), 0.3)
elseif position == "Idle" and not attacking then
change = .5
ROOTLERP.C1 = ROOTLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.2)
HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(0.8,-1.6,-0.6)*CFrame.Angles(math.rad(47.2),math.rad(13.3),math.rad(-128.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(-1.4,0.8,-0.4)*CFrame.Angles(math.rad(-82),math.rad(-13.2),math.rad(179.6))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,0,0.4)*CFrame.Angles(math.rad(-49.9),math.rad(-27.7),math.rad(21))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0, -.2 + -.1 * math.sin(sine/12), 0) * CFrame.Angles(math.rad(0), math.rad(30), math.rad(0)),.2)
RIGHTLEGLERP.C1 = RIGHTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(math.rad(0),0,0),.2)
RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-.4, 2 - .1 * math.sin(sine/12), .2) * CFrame.Angles(math.rad(-5), math.rad(30 + 0 * math.sin(sine/12)), math.rad(-5 - .1 * math.sin(sine/12))), 0.2)
LEFTLEGLERP.C1 = LEFTLEGLERP.C1:lerp(CFrame.new(0,0,0) * CFrame.Angles(0,0,0),.1)
LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.55, 2.0 - .1 * math.sin(sine/12), .2) * CFrame.Angles(math.rad(5), math.rad(-20 + 0 * math.sin(sine/12)), math.rad(5 + .1 * math.sin(sine/12))), 0.2)
end
swait()
end
end)
anims()
ws = 0
attacking = true
debounce = true
ROOTLERP.C0 = CFrame.new(0,150,0)
for i = 1, 20 do
	HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(-0.1,-2.1,-1.4)*CFrame.Angles(math.rad(-146.8),math.rad(-41.3),math.rad(128.2))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.4,1,0)*CFrame.Angles(math.rad(-125.5),math.rad(11),math.rad(7.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.1,1.4,1.1)*CFrame.Angles(math.rad(34.4),math.rad(-6.2),math.rad(19.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.4,0.9,0)*CFrame.Angles(math.rad(-124.9),math.rad(-13),math.rad(-8.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.6,1.2,1.1)*CFrame.Angles(math.rad(34.4),math.rad(-7.2),math.rad(-10.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(25.9),math.rad(0),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	swait()
end
SOUND(Torso,3302387879,8,false,math.random(9,11)/10,15)
ballshockwave(Torso.CFrame,.05,BrickColor.White(),"Neon",.05,Vector3.new(3,3,3))
ballshockwave(Torso.CFrame,.025,BrickColor.White(),"Neon",.025,Vector3.new(3,3,3)/2)
spikeball(Torso.CFrame,Vector3.new(3,3,3),BrickColor.White(),.05)
shockwave(Root.CFrame,Vector3.new(5,1.25,5),.05,BrickColor.White(),math.random(3,6),.05)
shockwave(Root.CFrame,Vector3.new(2.5,.5,2.5),.025,BrickColor.White(),math.random(12,16),.025)
shockwave(Root.CFrame,Vector3.new(1.5,1.5,1.5),.025,BrickColor.White(),math.random(12,16),.025)
local randomable = introable[math.random(1,#introable)]
SOUND(Head,randomable,10,false,1,15)
for i = 1, 40 do
	HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(-1.1,-0.9,-1)*CFrame.Angles(math.rad(-77),math.rad(-45.9),math.rad(-146.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.1,-0.3,0.1)*CFrame.Angles(math.rad(-85.5),math.rad(41.8),math.rad(11.4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.8,0.9,-0.1)*CFrame.Angles(math.rad(-67.7),math.rad(14.4),math.rad(-5.8))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,1.1,0)*CFrame.Angles(math.rad(-80.2),math.rad(23.8),math.rad(-4))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.5,1.6,1.1)*CFrame.Angles(math.rad(34.8),math.rad(18.1),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,-1.2,0)*CFrame.Angles(math.rad(-52.9),math.rad(22.3),math.rad(0))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	swait()
end
for i = 1, 16 do
	HAMMRLERP.C0 = HAMMRLERP.C0:lerp(CFrame.new(-0.7,-1.5,-0.2)*CFrame.Angles(math.rad(148.7),math.rad(5.4),math.rad(141.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(1.6,0.5,0.1)*CFrame.Angles(math.rad(-47.6),math.rad(3.5),math.rad(14.1))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0.7,1.9,0)*CFrame.Angles(math.rad(-18.7),math.rad(13.4),math.rad(-2.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(-1.2,1,-0.6)*CFrame.Angles(math.rad(151.6),math.rad(14.9),math.rad(15.9))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(-0.4,1.9,0.1)*CFrame.Angles(math.rad(-19.2),math.rad(28),math.rad(-4.5))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0,0,0)*CFrame.Angles(math.rad(-22.5),math.rad(21.5),math.rad(-1.7))*CFrame.Angles(math.rad(0),math.rad(0),math.rad(0)),.25)
	swait()
end
ws = 20
debounce = false
attacking = false
coroutine.wrap(function()
	while wait() do 
		local Hit = damagealll(8,Root.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
attack()
end
end
end
	end)()
	end
end

qx_S["a14"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
	end
end

weld()
script:Remove()
	end
end

qx_S["a15"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
	end
end

weld()
script:Remove()
	end
end

qx_S["a16"] = function()
	return function()
local larm = script.Parent:FindFirstChild("HumanoidRootPart")
local rarm = script.Parent:FindFirstChild("HumanoidRootPart")

function findNearestTorso(pos)
	local list = game.Workspace:children()
	local torso = nil
	local dist = math.huge
	local temp = nil
	local human = nil
	local temp2 = nil
	for x = 1, #list do
		temp2 = list[x]
		if (temp2.className == "Model") and (temp2 ~= script.Parent) then
			temp = temp2:findFirstChild("HumanoidRootPart")
			human = temp2:findFirstChildOfClass("Humanoid")
			if (temp ~= nil) and (human ~= nil) and (human.Health > 0) then
				if (temp.Position - pos).magnitude < dist then
					torso = temp
					dist = (temp.Position - pos).magnitude
				end
			end
		end
	end
	return torso
end




while true do
	wait(1)
	local target = findNearestTorso(script.Parent.HumanoidRootPart.Position)
	if target ~= nil and target.Parent:FindFirstChildOfClass("Humanoid").Name ~= "noneofurbusiness" then
		script.Parent:FindFirstChildOfClass"Humanoid":MoveTo(target.Position, target)
	end

end
	end
end

qx_S["a17"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
	for _,v in pairs(parts) do
		if v.BrickColor == "Really red" and v.Material == "ForceField" then v.Transparency = .85
			
		end
	end
end

weld()
script:Remove()
	end
end

qx_S["a18"] = function()
	return function()
local skull = script.skully
local rdx = {"Really black","Really red"}
local Torso = skull
local Character = Torso
local mainp = skull.mainp
local spkball = script.Effects.spikeball
local shckwav = script.Effects.shockwave
local wosh = script.Effects.woosh
local looking = false
RunSrv = game:GetService("RunService")
RenderStepped = game:GetService("RunService").RenderStepped
removeuseless = game:GetService("Debris")
smoothen = game:GetService("TweenService")
cam = workspace.CurrentCamera
lig = game:GetService("Lighting")
local die = script.die
local bem = script.bem:Clone()
script.bem:Destroy()


local function weldBetween(a, b)
    local weld = Instance.new("ManualWeld", a)
    weld.Part0 = a
    weld.Part1 = b
    weld.C0 = a.CFrame:inverse() * b.CFrame
    return weld
end

function bolt(parent,from,too,endtarget,color,size,mat,offset)
local function iray(pos, di, ran, ignore)
local ing={endtarget}
	return workspace:FindPartOnRayWithWhitelist(Ray.new(pos, di.unit * ran),ing)
end
local function iray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return iray(StartPos, di, Distance, Ignore)
end
lastposition = from
local step = 16
local distance = (from-too).magnitude
for i = 1,distance, step do
local from = lastposition
local too = from + -(from-too).unit*step+ Vector3.new(math.random(-offset,offset),math.random(-offset,offset),math.random(-offset,offset))
local bolt = Instance.new("Part",parent)
bolt.Size = Vector3.new(size,size,(from-too).magnitude)
bolt.Anchored = true
bolt.CanCollide = false
bolt.Name = "supeffect"
bolt.BrickColor = color
bolt.Material = mat
bolt.CFrame = CFrame.new(from:lerp(too,.5),too)
lastposition = too
coroutine.wrap(function()
for i = 1, 5 do
bolt.Transparency = bolt.Transparency + .2
wait()
end
bolt:Destroy()
end)()
end
local lastbolt = Instance.new("Part",parent)
lastbolt.Size = Vector3.new(1,1,(from-too).magnitude)
lastbolt.Anchored = true
lastbolt.CanCollide = false
lastbolt.BrickColor = color
lastbolt.Name = "supeffect"
lastbolt.Material = mat
lastbolt.CFrame = CFrame.new(lastposition,too)
lastbolt.Size = Vector3.new(size,size,size)
local start = lastposition
local hit,endp = iray2(lastposition,too,650,lastbolt)
local dis = (start - endp).magnitude
lastbolt.CFrame = CFrame.new(lastposition,too) * CFrame.new(0,0,-dis/2)
if dis < 20 then
lastbolt.Size = Vector3.new(size,size,dis)
else
lastbolt.Size = Vector3.new(size,size,20)
end
coroutine.wrap(function()
for i = 1, 5 do
lastbolt.Transparency = lastbolt.Transparency + .2
wait()
end
lastbolt:Destroy()
end)()
end
function littlebolt(parent,from,too,endtarget,color,size,mat,offset)
local function iray(pos, di, ran, ignore)
local ing={endtarget}
	return workspace:FindPartOnRayWithWhitelist(Ray.new(pos, di.unit * ran),ing)
end
local function iray2(StartPos, EndPos, Distance, Ignore)
local di = CFrame.new(StartPos,EndPos).lookVector
return iray(StartPos, di, Distance, Ignore)
end
lastposition = from
local step = 1
local distance = (from-too).magnitude
for i = 1,distance, step do
local from = lastposition
local too = from + -(from-too).unit*step+ Vector3.new(math.random(-offset,offset),math.random(-offset,offset),math.random(-offset,offset))
local bolt = Instance.new("Part",parent)
bolt.Size = Vector3.new(size,size,(from-too).magnitude)
bolt.Anchored = true
bolt.CanCollide = false
bolt.Name = "supeffect"
bolt.BrickColor = color
bolt.Material = mat
bolt.CFrame = CFrame.new(from:lerp(too,.5),too)
lastposition = too
coroutine.wrap(function()
for i = 1, 5 do
bolt.Transparency = bolt.Transparency + .2
wait()
end
bolt:Destroy()
end)()
end
local lastbolt = Instance.new("Part",parent)
lastbolt.Size = Vector3.new(1,1,(from-too).magnitude)
lastbolt.Anchored = true
lastbolt.CanCollide = false
lastbolt.BrickColor = color
lastbolt.Name = "supeffect"
lastbolt.Material = mat
lastbolt.CFrame = CFrame.new(lastposition,too)
lastbolt.Size = Vector3.new(size,size,size)
local start = lastposition
local hit,endp = iray2(lastposition,too,650,lastbolt)
local dis = (start - endp).magnitude
lastbolt.CFrame = CFrame.new(lastposition,too) * CFrame.new(0,0,-dis/2)
if dis < 20 then
lastbolt.Size = Vector3.new(size,size,dis)
else
lastbolt.Size = Vector3.new(size,size,20)
end
coroutine.wrap(function()
for i = 1, 5 do
lastbolt.Transparency = lastbolt.Transparency + .2
wait()
end
lastbolt:Destroy()
end)()
end

function damagealll(Radius,Position)		
	local Returning = {}		
	for _,v in pairs(workspace:GetChildren()) do		
		if v~=Character and v:FindFirstChildOfClass('Humanoid') and v:FindFirstChild('Torso') or v:FindFirstChild('UpperTorso') then
if v:FindFirstChild("Torso") then		
			local Mag = (v.Torso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
elseif v:FindFirstChild("UpperTorso") then	
			local Mag = (v.UpperTorso.Position - Position).magnitude		
			if Mag < Radius then		
				table.insert(Returning,v)		
			end
end	
		end		
	end		
	return Returning		
end

function swait(num)
	if num == 0 or num == nil then
		game:service("RunService").Stepped:wait(0)
	else
		for i = 0, num do
			game:service("RunService").Stepped:wait(0)
		end
	end
end

function SOUND(PARENT,ID,VOL,LOOP,PITCH,REMOVE)
local so = Instance.new("Sound")
so.Parent = PARENT
so.SoundId = "rbxassetid://"..ID
so.Volume = VOL
so.Looped = LOOP
so.Pitch = PITCH
so:Play()
removeuseless:AddItem(so,REMOVE)
end

function shockwave(position,scale,transparency,brickcolor,speed,transparencyincrease,mat)
coroutine.wrap(function()
local shockwave = shckwav:Clone() shockwave.Parent = Torso
shockwave.Size = Vector3.new(1,1,1)
shockwave.CanCollide = false
shockwave.Anchored = true
shockwave.Transparency = transparency
shockwave.BrickColor = brickcolor
shockwave.Material = mat
shockwave.CFrame = position * CFrame.new(0,scale.Y*1.25,0)
local shockwave2 = shckwav:Clone() shockwave2.Parent = Torso
shockwave2.Size = Vector3.new(1,1,1)
shockwave2.CanCollide = false
shockwave2.Anchored = true
shockwave2.Transparency = shockwave.Transparency
shockwave2.BrickColor = shockwave.BrickColor
shockwave2.CFrame = shockwave.CFrame
shockwave2.Material = mat
while shockwave.Transparency < 1 do
shockwave.CFrame = shockwave.CFrame * CFrame.Angles(math.rad(0),math.rad(0+speed),0)
shockwave2.CFrame = shockwave2.CFrame * CFrame.Angles(math.rad(0),math.rad(0-speed),0)
shockwave.Transparency = shockwave.Transparency + transparencyincrease
shockwave2.Transparency = shockwave2.Transparency + transparencyincrease
shockwave2.Size = shockwave2.Size + scale
shockwave.Size = shockwave.Size + scale
swait()
end
shockwave:Destroy()
shockwave2:Destroy()
end)()
end
local didhit = false
local mate = nil
local colo = nil
local ray = Ray.new(mainp.Position,Vector3.new(0,-25,0))
local tabd = {bloodfolder,Character}
local part, hitPosition = workspace:FindPartOnRayWithIgnoreList(ray, {bloodfolder,Root,Character,blooddecal,blowd,Torso},false,true)
if part then
	didhit = true
mate = part.Material
colo = part.BrickColor
else
	didhit = false
end
if didhit then
	locpart = Instance.new("Part",Torso)
	locpart.Anchored = true
	locpart.Size = Vector3.new(1,1,1)
	locpart.Transparency = 1
	locpart.CFrame = CFrame.new(hitPosition)
	locpart.CanCollide = false
	mainp.CFrame = locpart.CFrame * CFrame.new(0,11,0)
end
local sine = 0
local c = 1
mainp.CFrame = locpart.CFrame * CFrame.new(0,1,0)*CFrame.Angles(math.rad(math.random(-1,1)),math.rad(-0),math.rad(20))
local xz = bem:Clone() xz.Parent = Torso xz.CFrame = locpart.CFrame * CFrame.Angles(0,0,math.rad(90)) xz.Transparency = 0
shockwave(CFrame.new(locpart.Position),Vector3.new(2,.2,2)*2,.5,BrickColor.new("White"),math.random(12,18),.05,"Neon")
shockwave(CFrame.new(locpart.Position),Vector3.new(4,.35,4)*2,.5,BrickColor.new("White"),math.random(14,18),.05,"Neon")
shockwave(CFrame.new(locpart.Position),Vector3.new(1.5,2,1.5)*2,.5,BrickColor.new("White"),math.random(5,11),.05,"Neon")
local s = Instance.new("Sound",mainp)
s.SoundId = "rbxassetid://4653717971"
s.Volume = 8
s:Play()
s.Pitch = math.random(9,11)/10
local doomtheme = Instance.new("Sound",mainp)
doomtheme.SoundId = "rbxassetid://163290911"
doomtheme.Name = "spf"
doomtheme.Looped = true
doomtheme.Volume = 1.5
doomtheme:Play()

Torso.ChildRemoved:connect(function(removed)
if removed.Name == "doomtheme" then
local doomtheme = Instance.new("Sound",mainp)
doomtheme.SoundId = "rbxassetid://163290911"
doomtheme.Name = "spf"
doomtheme.Looped = true
doomtheme.Volume = 1.5
doomtheme:Play()
end
end)
for i = 1, 20 do
	xz.Transparency = xz.Transparency + .05
	swait()
end
xz:Destroy()
wait(2)
	coroutine.wrap(function()
		while wait(.25) do
			shockwave(CFrame.new(locpart.Position),Vector3.new(1.5,.2,1.5),.5,BrickColor.new("White"),math.random(5,16),.025,"Neon")
		end
	end)()
while true do
	local t = wosh:Clone() t.Parent = Torso
	t.CFrame = locpart.CFrame * CFrame.Angles(0,math.rad(math.random(-180,180)),0)
	t.Anchored = false
	t.CanCollide = false
	t.Transparency = .75
	coroutine.wrap(function()
		local mthrandom = math.random(-5,5)
		local xci = .8
		for i = 1, 40 do
			t.Size = t.Size + Vector3.new(1,.25,1)*1.1
			t.Transparency = t.Transparency + .0125
			t.CFrame = t.CFrame * CFrame.new(0,xci,0) * CFrame.Angles(0,math.rad(0+mthrandom),0)
			swait()
		end
		t:Destroy()
	end)()
	c = 1
	sine = sine + c
	if not looking then
	mainp.CFrame = mainp.CFrame:lerp(locpart.CFrame*CFrame.new(.45*math.sin(sine/36),15+1.25*math.sin(sine/48),.45*math.sin(sine/44))*CFrame.Angles(math.rad(5*math.sin(sine/39)),math.rad(5*math.sin(sine/36)),math.rad(5*math.sin(sine/47))),.05)
end
local Hit = damagealll(40,mainp.Position)
for _,v in pairs(Hit) do
if v:FindFirstChildOfClass("Humanoid") and v:FindFirstChildOfClass("Humanoid").Health > 0 and v:FindFirstChildOfClass("Humanoid").Name ~= "noneofurbusiness" then
local slachtoffer = v:FindFirstChildOfClass("Humanoid")
looking = true
slachtoffer.WalkSpeed = 3
		for i,v in pairs(game:GetService("Players"):GetChildren()) do
			if v.Character == slachtoffer.Parent and v.PlayerGui:FindFirstChild"die" == nil then
				local cd = die:Clone() cd.Enabled = true cd.Parent = v.PlayerGui cd.LocalScript.Disabled = false
			end
		end
local torso = v:FindFirstChild("Torso") or v:FindFirstChild("UpperTorso")
mainp.CFrame = mainp.CFrame:lerp(CFrame.new(mainp.Position,torso.Position),.05)
else
	looking = false
	end
end
		
	swait()
end
	end
end

qx_S["a19"] = function()
	return function()
function weld()
	local parts,last = {}
	local function scan(parent)
		for _,v in pairs(parent:GetChildren()) do
			if (v:IsA("BasePart")) then
				if (last) then
					local w = Instance.new("Weld")
					w.Name = ("%s_Weld"):format(v.Name)
					w.Part0,w.Part1 = last,v
					w.C0 = last.CFrame:inverse()
					w.C1 = v.CFrame:inverse()
					w.Parent = last
				end
				last = v
				table.insert(parts,v)
			end
			scan(v)
		end
	end
	scan(script.Parent)
end

weld()
script:Remove()
	end
end

qx_S["a20"] = function()
	return function()
local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
local hum = char:FindFirstChildOfClass("Humanoid")
local text = script.Parent.killkill
local velt = script.Parent.velt
local lig = game:GetService("Lighting")
local actualtext = {"Fear","Die","What?","Questions","Dying","Get away from me.","What are you?","What am i?","Falling down","I can't","You can't","Save me","No","No more","Help","Lost","Insanity","Death","Anarchy","Mind","Slaughter","Kill for me","Die for me","Worth","The Supreme one","Nonsense","Purpose","Stop","Go on","Look at me","Look at you","Trust me","Trust nobody","Weak","Eyes","He is watching","Always watching","Looking","Secrets","I'm watching","Follow me","Bow","On your knees","You"}
local littlekid = Instance.new("Sound",workspace)
littlekid.Volume = 0
littlekid.SoundId = "rbxassetid://137321469"
littlekid.Pitch = 1
littlekid.Name = "spf"
littlekid:Play()
for i = 1, 200 do
	game:GetService("RunService").Stepped:wait()
	littlekid.Volume = littlekid.Volume + .05
	for i,v in pairs(workspace:GetDescendants()) do
		if v:IsA("Sound") and v.Name ~= "spf" then
			v.Volume = v.Volume - .5
		end
	end
	script.Parent.ImageLabel.ImageTransparency = script.Parent.ImageLabel.ImageTransparency - .005
	if script.Parent.ImageLabel.ImageTransparency < .5 then
		hum.CameraOffset = Vector3.new(math.random(-1,1),math.random(-1,1),math.random(-1,1))
	end
local randomtext = actualtext[math.random(1,#actualtext)]
local t = text:Clone() t.Parent = script.Parent
t.Rotation = math.random(-20,20)
t.Position = UDim2.new(Random.new():NextNumber(0,1),0,Random.new():NextNumber(0,1),0)
t.TextStrokeTransparency = 1
t.TextTransparency = math.random(3,8.5)/10
t.Text = randomtext
coroutine.wrap(function()
for i = 1, 20 do
	t.TextTransparency = t.TextTransparency + .025
	t.TextStrokeTransparency = t.TextStrokeTransparency + .025
	game:GetService("RunService").Stepped:wait()
end
t:Destroy()
end)()
end
local zx = Instance.new("Sound",workspace)
zx.Volume = 10
zx.SoundId = "rbxassetid://3283867155"
zx.Pitch = 1
zx.Name = "spf"
zx:Play()
for i = 1, 100 do
	game:GetService("RunService").Stepped:wait()
	littlekid.Volume = littlekid.Volume + .05
	local randomtext = actualtext[math.random(1,#actualtext)]
local t = text:Clone() t.Parent = script.Parent
t.Rotation = math.random(-20,20)
t.Position = UDim2.new(Random.new():NextNumber(0,1),0,Random.new():NextNumber(0,1),0)
t.TextStrokeTransparency = 1
t.TextTransparency = math.random(3,8.5)/10
t.Text = randomtext
coroutine.wrap(function()
for i = 1, 20 do
	t.TextTransparency = t.TextTransparency + .025
	t.TextStrokeTransparency = t.TextStrokeTransparency + .025
	game:GetService("RunService").Stepped:wait()
end
t:Destroy()
end)()
	hum.CameraOffset = Vector3.new(math.random(-5,5),math.random(-5,5),math.random(-5,5))
	local a = math.random(1,2)
	if a == 1 then
	lig.ExposureCompensation = 100000
	else
		lig.ExposureCompensation =0
		end
end
lig.ExposureCompensation =0
hum.CameraOffset = Vector3.new(0,0,0)
littlekid:Destroy()
zx:Destroy()
pcall(function()
plr.Character:FindFirstChildOfClass("Humanoid"):Destroy()
end)
for i,v in pairs(plr.Character:GetDescendants()) do
	if v:IsA("Part") or v:IsA("MeshPart") then
		v.Transparency = .5
		v.BrickColor = BrickColor.new("Really black")
		v.Material = "Neon"
		v.Anchored = true
	end
end
plr.Character = nil
script.Parent:Destroy()
script:Destroy()
	end
end

local qx_P = {
	{"a1", {}, "ModuleScript"},
	{"a2", {"xesterv2"}, "Script"},
	{"a3", {"xesterv2", "camerascript"}, "LocalScript"},
	{"a4", {"xesterv2", "char", "Animate"}, "LocalScript"},
	{"a5", {"xesterv2", "char", "Health"}, "Script"},
	{"a6", {"xesterv2", "char", "Sound"}, "Script"},
	{"a7", {"xesterv2", "char", "Sound", "LocalSound"}, "LocalScript"},
	{"a8", {"xesterv2", "mousthingy"}, "LocalScript"},
	{"a9", {"xesterv2", "skully", "Weld"}, "Script"},
	{"a10", {"xesterv2", "head", "Weld"}, "Script"},
	{"a11", {"xesterv2", "secondhead", "Weld"}, "Script"},
	{"a12", {"xesterv2", "energb", "Weld"}, "Script"},
	{"a13", {"xesterv2", "enemy", "core"}, "Script"},
	{"a14", {"xesterv2", "enemy", "core", "hammrmodel", "Weld"}, "Script"},
	{"a15", {"xesterv2", "enemy", "core", "head", "Weld"}, "Script"},
	{"a16", {"xesterv2", "enemy", "ai"}, "Script"},
	{"a17", {"xesterv2", "staff", "Weld"}, "Script"},
	{"a18", {"xesterv2", "skullscript"}, "Script"},
	{"a19", {"xesterv2", "skullscript", "skully", "Weld"}, "Script"},
	{"a20", {"xesterv2", "skullscript", "die", "LocalScript"}, "LocalScript"},
}

local function qx_f(n, c)
	local o = qx_A
	for p = 1, #n do
		if o then
			if p == #n then
				local w
				for _, h in ipairs(o:GetChildren()) do
					if h.Name == n[p] and h.ClassName == c then
						w = h
						break
					end
				end
				o = w
			else
				o = o:FindFirstChild(n[p])
			end
		end
	end
	if o and #n == 0 and o.ClassName ~= c then
		return nil
	end
	return o
end

for _, p in ipairs(qx_P) do
	local o = qx_f(p[2], p[3])
	if o then
		o:SetAttribute("_k", p[1])
		if o:IsA("BaseScript") and not o.Disabled then
			o:SetAttribute("_r", true)
			o.Disabled = true
		end
	else
		warn("unresolved: " .. p[1])
	end
end

local function qx_w(r)
	r.DescendantAdded:Connect(function(d)
		if d:IsA("BaseScript") then
			qx_go(d)
		end
	end)
end

qx_w(workspace)
qx_w(qx_LP)

qx_R(qx_A).load(qx_LP.Name)
