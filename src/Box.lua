local class = require 'middleclass'

local Point = require 'Point'
local Vector = require 'Vector'
local Matrix = require 'Matrix'

local Shape = require 'Shape'

local Box = class('Box', Shape)

function Box:initialize(x, y, w, h, c, mode)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.c = c
	self.mode = mode or "fill"
	self.angle = 0

	local p = {}
	table.insert(p, Point:new(self.x, self.y))
	table.insert(p, Point:new(p[1].x + w, p[1].y))
	table.insert(p, Point:new(p[2].x, p[2].y + h))
	table.insert(p, Point:new(p[1].x, p[1].y + h))

	self.p = p
	self.wP = Vector:new(self.w, 0)
	self.hP = Vector:new(0, self.h)

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
	local b = Box:new(self.x, self.y, self.w, self.h, self.c:copy(), self.mode)
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

	if self.img == nil then
		if self.angle == 0 then
			EasyLD.graphics:rectangle(mode, self, self.c)
		else
			EasyLD.graphics:polygon(mode, self.c, unpack(self.p))
		end
	else
		if self.imgType == "center" then
			local x = self.x + self.wP.x/2 - self.img.w/2 + self.hP.x/2
			local y = self.y + self.hP.y/2 - self.img.h/2 + self.hP.y/2
			self.img:draw(x, y, self.angle)
		else
			self.img:draw(self.x, self.y, self.angle)
		end
	end
end

function Box:rotate(angle, ox, oy)
	self.angle = self.angle + angle
	local point = EasyLD.point:new(self.x, self.y)
	local mat = Matrix:newRotation(angle)
	point:rotate(angle, ox, oy)

	self.wP = mat * self.wP
	self.hP = mat * self.hP

	local p = {}
	local w, h = self.wP, self.hP
	table.insert(p, Point:new(point.x, point.y))
	table.insert(p, Point:new(p[1].x + w.x, p[1].y + w.y))
	table.insert(p, Point:new(p[2].x + h.x, p[2].y + h.y))
	table.insert(p, Point:new(p[1].x + h.x, p[1].y + h.y))

	self.p = p
	self.x = p[1].x
	self.y = p[1].y
end

--EasyLD.collide functions
function Box:collide(area)
	return area:collideBox(self)
end

function Box:collideArea(area)
	return area:collideBox(self)
end

function Box:collidePolygon(poly)
	return EasyLD.collide:Polygon_OBB(poly, self)
end

function Box:collideBox(b)
	if self.angle == 0 and area.angle == 0 then
		return EasyLD.collide:AABB_AABB(self, b)
	else
		return EasyLD.collide:OBB_OBB(self, b)
	end
end

function Box:collideCircle(c)
	if self.angle == 0 then
		return EasyLD.collide:AABB_circle(self, c)
	else
		return EasyLD.collide:OBB_circle(self, c)
	end
end

function Box:collideSegment(s)
	return EasyLD.collide:OBB_segment(self, s)
end

function Box:collidePoint(p)
	if self.angle == 0 then
		return EasyLD.collide:AABB_point(self, p)
	else
		return EasyLD.collide:OBB_point(self, p)
	end
end

return Box