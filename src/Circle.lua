local class = require 'middleclass'

local Circle = class('Circle')

function Circle:initialize(x, y, r, c, mode)
	self.x = x
	self.y = y
	self.r = r
	self.c = c
	self.mode = mode

	if c == nil then
		self.c = EasyLD.color:new(255,255,255)
	end
end

function Circle.__add(c, v)
	if type(c) == "table" and c.r ~= nil and type(v) == "table" then
		print(c.c)
		return Circle:new(c.x + v.x, c.y + v.y, c.r, c.c)
	else
		return c
	end
end

function Circle.__sub(c, v)
	if type(c) == "table" and c.r ~= nil and type(v) == "table" then
		return Circle:new(c.x - v.x, c.y - v.y, c.r, c.c)
	else
		return c
	end
end

function Circle:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function Circle:draw(mode, nbSeg)
	if mode == nil then
		mode = self.mode
	end
	EasyLD.graphics:circle(mode, self, nbSeg, self.c)
end

return Circle