local class = require 'middleclass'

local Color = class('Color')

function Color:initialize(r, g, b, a)
	self.r = r
	self.g = g
	self.b = b
	self.a = a
end

return Color