local Camera = {}

Camera.scaleValue = 1
Camera.scaleValueY = nil
Camera.x = 0
Camera.y = 0
Camera.dx = 0
Camera.dy = 0
Camera.ox = 0
Camera.oy = 0
Camera.follower = nil
Camera.angle = 0
Camera.mode = "normal"

function Camera:setMode(mode)
	EasyLD.camera.mode = mode
end

function Camera:scaleTo(scale, scaleY)
	EasyLD.camera:scale(scale - EasyLD.camera.scaleValue, (scaleY or scale) - (Camera.scaleValueY or Camera.scaleValue))
end

function Camera:scale(scale, scaleY)
	
end

function Camera:moveTo(x, y)
	EasyLD.camera:move(x - EasyLD.camera.x, y - EasyLD.camera.y)
end

function Camera:move(x, y)

end

function Camera:rotateTo(angle, ox, oy)
	EasyLD.camera:rotate(angle - EasyLD.camera.angle, ox, oy)
end

function Camera:rotate(angle, ox, oy)

end

function Camera:follow(obj)
	EasyLD.camera.follower = obj
end

function Camera:update(dt)
	if EasyLD.camera.follower ~= nil then
		local f = EasyLD.camera.follower
		EasyLD.camera.ox = f.x
		EasyLD.camera.oy = f.y
	end
end

function Camera:getPosition()
	local p = EasyLD.point:new(-EasyLD.camera.ox - EasyLD.camera.x, -EasyLD.camera.oy - EasyLD.camera.y)
	return p
end

return Camera