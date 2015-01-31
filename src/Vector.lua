local class = require 'middleclass'

local Vector = class('Vector')

function Vector.static:of(pos1, pos2)
	return EasyLD.vector:new(pos2.x - pos1.x, pos2.y - pos1.y)
end

function Vector:initialize(x, y)
	self.x = x
	self.y = y
end

function Vector:normalize()
	local l = self:length()
	self.x = self.x / l
	self.y = self.y / l
end

function Vector:length()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector:rotate(angle)
	self.x = self.x * math.cos(angle) - self.y * math.sin(angle)
	self.y = self.x * math.sin(angle) + self.y * math.cos(angle)
end

function Vector:copy()
	return EasyLD.vector:new(self.x, self.y)
end

function Vector:getAngle()
	local v = self:copy()
	v:normalize()
	local angle = math.acos(v.y)

	if v.x > 0 then
		angle = -angle
	end

	angle = angle + math.pi/2

	if angle < 0 then
		angle = angle + math.pi*2
	end

	return angle
end

return Vector