local class = require 'middleclass'

local Shape = require 'Shape'

local Segment = class('Segment', Shape)

function Segment:initialize(p1, p2, color)
	self.p1 = p1
	self.p2 = p2
	self.c = color or EasyLD.color:new(255,255,255)
end

function Segment:translate(dx, dy)
	self.p1:translate(dx, dy)
	self.p2:translate(dx, dy)
end

function Segment:rotate(angle, ox, oy)
	self.p1:rotate(angle, ox, oy)
	self.p2:rotate(angle, ox, oy)
end

function Segment:draw()
	EasyLD.graphics:line(self.p1, self.p2, self.c)
end

function Segment:copy()
	return Segment:new(p1:copy(), p2:copy(), self.c:copy())
end

return Segment