local class = require 'middleclass'

local Shape = require 'Shape'

local Polygon = class('Polygon', Shape)

function Polygon:initialize(mode, color, ...)
	self.p = {...}
	self.c = color or EasyLD.color:new(255,255,255)
	self.mode = mode
end

function Polygon:translate(dx, dy)
	for _,v in ipairs(self.p) do
		v:translate(dx, dy)
	end
end

function Polygon:rotate(angle, ox, oy)
	for _,v in ipairs(self.p) do
		v:rotate(angle, ox, oy)
	end
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