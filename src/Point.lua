local class = require 'middleclass'

local Point = class('Point')

function Point:initialize(x, y)
	self.x = x
	self.y = y
end

function Point.__add(v1, v2)
	return Point:new(v1.x + v2.x, v1.y + v2.y)
end

function Point.__sub(v1, v2)
	return Point:new(v1.x - v2.x, v1.y - v2.y)
end

function Point.__mul(v1, v2)
	if type(v1) == "number" then
		return Point:new(v1 * v2.x, v1 * v2.y)
	elseif type(v2 == "number") then
		return Point:new(v2 * v1.x, v2 * v1.y)
	else
		return Point:new(v1.x * v2.x, v1.y * v2.y)
	end
end

function Point.__div(v1, v2)
	if type(v1) == "number" then
		return Point:new(v1 / v2.x, v1 / v2.y)
	elseif type(v2) == "number" then
		return Point:new(v2 / v1.x, v2 / v1.y)
	else
		return Point:new(v1.x / v2.x, v1.y / v2.y)
	end
end

function Point.__unm(v1)
	return Point:new(-v1.x, -v1.y)
end

function Point.__eq(v1, v2)
	return v1.x == v2.x and v1.y == v2.y
end

function Point.__lt(v1, v2)
	return v1.x < v2.x and v1.y < v2.y
end

function Point.__le(v1, v2)
	return v1.x <= v2.x and v1.y <= v2.y
end

function Point:copy()
	return Point:new(self.x, self.y)
end

function Point:dot(v)
	return self.x * v.x + self.y * v.y
end

--EasyLD.collide functions
function Point:collide(area)
	return area:collidePoint(self)
end

function Point:collideBox(b)
	if b.angle == 0 then
		return EasyLD.collide:AABB_point(b, self)
	else
		return EasyLD.collide:OBB_point(b, self)
	end
end

function Point:collideCircle(c)
	return EasyLD.collide:Circle_point(c, self)
end

function Point:collidePoint(p)
	return p.x == self.x and p.y == self.y
end

return Point