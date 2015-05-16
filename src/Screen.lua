local Screen = {}
Screen.alpha = 0
Screen.box = nil

function Screen:nextScreen(screen, time, type, pause)
	if EasyLD.screen.current == nil then
		EasyLD.screen.current = screen
		EasyLD.screen.box = EasyLD.box:new(0, 0, EasyLD.window.w, EasyLD.window.h, EasyLD.color:new(0,0,0,255))
	else
		EasyLD.screen.next = screen
		EasyLD.screen.nextType = type or "quad"
		EasyLD.screen.nextTime = time or 0.01
		EasyLD.screen.nextPause = pause
	end
end

function Screen:preCalcul(dt)
	return EasyLD.screen.current:preCalcul(dt)
end

function Screen:update(dt)
	if EasyLD.screen.next ~= nil and EasyLD.screen.timer == nil then
		local typeEase = EasyLD.screen.nextType
		if EasyLD.screen.nextType ~= "linear" then
			typeEase = typeEase .. "in"
		end
		EasyLD.screen.timer = EasyLD.flux.to(EasyLD.screen, EasyLD.screen.nextTime/2, {alpha = 255}):ease(typeEase):oncomplete(function () EasyLD.screen:changeScreen() end)
	end
	if not EasyLD.screen.nextPause then
		EasyLD.screen.current:update(dt)
	end
	print(EasyLD.screen.alpha)
end

function Screen:changeScreen()
	local typeEase = EasyLD.screen.nextType
	if EasyLD.screen.nextType ~= "linear" then
		typeEase = typeEase .. "out"
	end

	EasyLD.screen.timer = EasyLD.flux.to(EasyLD.screen, EasyLD.screen.nextTime/2, {alpha = 0}):ease(typeEase):oncomplete(function () EasyLD.screen.timer = nil end)
	EasyLD.screen.current:onEnd()
	EasyLD.screen.current = EasyLD.screen.next
	EasyLD.screen.next = nil
	EasyLD.screen.nextType = nil
	EasyLD.screen.nextTime = nil
	EasyLD.screen.nextPause = nil
end

function Screen:draw()
	EasyLD.screen.current:draw()
	EasyLD.screen.box.c.a = EasyLD.screen.alpha
	EasyLD.screen.box:draw()
end

return Screen