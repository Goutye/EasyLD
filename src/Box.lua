local class = require 'middleclass'

local Box = class('Box')

function Box:initialize(x, y, w , h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end

function Box:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

return Box