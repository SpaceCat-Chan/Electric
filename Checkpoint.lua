
Checkpoint = Class{__includes = {Player}}

function Checkpoint:init(x, y, w, h)
	Player.init(self, x, y, w, h, 0)
	LightWorld:newLight(x+w/2, y+h/2, 199, 92, 30, math.max(100, math.max(w,h)+10))
	self.ShadowBody:setShadow(false)
	self.InternalShape.IsCheckpoint = true
	self.IsCheckpoint = true
end

function Checkpoint:draw()
	love.graphics.setColor(199/255, 92/255, 30/255)
	love.graphics.polygon("fill", self.InternalShape:unpack())
end