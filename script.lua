-- ULTRA BLACK HOLE FX FINAL FULL
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")

local old = workspace:FindFirstChild("UltraBlackHoleFX")
if old then
	old:Destroy()
end

local FX = Instance.new("Folder")
FX.Name = "UltraBlackHoleFX"
FX.Parent = workspace

local CONFIG = {
	METEOR_INTERVAL_MIN = 0.15,
	METEOR_INTERVAL_MAX = 0.35,
	METEOR_HEIGHT = 350,
	METEOR_SPEED = 0.02,
	BLACK_HOLE_HEIGHT = 8,
	RING_HEIGHT = 2.8,
	PLANET_RADIUS = 7,
	PLANET_COUNT = 4
}

local function createPart(props)
	local p = Instance.new("Part")
	for k,v in pairs(props) do
		p[k] = v
	end
	p.Parent = FX
	return p
end

-- SKY
Lighting.ClockTime = 14
Lighting.Brightness = 4
Lighting.FogStart = 800
Lighting.FogEnd = 25000

local oldSky = Lighting:FindFirstChild("GalaxySky")
if oldSky then
	oldSky:Destroy()
end

local sky = Instance.new("Sky")
sky.Name = "GalaxySky"
sky.SkyboxBk = "rbxassetid://159454299"
sky.SkyboxDn = "rbxassetid://159454296"
sky.SkyboxFt = "rbxassetid://159454293"
sky.SkyboxLf = "rbxassetid://159454286"
sky.SkyboxRt = "rbxassetid://159454300"
sky.SkyboxUp = "rbxassetid://159454288"
sky.SunTextureId = "rbxassetid://284205403"
sky.MoonTextureId = "rbxassetid://284205403"
sky.SunAngularSize = 45
sky.MoonAngularSize = 45
sky.Parent = Lighting

-- BLACK HOLE
local hole = createPart({
	Shape = Enum.PartType.Ball,
	Size = Vector3.new(7,7,7),
	Material = Enum.Material.Neon,
	Color = Color3.new(0,0,0),
	Anchored = true,
	CanCollide = false
})

local vortex = Instance.new("ParticleEmitter")
vortex.Texture = "rbxassetid://284205403"
vortex.Rate = 300
vortex.Lifetime = NumberRange.new(1,2)
vortex.Speed = NumberRange.new(0.15,0.4)
vortex.RotSpeed = NumberRange.new(-300,300)
vortex.SpreadAngle = Vector2.new(360,360)
vortex.Parent = hole

-- RING + GALAXY TRAIL
local ring = createPart({
	Shape = Enum.PartType.Cylinder,
	Size = Vector3.new(0.2,10,10),
	Material = Enum.Material.Neon,
	Color = Color3.fromRGB(150,80,255),
	Transparency = 0.3,
	Anchored = true,
	CanCollide = false
})

local trail = Instance.new("ParticleEmitter")
trail.Texture = "rbxassetid://284205403"
trail.Rate = 220
trail.Lifetime = NumberRange.new(1.5,3)
trail.Speed = NumberRange.new(0.05,0.15)
trail.SpreadAngle = Vector2.new(360,360)
trail.RotSpeed = NumberRange.new(-180,180)

trail.Size = NumberSequence.new({
	NumberSequenceKeypoint.new(0,2),
	NumberSequenceKeypoint.new(0.5,4),
	NumberSequenceKeypoint.new(1,0)
})

trail.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(120,0,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40,0,80))
})

trail.Parent = ring

-- PLANETS
local planets = {}

for i = 1, CONFIG.PLANET_COUNT do
	local size = math.random(14,24) / 10

	local planet = createPart({
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(size,size,size),
		Material = Enum.Material.Neon,
		Color = Color3.fromRGB(
			math.random(100,255),
			math.random(100,255),
			math.random(180,255)
		),
		Anchored = true,
		CanCollide = false
	})

	table.insert(planets, planet)
end

-- REAL ASTEROID METEORS
local function createMeteor()
	local size = math.random(4,7)

	local meteor = createPart({
		Shape = Enum.PartType.Ball,
		Size = Vector3.new(size,size,size),
		Material = Enum.Material.Slate,
		Color = Color3.fromRGB(90,70,60),
		Anchored = true,
		CanCollide = false
	})

	local fire = Instance.new("ParticleEmitter")
	fire.Texture = "rbxassetid://284205403"
	fire.Rate = 180
	fire.Lifetime = NumberRange.new(0.4,0.8)
	fire.Speed = NumberRange.new(0.1,0.3)
	fire.Parent = meteor

	local x = math.random(-250,250)
	local z = math.random(-250,250)

	for i = 1, 70 do
		if not meteor.Parent then break end

		meteor.Position = Vector3.new(
			x + i * 1.2,
			CONFIG.METEOR_HEIGHT - i * 5,
			z + i * 1.2
		)

		meteor.CFrame *= CFrame.Angles(0.2,0.15,0.1)
		task.wait(CONFIG.METEOR_SPEED)
	end

	local pos = meteor.Position

	local explosion = Instance.new("Explosion")
	explosion.Position = pos
	explosion.BlastRadius = 18
	explosion.BlastPressure = 0
	explosion.Parent = workspace

	local distance = (root.Position - pos).Magnitude

	if distance <= 20 then
		root.AssemblyLinearVelocity =
			(root.Position - pos).Unit * 140
			+ Vector3.new(0,60,0)
	end

	local wave = createPart({
		Shape = Enum.PartType.Cylinder,
		Size = Vector3.new(0.5,1,1),
		Material = Enum.Material.Neon,
		Color = Color3.fromRGB(180,120,255),
		Transparency = 0.2,
		Anchored = true,
		CanCollide = false
	})

	wave.CFrame =
		CFrame.new(pos)
		* CFrame.Angles(0,0,math.rad(90))

	TweenService:Create(
		wave,
		TweenInfo.new(0.9),
		{
			Size = Vector3.new(0.5,80,80),
			Transparency = 1
		}
	):Play()

	Debris:AddItem(wave,1.2)
	meteor:Destroy()
end

task.spawn(function()
	while character.Parent do
		task.wait(math.random() * 0.2 + 0.15)

		for i = 1, math.random(2,4) do
			task.spawn(createMeteor)
		end
	end
end)

-- MAIN LOOP
local timePassed = 0

RunService.RenderStepped:Connect(function(dt)
	if not root.Parent then return end

	timePassed += dt

	hole.Position = root.Position + Vector3.new(0, CONFIG.BLACK_HOLE_HEIGHT, 0)
	hole.CFrame *= CFrame.Angles(0, dt * 8, 0)

	ring.CFrame =
		CFrame.new(root.Position - Vector3.new(0, CONFIG.RING_HEIGHT, 0))
		* CFrame.Angles(0,0,math.rad(90))

	for i, planet in ipairs(planets) do
		local angle = timePassed * 2 + i * math.pi / 2
		local radius = CONFIG.PLANET_RADIUS + i * 0.8

		planet.Position = root.Position + Vector3.new(
			math.cos(angle) * radius,
			2 + math.sin(timePassed * 3 + i),
			math.sin(angle) * radius
		)

		planet.CFrame *= CFrame.Angles(dt * 2, dt * 2, 0)
	end
end)

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	root = newChar:WaitForChild("HumanoidRootPart")
end)
