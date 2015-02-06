local Collide = {}

local Vector = require 'Vector'
local Matrix = require 'Matrix'
local Point = require 'Point'
local Box = require 'Box'
local Circle = require 'Circle'

local _overlaps1Way = function(b, bAxis, bOrigin)
	for a = 1, 2 do
		local t = b.p[1]:dot(bAxis[a])
		local tMin, tMax = t, t

		for i = 2, 4 do
			t = b.p[i]:dot(bAxis[a])

			if t < tMin then
				tMin = t
			elseif t > tMax then
				tMax = t
			end
		end

		if (tMin > 1 + bOrigin[a]) or (tMax < bOrigin[a]) then
			return false
		end
	end

	return true
end

function Collide:OBB_OBB(b1, b2)
	b1Axis = {}
	b2Axis = {}
	b1Origin = {}
	b2Origin = {}

	table.insert(b1Axis, Vector:of(b1.p[1], b1.p[2]))
	table.insert(b1Axis, Vector:of(b1.p[1], b1.p[4]))
	table.insert(b2Axis, Vector:of(b2.p[1], b2.p[2]))
	table.insert(b2Axis, Vector:of(b2.p[1], b2.p[4]))

	for i = 1, 2 do
		b1Axis[i] = b1Axis[i] / b1Axis[i]:squaredLength()
		b2Axis[i] = b2Axis[i] / b2Axis[i]:squaredLength()
		b1Origin[i] = b1.p[1]:dot(b1Axis[i])
		b2Origin[i] = b2.p[1]:dot(b2Axis[i])
	end

	return _overlaps1Way(b1, b2Axis, b2Origin) and _overlaps1Way(b2, b1Axis, b1Origin)
end

function Collide:OBB_circle(box, circle)
	local v1 = Vector:of(box.p[1], box.p[2])
	local v2 = Vector:of(box.p[1], box.p[4])
	v1:normalize()
	v2:normalize()

	local m = Matrix:newBase(v1, v2):invert()

	local circleP = Point:new(circle.x, circle.y)
	circleP = m * circleP

	local boxP = box.p[1]:copy()
	boxP = m * boxP

	local boxR = Box:new(boxP.x, boxP.y, box.w, box.h)
	local circleR = Circle:new(circleP.x, circleP.y, circle.r)

	return Collide:AABB_circle(boxR, circleR, false)
end

function Collide:OBB_point(box, point)
	b1Axis = {}
	b1Origin = {}

	table.insert(b1Axis, Vector:of(box.p[1], box.p[2]))
	table.insert(b1Axis, Vector:of(box.p[1], box.p[4]))

	for i = 1, 2 do
		b1Axis[i] = b1Axis[i] / b1Axis[i]:squaredLength()
		b1Origin[i] = box.p[1]:dot(b1Axis[i])
	end

	for a = 1, 2 do
		local t = point:dot(b1Axis[a])
		local tMin, tMax = t, t

		if (tMin > 1 + b1Origin[a]) or (tMax < b1Origin[a]) then
			return false
		end
	end

	return true
end

function Collide:AABB_circle(box, circle, boolReturnPos)
	local pos = {}
	pos.x = circle.x
	pos.y = circle.y

	if pos.x > box.x + box.w - 1 then
		pos.x = box.x + box.w - 1
	elseif pos.x < box.x then
		pos.x = box.x
	end
	if pos.y > box.y + box.h - 1 then
		pos.y = box.y + box.h - 1
	elseif pos.y < box.y then
		pos.y = box.y
	end

	local collision = Collide:Circle_point(circle, pos)

	if boolReturnPos then
		return collision, pos
	else
		return collision
	end
end

function Collide:AABB_inCircle(box, circle, boolReturnPos)
	local pos = {}
	
	local collision = true
	local pos = {}
	pos[0] = {x = box.x, y = box.y}
	pos[1] = {x = box.x + box.w-1, y = box.y}
	pos[2] = {x = box.x, y = box.y + box.h-1}
	pos[3] = {x = box.x + box.w, y = box.y + box.h}

	for i = 0, 3 do
		collision = collision and Collide:Circle_point(circle, pos[i])
	end

	if boolReturnPos then
		return collision, pos
	else
		return collision
	end
end

function Collide:AABB_point(box, point)
	return point.x >= box.x and point.x <= box.x + box.w - 1 and 
			point.y >= box.y and point.y <= box.y + box.h - 1 
end

function Collide:AABB_AABB(box1, box2)
	return	box2.x				<= box1.x + box1.w -1
		and box2.x + box2.w -1	>= box1.x 
		and box2.y 				<= box1.y + box1.h -1
		and box2.y + box2.h -1	>= box1.y
end

function Collide:Circle_point(circle, point)
	local v = Vector:of(circle, point)
	return v:length() <= circle.r
end

function Collide:Circle_circle(circle, circle2)
	return Vector:of(circle, circle2):length() < circle.r + circle2.r
end


function Collide:isInAreaLine(pos1, dir, pos2)
	c = - pos1.x * dir.x - pos1.y * dir.y
	return pos2.x * dir.x + pos2.y * dir.y + c >= 0
end


return Collide