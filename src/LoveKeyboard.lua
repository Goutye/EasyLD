local Keyboard = {}

function love.keypressed(key)
	if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") and string.byte(key) > 64 and string.byte(key) < 123 then
		key = string.upper(key)
	end

	EasyLD.keyboard:keyPressed(key)
end

function love.keyreleased(key)
	if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") and string.byte(key) >= 65 and string.byte(key) < 123 then
		key = string.upper(key)
	end

	EasyLD.keyboard:keyReleased(key)
end

return Keyboard