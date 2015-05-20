local Camera = {}

function Camera:scale(scale, scaleY)
	EasyLD.camera.scaleValue = EasyLD.camera.scaleValue + scale

	if scaleY ~= nil then
		EasyLD.camera.scaleValueY = (EasyLD.camera.scaleValueY or 1) + scaleY
	else
		EasyLD.camera.scaleValueY = nil
	end

	if EasyLD.camera.auto then
		EasyLD.camera:compute()
		love.graphics.scale(EasyLD.camera.scaleValue, EasyLD.camera.scaleValueY or EasyLD.camera.scaleValue)
	end
end

function Camera:move(dx, dy, time, ...)
	if EasyLD.camera.mode ~= "normal" then
		local tween = EasyLD.flux.to(EasyLD.camera, time, {x = EasyLD.camera.x + dx, y = EasyLD.camera.y + dy}, ...):ease(EasyLD.camera.mode)
	else
		EasyLD.camera.currentX = EasyLD.camera.currentX + dx
		EasyLD.camera.currentY = EasyLD.camera.currentY + dy

		if EasyLD.camera.auto then
			EasyLD.camera:compute()
			love.graphics.translate(-EasyLD.camera.ox - EasyLD.camera.x, -EasyLD.camera.oy - EasyLD.camera.y)
		end
	end
end

function Camera:rotate(angle, ox, oy, time, ...)
	if ox ~= nil and oy ~= nil then
		EasyLD.camera.ox = ox
		EasyLD.camera.oy = oy
	end

	if EasyLD.camera.mode ~= "normal" then
		local tween = EasyLD.flux.to(EasyLD.camera, time, {angle = EasyLD.camera.angle + angle}, ...):ease(EasyLD.camera.mode)
	else
		EasyLD.camera.currentAngle = EasyLD.camera.currentAngle + angle

		if EasyLD.camera.auto then
			EasyLD.camera:compute()
			love.graphics.translate(EasyLD.window.w/2, EasyLD.window.h/2)
			love.graphics.rotate(-EasyLD.camera.angle)
			love.graphics.translate(-EasyLD.window.w/2, -EasyLD.window.h/2)
		end
	end
end

function Camera:draw()
	EasyLD.camera.x = EasyLD.camera.currentX + EasyLD.camera.shakeX + EasyLD.camera.tiltOffset.x
	EasyLD.camera.y = EasyLD.camera.currentY + EasyLD.camera.shakeY + EasyLD.camera.tiltOffset.y
	EasyLD.camera.angle = EasyLD.camera.currentAngle + EasyLD.camera.shakeAngle
	love.graphics.translate(EasyLD.window.w/2, EasyLD.window.h/2)
	love.graphics.rotate(-EasyLD.camera.angle)
	love.graphics.translate(-EasyLD.window.w/2, -EasyLD.window.h/2)
	love.graphics.translate(-EasyLD.camera.ox - EasyLD.camera.x, -EasyLD.camera.oy - EasyLD.camera.y)
	love.graphics.scale(EasyLD.camera.scaleValue, EasyLD.camera.scaleValueY or EasyLD.camera.scaleValue)
end

function Camera:actualize()
	love.graphics.origin()
	Camera:draw()
end

function Camera:push()
	love.graphics.push()
end

function Camera:pop()
	love.graphics.pop()
end

function Camera:reset()
	love.graphics.origin()
end

return Camera