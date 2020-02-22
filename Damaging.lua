

DamagingObject = Class{__includes = {Player}}


function DamagingObject:init(x, y, w, h)
	Player.init(self, x, y, w, h, 0)
	self.Light = LightWorld:newLight(x+w/2, y+h/2, 38, 251, 255, math.max(100, math.max(w,h)+10))
	self.ShadowBody:setShadow(false)
	self.InternalShape.IsDamaging = true
	self.IsDamaging = true
end

function DamagingObject:draw()
	love.graphics.setColor(38/255, 251/255, 255/255)
	love.graphics.polygon("fill", self.InternalShape:unpack())
end

function DamagingObject:update(dt)
	self.InternalShape:move(self.Velocity.x*dt, self.Velocity.y*dt)
	self.ShadowBody:move(self.Velocity.x*dt, self.Velocity.y*dt)
	self.Light:setPosition(self.InternalShape:center())
end