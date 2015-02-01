local class = require 'middleclass'

local Circle = class('Circle')

function Circle:initialize(x, y, r)
	self.x = x
	self.y = y
	self.r = r
end

function Circle:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

return Circle