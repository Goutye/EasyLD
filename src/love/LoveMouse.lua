local Mouse = {}

function Mouse.getPosition()
	local m = EasyLD.point:new(love.mouse.getPosition())
	local offset = EasyLD.point:new(EasyLD.window.w/2, EasyLD.window.h/2)
	m = m - offset
	m:rotate(EasyLD.camera.angle, 0, 0)
	m = m - EasyLD.camera:getPosition(true)
	m = m / (EasyLD.point:new(EasyLD.camera.scaleValue, EasyLD.camera.scaleValueY or EasyLD.camera.scaleValue))
	return m + offset
end

function love.mousepressed(x, y, button)
    EasyLD.mouse:buttonPressed(x,y,button)
end

function love.mousereleased(x, y, button)
    EasyLD.mouse:buttonReleased(x,y,button)
end

return Mouse