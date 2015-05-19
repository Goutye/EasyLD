local Camera = {}

Camera.scaleValue = 1
Camera.scaleValueY = nil
Camera.x = 0
Camera.y = 0
Camera.currentX = 0
Camera.currentY = 0
Camera.currentAngle = 0
Camera.dx = 0
Camera.dy = 0
Camera.ox = 0
Camera.oy = 0
Camera.shakeX = 0
Camera.shakeY = 0
Camera.shakeAngle = 0
Camera.follower = nil
Camera.angle = 0
Camera.mode = "normal"
Camera.auto = false
Camera.shakeDuration = 0

function Camera:setMode(mode)
	EasyLD.camera.mode = mode
end

function Camera:setAuto(bool)
	EasyLD.camera.auto = bool
end

function Camera:scaleTo(scale, scaleY)
	EasyLD.camera:scale(scale - EasyLD.camera.scaleValue, (scaleY or scale) - (Camera.scaleValueY or Camera.scaleValue))
end

function Camera:scale(scale, scaleY)
	
end

function Camera:moveTo(x, y)
	EasyLD.camera:move(x - EasyLD.camera.currentX, y - EasyLD.camera.currentY)
end

function Camera:move(x, y)

end

function Camera:rotateTo(angle, ox, oy)
	EasyLD.camera:rotate(angle - EasyLD.camera.currentAngle, ox, oy)
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
	if EasyLD.camera.shakeDuration > 0 then
		EasyLD.camera.shakeDuration = EasyLD.camera.shakeDuration - dt
		EasyLD.camera:makeShake(EasyLD.camera.shakeVars)
		EasyLD.camera.currentX = EasyLD.camera.shakeOld.x
		EasyLD.camera.currentY = EasyLD.camera.shakeOld.y
		EasyLD.camera.currentAngle = EasyLD.camera.shakeOld.angle
	elseif EasyLD.camera.shakeOld ~= nil then
		local old = EasyLD.camera.shakeOld
		if old.x ~= nil then
			EasyLD.camera.shakeX = 0
		end
		if old.y ~= nil then
			EasyLD.camera.shakeY = 0
		end
		if old.angle ~= nil then
			EasyLD.camera.shakeAngle = 0
		end

		EasyLD.camera.shakeOld = nil
	end
end

function Camera:compute()
	EasyLD.camera.x = EasyLD.camera.currentX + EasyLD.camera.shakeX
	EasyLD.camera.y = EasyLD.camera.currentY + EasyLD.camera.shakeY
	EasyLD.camera.angle = EasyLD.camera.currentAngle + EasyLD.camera.shakeAngle
end

function Camera:getPosition()
	local p = EasyLD.point:new(-EasyLD.camera.ox - EasyLD.camera.x, -EasyLD.camera.oy - EasyLD.camera.y)
	return p
end

function Camera:shake(vars, duration, typeEase)
	EasyLD.camera.shakeVars = vars
	EasyLD.camera.shakeDuration = duration
	EasyLD.camera.shakeOld = {x = EasyLD.camera.x, y = EasyLD.camera.y, angle = EasyLD.camera.angle}
	if vars.x == nil then vars.x = 0.01 end
	if vars.y == nil then vars.y = 0.01 end
	if vars.angle == nil then vars.angle = 0.001 end
	EasyLD.camera.shakeTimer = EasyLD.flux.to(EasyLD.camera.shakeVars, duration, {x = 0, y = 0, angle = 0}):ease(typeEase or "quadin")
end

function Camera:makeShake(vars)
	if vars.x ~= nil then
		EasyLD.camera.shakeX = math.random(-vars.x, vars.x)
	end
	if vars.y ~= nil then
		EasyLD.camera.shakeY = math.random(-vars.y, vars.y)
	end
	if vars.angle ~= nil then
		EasyLD.camera.shakeAngle = (math.random() - 0.5) * vars.angle
	end
end

return Camera