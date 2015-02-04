local class = require 'middleclass'

local Box = class('Box')

function Box:initialize(x, y, w, h, c)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.c = c

	if c == nil then
		self.c = EasyLD.color:new(255,255,255)
	end
end

function Box.__add(b, v)
	if type(b) == "table" and b.w ~= nil and type(v) == "table" then
		return Box:new(b.x + v.x, b.y + v.y, b.w, b.h, b.c)
	else
		return b
	end
end

function Box.__sub(b, v)
	if type(b) == "table" and b.w ~= nil and type(v) == "table" then
		return Box:new(b.x - v.x, b.y - v.y, b.w, b.h, b.c)
	else
		return b
	end
end

function Box:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function Box:draw(mode)
	EasyLD.graphics:rectangle(mode, self, self.c)
end

return Box