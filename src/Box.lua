local class = require 'middleclass'

local Point = require 'Point'
local Vector = require 'Vector'
local Matrix = require 'Matrix'

local Box = class('Box')

function Box:initialize(x, y, w, h, c, mode)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.c = c
	self.mode = mode
	self.angle = 0

	local p = {}
	table.insert(p, Point:new(self.x, self.y))
	table.insert(p, Point:new(p[1].x + w, p[1].y))
	table.insert(p, Point:new(p[2].x, p[2].y + h))
	table.insert(p, Point:new(p[1].x, p[1].y + h))

	self.p = p
	self.wP = Point:new(self.w, 0)
	self.hP = Point:new(0, self.h)

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

function Box:copy()
	local b = Box:new(self.x, self.y, self.w, self.h, self.c, self.mode)
	b.angle = self.angle
	b.wP = self.wP:copy()
	b.hP = self.hP:copy()

	for i = 1, 4 do
		b.p[i] = self.p[i]:copy()
	end

	return b
end

function Box:translate(dx, dy)
	self.x = self.x + dx
	self.y = self.y + dy

	for _,p in ipairs(self.p) do
		p.x = p.x + dx
		p.y = p.y + dy
	end
end

function Box:moveTo(x, y)
	local dx, dy = x - self.x, y - self.y
	
	self:translate(dx, dy)
end

function Box:draw(mode)
	if mode == nil then
		mode = self.mode
	end

	if self.angle == 0 then
		EasyLD.graphics:rectangle(mode, self, self.c)
	else
		EasyLD.graphics:polygon(mode, self.c, unpack(self.p))
	end
end

function Box:rotate(angle, ox, oy)
	self.angle = self.angle + angle
	local cos, sin = math.cos(angle), math.sin(angle)
	local mat = Matrix:newRotation(angle)
	local v = Vector:new(self.x - ox, self.y - oy)
	v = mat * v

	self.wP = mat * self.wP
	self.hP = mat * self.hP

	local p = {}
	local w, h = self.wP, self.hP
	table.insert(p, Point:new(v.x + ox, v.y + oy))
	table.insert(p, Point:new(p[1].x + w.x, p[1].y + w.y))
	table.insert(p, Point:new(p[2].x + h.x, p[2].y + h.y))
	table.insert(p, Point:new(p[1].x + h.x, p[1].y + h.y))

	self.p = p
	self.x = p[1].x
	self.y = p[1].y
end

return Box