local Camera = {}

function Camera:scale(scale, scaleY)
	EasyLD.camera.scaleValue = EasyLD.camera.scaleValue + scale

	if scaleY ~= nil then
		EasyLD.camera.scaleValueY = (Camera.scaleValueY or 1) + scaleY
	end
end

function Camera:move(dx, dy)
	EasyLD.camera.x = EasyLD.camera.x + dx
	EasyLD.camera.y = EasyLD.camera.y + dy
end

function Camera:rotate(angle, ox, oy)
	if ox ~= nil and oy ~= nil then
		EasyLD.camera.ox = ox
		EasyLD.camera.oy = oy
	end

	EasyLD.camera.angle = EasyLD.camera.angle + angle
end

function Camera:draw()
	love.graphics.translate(EasyLD.window.w/2, EasyLD.window.h/2)
	love.graphics.rotate(-EasyLD.camera.angle)
	love.graphics.translate(-EasyLD.window.w/2, -EasyLD.window.h/2)
	love.graphics.translate(-EasyLD.camera.ox - EasyLD.camera.x, -EasyLD.camera.oy - EasyLD.camera.y)
	love.graphics.scale(EasyLD.camera.scaleValue, EasyLD.camera.scaleValueY or EasyLD.camera.scaleValueY)
end

return Camera