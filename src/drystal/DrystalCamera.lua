local Camera = {}

function Camera:scale(scale)
	EasyLD.camera.scaleValue = EasyLD.camera.scaleValue + scale
end

function Camera:move(dx, dy, time, ...)
	if EasyLD.camera.mode ~= "normal" then
		local tween = EasyLD.flux.to(EasyLD.camera, time, {x = EasyLD.camera.x + dx, y = EasyLD.camera.y + dy}, ...):ease(EasyLD.camera.mode)
	else
		EasyLD.camera.currentX = EasyLD.camera.currentX + dx
		EasyLD.camera.currentY = EasyLD.camera.currentY + dy
	end
end

function Camera:rotate(angle, ox, oy, time, ...)
	if ox ~= nil and oy ~= nil then

	elseif Camera.follower ~= nil then

	else
		--Camera.ox Camera.oy Currently : rotation around the center of the screen
	end
	if EasyLD.camera.mode ~= "normal" then
		local tween = EasyLD.flux.to(EasyLD.camera, time, {angle = EasyLD.camera.angle + angle}, ...):ease(EasyLD.camera.mode)
	else
		EasyLD.camera.currentAngle = EasyLD.camera.currentAngle + angle
	end
end

function Camera:draw()
	EasyLD.camera.x = EasyLD.camera.currentX + EasyLD.camera.shakeX
	EasyLD.camera.y = EasyLD.camera.currentY + EasyLD.camera.shakeY
	EasyLD.camera.angle = EasyLD.camera.currentAngle + EasyLD.camera.shakeAngle
	drystal.camera.zoom = EasyLD.camera.scaleValue
	drystal.camera.x = -(EasyLD.camera.ox + EasyLD.camera.x)
	drystal.camera.y = -(EasyLD.camera.oy + EasyLD.camera.y)
	drystal.camera.angle = -EasyLD.camera.angle
end

function Camera:actualize()
	drystal.camera.reset()
	Camera:draw()
end

return Camera