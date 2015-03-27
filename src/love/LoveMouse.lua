local Mouse = {}

function Mouse.getPosition()
	return EasyLD.point:new(love.mouse.getPosition())
end

function love.mousepressed(x, y, button)
    EasyLD.mouse:buttonPressed(x,y,button)
end

function love.mousereleased(x, y, button)
    EasyLD.mouse:buttonReleased(x,y,button)
end

return Mouse