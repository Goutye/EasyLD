local class = require 'middleclass'

local Entity = class('Entity')

function Entity:initialize(pos, collideArea)
	self.pos = pos
	self.collideArea = collideArea
end

function Entity:collide(otherEntity)
	return self.collideArea:collide(otherEntity.collideArea)
end

return Entity