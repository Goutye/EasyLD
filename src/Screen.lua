local Screen = {}

function Screen:nextScreen(screen)
	EasyLD.screen.next = screen
end

function Screen:preCalcul(dt)
	return EasyLD.screen.current:preCalcul(dt)
end

function Screen:update(dt)
	if EasyLD.screen.next ~= nil then
		EasyLD.screen.current:onEnd()
		EasyLD.screen.current = EasyLD.screen.next
		EasyLD.screen.next = nil
	end
	EasyLD.screen.current:update(dt)
end

function Screen:draw()
	EasyLD.screen.current:draw()
end

return Screen