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

return Point