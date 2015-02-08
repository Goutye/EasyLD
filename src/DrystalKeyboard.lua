local Keyboard = {}

function drystal.key_press(key)
	EasyLD.keyboard:keyPressed(key)
end

function drystal.key_release(key)
	EasyLD.keyboard:keyReleased(key)
end

return Keyboard