Player = Class{__includes = {Block}}

local function Sign(n)
	if n == 0 then
		return 0
	elseif n < 0 then
		return -1
	else
		return 1
	end
end

function Player:init(x, y, w, h, Grav)
	Block.init(self, x, y, w, h)
	self.Gravity = Grav
	self.Velocity = {x = 0, y = 0}
	self.ApplyGravity = true
	self.checkpoint = {x = x, y = y}
end

function Player:move(x, y)
	Block.move(self, x, y)
	self.ApplyGravity = true
end

function Player:moveTo(x, y)
	Block.moveTo(self, x, y)
	self.ApplyGravity = true
end

function Player:update(dt)
	if(self.ApplyGravity) then
		self.Velocity.y = self.Velocity.y + self.Gravity * dt
	end

	local Collision = HC.collisions(self)

	local IsOnSomething = false
	for Shape, Vector in pairs(Collision) do


		if Shape.IsDamaging then
			Reset(true)
			return
		end

		
		if Sign(-Vector.x) == Sign(self.Velocity.x) then
			self.Velocity.x = 0
		end
		if(Sign(-Vector.y) == Sign(self.Velocity.y)) then
			if(Sign(self.Velocity.y) == 1) then
				self.ApplyGravity = false
				IsOnSomething = true
				self.Velocity.y = 1
			else
				self.Velocity.y = 0
			end
		end

		if Shape.IsCheckpoint then
			local X, Y = self.InternalShape:center()
			self.checkpoint = {x = X, y = Y}
		end
		
		self.InternalShape:move(Vector.x, Vector.y)
		self.ShadowBody:move(Vector.x, Vector.y)
	end
	
	if IsOnSomething == false then
		self.ApplyGravity = true
	end

	self.InternalShape:move(self.Velocity.x*dt, self.Velocity.y*dt)
	self.ShadowBody:move(self.Velocity.x*dt, self.Velocity.y*dt)
end

function Player:AddVelocity(x, y)
	if x then
		self.Velocity.x = self.Velocity.x + x
	end
	if y then
		self.Velocity.y = self.Velocity.y + y
		self.ApplyGravity = true
	end
end

function Player:SetVelocity(x, y)
	if x then
		self.Velocity.x = x
	end
	if y then
		self.Velocity.y = y
		self.ApplyGravity = true
	end
end

function Player:GetVelocity()
	return {x = self.Velocity.x, y = self.Velocity.y}
end