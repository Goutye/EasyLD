local Collide = {}

function Collide:AABB_circle(box, circle, boolReturnPos)
	local pos = {}
	pos.x = circle.pos.x
	pos.y = circle.pos.y

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
	local v = EasyLD.vector:of(circle.pos, point)
	return EasyLD.vector:length(v) <= circle.r
end

function Collide:Circle_circle(circle, circle2)
	return EasyLD.vector:length(EasyLD.vector:of(circle.pos, circle2.pos)) < circle.r + circle2.r
end


function Collide:isInAreaLine(pos1, dir, pos2)
	c = - pos1.x * dir.x - pos1.y * dir.y
	return pos2.x * dir.x + pos2.y * dir.y + c >= 0
end


return Collide