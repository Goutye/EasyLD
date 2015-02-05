local class = require 'middleclass'

local Box = require 'Box'
local Circle = require 'Circle'
local Area = class('Area')

function Area:initialize(obj)
	self.forms = {}
	if not obj:isInstanceOf(Box) and not obj:isInstanceOf(Circle) then
		print("Bad using of Area : Obj is not a Boc or Circle")
	end
	table.insert(self.forms, obj)

	self.x = obj.x
	self.y = obj.y
end

function Area:attach(obj)
	if obj:isInstanceOf(Box) or obj:isInstanceOf(Circle) then
		table.insert(self.forms, obj)
	end
end

function Area:detach(obj)
	table.remove(self.forms, obj)
end

function Area:moveTo(x, y)
	local dx, dy = x - self.x, y - self.y

	self:translate(dx, dy)
end

function Area:translate(dx, dy)
	for _,o in ipairs(self.forms) do
		o.x = o.x + dx
		o.y = o.y + dy
	end

	self.x = self.x + dx
	self.y = self.y + dy
end

function Area:draw()
	for _,o in ipairs(self.forms) do
		o:draw()
	end
end

return Area