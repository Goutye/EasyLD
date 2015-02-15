local class = require 'middleclass'

local Shape = require 'Shape'

local Polygon = class('Polygon', Shape)

function Polygon:initialize(mode, color, ...)
	self.p = {...}
	self.c = color or EasyLD.color:new(255,255,255)
	self.mode = mode
	self.x = self.p[1].x
	self.y = self.p[1].y
end

function Polygon:translate(dx, dy)
	for _,v in ipairs(self.p) do
		v:translate(dx, dy)
	end

	self.x = self.x + dx
	self.y = self.y + dy
end

function Polygon:rotate(angle, ox, oy)
	for _,v in ipairs(self.p) do
		v:rotate(angle, ox, oy)
	end

	self.x = self.p[1].x
	self.y = self.p[1].y
end

function Polygon:moveTo(x, y)
	local dx, dy = x - self.p[1].x, y - self.p[1].y
	self:translate(dx, dy)
end

function Polygon:draw()
	EasyLD.graphics:polygon(self.mode, self.c, unpack(self.p))
end

function Polygon:copy()
	p = {}
	for _,v in ipairs(self.p) do
		table.insert(p, v:copy())
	end

	return Polygon:new(self.mode, self.c:copy(), unpack(p))
end

return Polygon