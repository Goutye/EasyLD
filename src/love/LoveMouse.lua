local Mouse = {}

function Mouse.getPosition()
	local m = EasyLD.point:new(love.mouse.getPosition())
	m:rotate(EasyLD.camera.angle, EasyLD.window.w/2, EasyLD.window.h/2)
	local p = m - EasyLD.camera:getPosition()
	print(p.x, p.y)
	return p
end

function love.mousepressed(x, y, button)
    EasyLD.mouse:buttonPressed(x,y,button)
end

function love.mousereleased(x, y, button)
    EasyLD.mouse:buttonReleased(x,y,button)
end

return Mouse