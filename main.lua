HC = require("HC")
Shape = require("HC.shapes")
Polygon = require("HC.polygon")
Class = require("hump.class")
Light = require("Light")
denver = require("denver")
ripple = require("ripple")
flux = require("flux")

require("Block")
require("Player")
require("Damaging")
require("Checkpoint")
require("MovingBlock")

function Add(Item)
	table.insert(World, Item)
end

function AddMoving(Item, MinX, MaxX, MinY, MaxY, SpeedX, SpeedY)
	table.insert(MovingWorld, {Item = Item, Min = {x = MinX, y = MinY}, Max = {x = MaxX, y = MaxY}, Speed = {x = SpeedX, y = SpeedY}})
end

function UpdateMoving(dt)
	for _, Object in pairs(MovingWorld) do
		if Object.Min.x == Object.Max.x or Object.Speed.x == 0 then
			Object.Item:SetVelocity(0, nil)
		elseif Object.Item:GetVelocity().x == 0 or Object.Item:center() < Object.Min.x then
			Object.Item:SetVelocity(Object.Speed.x, nil)
		elseif Object.Item:center() > Object.Max.x then
			Object.Item:SetVelocity(-Object.Speed.x, nil)
		end
		local _, YCenter = Object.Item:center()
		if Object.Min.y == Object.Max.y or Object.Speed.y == 0 then
			Object.Item:SetVelocity(nil, 0)
		elseif Object.Item:GetVelocity().y == 0 or YCenter < Object.Min.y then
			Object.Item:SetVelocity(nil, Object.Speed.y)
		elseif YCenter > Object.Max.y then
			Object.Item:SetVelocity(nil, -Object.Speed.y)
		end
		Object.Item:update(dt)
	end
end

function Rotate(amount)
	World[#World]:rotate(amount)
end

function love.load()
	LightWorld = Light({
		ambient = {0, 11, 28},
		refractionStrength = 32,
		reflectionVisibility = 0.75,
		--shadowBlur = 0.0
	})

	local Wave50 = denver.get({waveform='square', frequency=50})
	local Wave60 = denver.get({waveform='square', frequency=60})
	SoundTag = ripple.newTag()
	ToPlay50 = ripple.newSound(Wave50, {volume = 0.25, loop = true})
	ToPlay60 = ripple.newSound(Wave60, {volume = 0.05, loop = true})
	ToPlay50:tag(SoundTag)
	ToPlay60:tag(SoundTag)
	SoundInstance = ToPlay50:play()
	ToPlay60:play()
	SoundTag.volume = 0


	World = {}
	MovingWorld = {}
	--roof and lights
	Add(Block(-800, 0, 800, 600))
	Add(Block(0, 500, 8000, 100))
	Add(Block(0, -50, 250, 200))
	Add(Block(-200, 200, 500, 200))
	Rotate(math.pi/2 + math.pi/16 + -math.pi/8)
	LightWorld:newLight(275, -50, 255, 255, 255, 600)
	
	Add(Block(400, -100, 600, 300))
	Rotate(-math.pi/16 + -math.pi/32)
	Add(Block(1100, -150, 550, 250))
	Rotate(math.pi/16 + -math.pi/32)
	LightWorld:newLight(1050, 10, 255, 255, 255, 500)

	Add(Block(1600, -85, 1000, 225))
	Rotate(-math.pi/16)

	Add(Block(2800, -100, 750, 193))
	Rotate(math.pi/32 + math.pi/64)
	LightWorld:newLight(2700, 10, 255, 255, 255, 500)

	Add(Block(3500, -100, 500, 200))
	Rotate(-math.pi/16)


	Add(Block(4200, -100, 500, 200))
	Rotate(-math.pi/16 + -math.pi/32)
	Add(Block(4650, -475, 100, 500))
	LightWorld:newLight(4100, 10, 255, 255, 255, 500)

	Add(Block(5350, -100, 600, 200))
	Rotate(-math.pi/32 + math.pi/64)
	LightWorld:newLight(4750, 10 , 255, 255, 255, 500)
	LightWorld:newLight(5250, 10, 255, 255, 255, 700)

	Add(Block(6350, -50, 550, 200))
	Rotate(math.pi/32)
	LightWorld:newLight(6250, 10, 255, 255, 255, 500)
	LightWorld:newLight(6910, 10, 255, 255, 255, 500)
	LightWorld:newLight(7990, 10, 255, 255, 255, 1000)

	--obsticals
	Add(Block(600, 400, 50, 100))
	Add(DamagingObject(650, 500-25, 200, 25))

	Add(Block(1100, 500-25-100, 150, 25))
	Add(DamagingObject(1050, 500-25, 300, 25))


	Add(DamagingObject(1300, 500-100, 300, 100))
	Add(Block(1625, 500-100, 50, 150))

	Add(DamagingObject(1800, 500-25-100, 125, 25))
	Add(Block(1675, 500-50, 350, 50))
	Add(DamagingObject(2025, 500-50, 300, 50))
	Add(Block(2100, 500-25-100, 150, 25))

	Add(Block(2400, 500-250, 100, 250))
	Add(Block(2500, 500-175, 200, 50))

	Add(Checkpoint(2500, 500-125, 199, 125))

	Add(DamagingObject(2900, 500-50, 500, 50))
	Add(DamagingObject(2900, 500-50-275, 500, 50))

	Add(Block(3000, 500-50-10-25, 100, 25))
	Add(Block(3200, 500-50-110-25, 125, 25))

	Add(Block(3700, 500-50-100, 150, 50))
	Add(DamagingObject(3850, 500-150, 300, 150))
	Add(Block(4250, 500-200-100, 50, 200))

	Add(Block(4300, 500-50-100, 25, 50))
	Add(DamagingObject(4425, 500-275, 50, 275))

	AddMoving(DamagingObject(4700, 500-300, 100, 300), 0, 0, 500-400+300/2, 500-300+300/2, 0, 50)

	do
		local Block = MovingBlock(4900, 500-400, 50, 400)
		Block.ShadowBody:setShadow(false)
		AddMoving(Block, 4900+50/2, 5200+50/2, 0, 0, 75, 0)
	end
	Add(Block(4800, 500-150, 50, 50))
	Add(Block(4950, 500-300, 50, 50))
	Add(DamagingObject(4950, 500-50, 300, 50))

	AddMoving(MovingBlock(5500, 500-50, 400, 50), 0, 0, 500-250+50/2-25, 500-25+50/2-25, 0, 50)

	Add(Block(5900, 500-250-25, 50, 275))
	Add(DamagingObject(5950, 500-25, 250, 25))
	Add(Block(6200, 500-50-50, 200, 50))
	Add(DamagingObject(6200, 500-300, 50, 150))

	Add(DamagingObject(6400, 500-200, 50, 200))
	Add(Block(6400, 500-350, 200, 50))
	Add(Block(6400, 500-400, 50, 50))
	Add(Checkpoint(6500, 500-25, 50, 25))

	Add(DamagingObject(6650, 500-50, 300, 50))
	Add(DamagingObject(6650, 500-50-275, 300, 50))
	Add(Block(6700, 500-50-25-50, 200, 25))
	Add(DamagingObject(6950, 500-125, 50, 125))

	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 10, 100)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 20, 90)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 30, 80)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 40, 70)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 50, 60)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 60, 50)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 70, 40)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 80, 30)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 90, 20)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 100, 10)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 100, 100)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 90, 90)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 80, 80)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 70, 70)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 60, 60)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 50, 50)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 40, 40)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 30, 30)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 20, 20)
	AddMoving(MovingBlock(7500, 500-250, 50, 50), 7000+50/2, 7950+50/2, 50/2, 500-50/2, 10, 10)

	Add(Block(8000, 0, 600, 800))


	ThePlayer = Player(200, 450, 50, 50, 800)

	local CurrentMinDistance = 10000000000000
	local PlayerX, PlayerY = ThePlayer:center()
	for _, Object in pairs(World) do
		if Object.IsDamaging then
			local OtherX, OtherY = Object:center()
			CurrentMinDistance = math.min(CurrentMinDistance, math.sqrt(math.abs(PlayerX - OtherX)^2 + math.abs(PlayerY - OtherY)^2))
		end
	end
	local ResultVolume
	if CurrentMinDistance ~= 0 then
		ResultVolume = 1/CurrentMinDistance * 100
	else
		ResultVolume = 0
	end

	CurrentState = {Brightness = 0}

	AcceptInput = false
	flux.to(CurrentState, 10, {Brightness = 1}):ease("expoin")
	flux.to(SoundTag, 10, {volume = ResultVolume}):ease("expoin"):oncomplete(Start)

end

function Start()
	AcceptInput = true
end

function Reset(checkpoint)
	ThePlayer:delete()
	if not checkpoint then
		ThePlayer = Player(200, 450, 50, 50, 800)
	else
		ThePlayer = Player(ThePlayer.checkpoint.x, ThePlayer.checkpoint.y, 50, 50, 800)
	end
end

function love.update(dt)
	love.window.setTitle("Electric (FPS:" .. love.timer.getFPS() .. ")")

	ToPlay50:update(dt)
	ToPlay60:update(dt)

	flux.update(dt)

	if love.keyboard.isDown("a") and AcceptInput then
		ThePlayer:SetVelocity(-300)
	elseif love.keyboard.isDown("d") and AcceptInput then
		ThePlayer:SetVelocity(300)
	else
		ThePlayer:SetVelocity(0)
	end

	if love.keyboard.isDown("w") and AcceptInput then
		ThePlayer:AddVelocity(nil, -175*dt)
	end

	local PlayerX, PlayerY = ThePlayer:center()
	if PlayerX > 8000 and PlayerY < 0 then
		ThePlayer:SetVelocity(0, 0)
		ThePlayer:moveTo(8025, -25)
	end
	ThePlayer:update(dt)
	UpdateMoving(dt)

	LightWorld:update(dt)

	if AcceptInput then
	local CurrentMinDistance = 10000000000000
	for _, Object in pairs(World) do
		if Object.IsDamaging then
			local OtherX, OtherY = Object:center()
			CurrentMinDistance = math.min(CurrentMinDistance, math.sqrt(math.abs(PlayerX - OtherX)^2 + math.abs(PlayerY - OtherY)^2))
		end
	end
		if CurrentMinDistance ~= 0 then
			SoundTag.volume = 1/CurrentMinDistance * 100
		else
			SoundTag.volume = 0
		end
	end
end

function love.draw()
	local Canvas = love.graphics.newCanvas()
	love.graphics.setCanvas(Canvas)
	love.graphics.push()
	love.graphics.scale(1)
	local PlayerX, PlayerY = ThePlayer:center()
	LightWorld.l = (400 - PlayerX)
	LightWorld:draw(function()
		--love.graphics.translate(400 - PlayerX, 0)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth()*10, love.graphics.getHeight())


		for _, Object in pairs(World) do
			Object:draw()
		end
		for _,Object in pairs(MovingWorld) do
			Object.Item:draw()
		end
		ThePlayer:draw()
		love.graphics.print("get out", 400, 300, math.pi/16)
		love.graphics.print("up", 2600, 75, -math.pi/16)
		love.graphics.print("the light", 4000, 300, math.pi/32*3)
		love.graphics.print("matrix", 6100, 300, -math.pi/8)
	end)
	love.graphics.pop()
	if PlayerX > 8000 and PlayerY < 0 then
		love.graphics.printf("You Win", 200, 300, 400, "center")
	end
	love.graphics.setCanvas()
	love.graphics.setColor(CurrentState.Brightness, CurrentState.Brightness, CurrentState.Brightness)
	love.graphics.draw(Canvas)
end

function love.keypressed(k)
	if not AcceptInput then
		return
	end
	if k == "space" then
		if(SoundInstance:isStopped()) then
			ToPlay50:resume()
			ToPlay60:resume()
		else
			ToPlay50:stop()
			ToPlay60:stop()
		end
	elseif k == "w" then
		if not ThePlayer.ApplyGravity then
			ThePlayer:AddVelocity(nil, -450)
		end
	elseif k == "s" then
		ThePlayer:AddVelocity(nil, 1000)
	elseif k == "r" then
		Reset(false)
	end
end