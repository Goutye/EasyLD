function love.load()
	EasyLD:load()
end

function love.update(dt)
	dt = EasyLD:preCalcul(dt)
	dt = EasyLD:preCalculScreen(dt)
	if EasyLD.screen.current then
		EasyLD.screen:update(dt)
	end
	EasyLD:update(dt)
	EasyLD:updateComponents(dt)
end

function love.draw()
	EasyLD.camera:draw()
	if EasyLD.screen.current then
		EasyLD.screen:draw()
	end
	EasyLD:draw()
end