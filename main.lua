HC = require("HC")
Class = require("hump.class")
Light = require("Light")
denver = require("denver")
ripple = require("ripple")

Player = Class{}

function Player:init(x, y)
	self.InternalShape = HC.rectangle(x, y, 50, 50)
	if self.InternalShape == nil then
		print("HC no create shape")
	end
	self.Light = LightWorld:newLight(x+25, y+25, 50, 50, 70, 300)
	self.Light:setGlowStrength(0.3)
	self.Light:setVisible(true)
end

function Player:move(dx,dy)
	self.InternalShape:move(dx,dy)
	local X, Y, Z = self.Light:getPosition()
	self.Light:setPosition(X + dx, Y + dy, Z)
end

function Player:moveTo(x, y)
	self.InternalShape:moveTo(x, y)
	local _, _, Position = self.Light:getPosition()
	self.Light:setPosition(x, y, Position)
end

function Player:center()
	return self.InternalShape:center()
end

function Player:rotate(angle, cx, cy)
	self.InternalShape:rotate(angle, cx, cy)
	local NewCenter = self.InternalShape:center()
	local Z = self.Light:getPosition()
	self.Light:setPosition(NewCenter.x, NewCenter.y, Z.z)
end

function Player:setRotation(angle, cx, cy)
	self.InternalShape:setRotation(angle, cx, cy)
	local NewCenter = self.InternalShape:center()
	local Z = self.Light:getPosition()
	self.Light:setPosition(NewCenter.x, NewCenter.y, Z.z)
end

function Player:rotation()
	return self.InternalShape:rotation()
end

function Player:scale(s)
	self.InternalShape:scale(s)
end

function Player:outcirlce()
	return self.InternalShape:outcirlce()
end

function Player:bbox()
	return self.InternalShape:bbox()
end

function Player:draw()
	love.graphics.setColor(10, 10, 10)
	local x1, y1, x2, y2 = self.InternalShape:bbox()
	love.graphics.rectangle("fill", x1, y2, x2 - x1, y2 - y1)
end

function Player:support(dx, dy)
	return self.InternalShape:support(dx, dy)
end

function Player:collidesWith(other)
	return self.InternalShape:collidesWith(other)
end

function Player:contains(x, y)
	return self.InternalShape:contains(x, y)
end

function Player:intersectionsWithRay(x, y, dx, dy)
	return self.InternalShape:intersectionsWithRay(x, y, dx, dy)
end

function Player:intersectsRay(x, y, dx, dy)
	return self.InternalShape:intersectsRay(x, y, dx, dy)
end

function love.load()
	LightWorld = Light({
		ambient = {25, 25, 35},
		refractionStrength = 32,
		reflectionVisibility = 0.75,
		shadowBlur = 0.0
	})

	local Wave50 = denver.get({waveform='square', frequency=50})
	local Wave60 = denver.get({waveform='square', frequency=60})
	ToPlay50 = ripple.newSound(Wave50, {volume = 0.25, loop = true})
	ToPlay60 = ripple.newSound(Wave60, {volume = 0.05, loop = true})
	instance50 = ToPlay50:play()
	instalce60 = ToPlay60:play()

	CircleBody = LightWorld:newCircle(100, 100, 10);

	MyPlayer = Player(200, 200)
end

function love.update(dt)
	ToPlay50:update(dt)
	ToPlay60:update(dt)

	LightWorld:update(dt)
end

function love.draw()
	love.graphics.push()
    love.graphics.scale(1)
	LightWorld:draw(function()
		love.graphics.setColor(255, 255, 255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(127, 127, 127)
		love.graphics.circle("fill", 100, 100, 10)
		MyPlayer:draw()
	end)
	love.graphics.pop()
end

function love.keypressed(k)
	if k == "space" then
		if(instance50:isStopped()) then
			ToPlay50:resume()
			ToPlay60:resume()
		else
			ToPlay50:stop()
			ToPlay60:stop()
		end
	end
end