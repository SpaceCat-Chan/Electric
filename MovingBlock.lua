
MovingBlock = Class{__includes = {Player}}


function MovingBlock:init(x, y, w, h)
	Player.init(self, x, y, w, h, 0)
end

function MovingBlock:update(dt)
	self.InternalShape:move(self.Velocity.x*dt, self.Velocity.y*dt)
	self.ShadowBody:move(self.Velocity.x*dt, self.Velocity.y*dt)
end