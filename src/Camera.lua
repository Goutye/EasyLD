local class = require 'middleclass'

local Camera = class('Camera')

function Camera:initialize(x, y, w, h, follower, mode, ox, oy)
	self.scale = 1
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.ox = ox or x
	self.oy = oy or y
	self.mode = mode
	self.follower = follower
	self.angle = 0
end

function Camera:scaleTo(scale)
	self:scale(scale - self.scale)
end

function Camera:scale(scale)

end

function Camera:moveTo(x, y)
	self:move(x - self.x, y - self.y)
end

function Camera:move(x, y)

end

function Camera:rotateTo(angle, ox, oy)
	self:rotate(angle - self.angle, ox, oy)
end

function Camera:rotate(ox, oy)
	if ox ~= nil and oy ~= nil then

	elseif self.follower ~= nil then

	else
		--self.ox, self.oy
	end
end

--Goal => Drystal camera || love rotation/translate

return Camera