function RectToPoly(x, y, w, h)
	return x, y, x+w, y, x+w, y+h, x, y+h
end

Block = Class{}

function Block:init(x, y, w, h)
	self.InternalShape = HC.register(Shape.newPolygonShape(RectToPoly(x, y, w, h)))
	self.ShadowBody = LightWorld:newPolygon(RectToPoly(x, y, w, h))
end

function Block:delete()
	HC.remove(self.InternalShape)
	LightWorld:remove(self.ShadowBody)
end

function Block:move(dx,dy)
	self.InternalShape:move(dx,dy)
	self.ShadowBody:setPoints(self.InternalShape:unpack())
end

function Block:moveTo(x, y)
	self.InternalShape:moveTo(x, y)
	self.ShadowBody:setPoints(self.InternalShape:unpack())
end

function Block:center()
	return self.InternalShape:center()
end

function Block:rotate(angle, cx, cy)
	self.InternalShape:rotate(angle, cx, cy)
	self.ShadowBody:setPoints(self.InternalShape:unpack())
end

function Block:setRotation(angle, cx, cy)
	self.InternalShape:setRotation(angle, cx, cy)
	self.ShadowBody:setPoints(self.InternalShape:unpack())
end

function Block:rotation()
	return self.InternalShape:rotation()
end

function Block:scale(s)
	self.InternalShape:scale(s)
end

function Block:outcirlce()
	return self.InternalShape:outcirlce()
end

function Block:bbox()
	return self.InternalShape:bbox()
end

function Block:draw()
	love.graphics.setColor(0.1, 0.1, 0.1)
	love.graphics.polygon("fill", self.InternalShape:unpack())
end

function Block:support(dx, dy)
	return self.InternalShape:support(dx, dy)
end

function Block:collidesWith(other)
	return self.InternalShape:collidesWith(other)
end

function Block:contains(x, y)
	return self.InternalShape:contains(x, y)
end

function Block:intersectionsWithRay(x, y, dx, dy)
	return self.InternalShape:intersectionsWithRay(x, y, dx, dy)
end

function Block:intersectsRay(x, y, dx, dy)
	return self.InternalShape:intersectsRay(x, y, dx, dy)
end