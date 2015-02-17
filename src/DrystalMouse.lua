local Mouse = {}

local drystalTable = {"l", "m", "r", "wu", "wd"}

function Mouse.getPosition()
	return EasyLD.point:new(EasyLD.mouse.x, EasyLD.mouse.y)
end

function drystal.mouse_press(x, y, button)
	EasyLD.mouse:buttonPressed(x,y, drystalTable[button])
end

function drystal.mouse_release(x, y, button)
	EasyLD.mouse:buttonReleased(x,y, drystalTable[button])
end

function drystal.mouse_motion(x, y, dx, dy)
	EasyLD.mouse.x = x
	EasyLD.mouse.y = y
end

EasyLD.mouse.x = 0
EasyLD.mouse.y = 0

return Mouse