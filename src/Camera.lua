local Camera = {}

function Camera.init(x, y, w, h, follower, mode, ox, oy)
	Camera.scale = 1
	Camera.x = x or 0
	Camera.y = y or 0
	Camera.w = w or
	Camera.h = h
	Camera.ox = ox or x
	Camera.oy = oy or y
	Camera.mode = mode
	Camera.follower = follower
	Camera.angle = 0
end

function Camera.scaleTo(scale)
	Camera.scale(scale - Camera.scale)
end

function Camera.scale(scale)

end

function Camera.moveTo(x, y)
	Camera.move(x - Camera.x, y - Camera.y)
end

function Camera.move(x, y)

end

function Camera.rotateTo(angle, ox, oy)
	Camera.rotate(angle - Camera.angle, ox, oy)
end

function Camera.rotate(angle, ox, oy)
	if ox ~= nil and oy ~= nil then

	elseif Camera.follower ~= nil then

	else
		--Camera.ox, Camera.oy
	end
end

--Goal => Drystal camera || love rotation/translate

return Camera