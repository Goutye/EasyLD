local Keyboard = {}

function love.keypressed(key)
	EasyLD.keyboard:keyPressed(key)
end

function love.keyreleased(key)
	EasyLD.keyboard:keyReleased(key)
end

return Keyboard