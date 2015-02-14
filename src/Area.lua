local class = require 'middleclass'

local Shape = require 'Shape'
local Area = class('Area')

function Area:initialize(obj, ox, oy)
	self.forms = {}
	if not obj:isInstanceOf(Shape) then
		print("Bad using of Area : Obj is not a Boc or Circle")
	end
	table.insert(self.forms, obj)

	self.x = obj.x
	self.y = obj.y
	self.ox = ox
	self.oy = oy

	self.follower = nil
end

function Area:attach(obj)
	if obj:isInstanceOf(Shape) then
		table.insert(self.forms, obj)
	end
end

function Area:detach(obj)
	table.remove(self.forms, obj)
end

function Area:follow(obj)
	self.follower = obj
end

function Area:moveTo(x, y)
	local dx, dy = x - self.x, y - self.y

	self:translate(dx, dy)
end

function Area:translate(dx, dy)
	for _,o in ipairs(self.forms) do
		o:translate(dx, dy)
	end

	self.x = self.x + dx
	self.y = self.y + dy
end

function Area:rotate(angle, ox, oy)
	if self.follower ~= nil and self.follower:isInstanceOf(Shape) then
		ox = self.follower.x
		oy = self.follower.y
	elseif ox == nil or oy == nil then
		ox = self.ox
		oy = self.oy
	end
	for _,o in ipairs(self.forms) do
		o:rotate(angle, ox, oy)
	end
end

function Area:draw()
	for _,o in ipairs(self.forms) do
		o:draw()
	end
end

return Area