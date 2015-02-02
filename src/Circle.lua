local class = require 'middleclass'

local Circle = class('Circle')

function Circle:initialize(x, y, r, c)
	self.x = x
	self.y = y
	self.r = r
	self.c = c

	if c == nil then
		self.c = EasyLD.color:new(255,255,255)
	end
end

function Circle:move(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy
end

function Circle:draw(mode, nbSeg)
	EasyLD.graphics:circle(mode, self, nbSeg, self.c)
end

return Circle