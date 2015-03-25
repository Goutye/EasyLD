function drystal.init()
	EasyLD:load()
end

function drystal.update(dt)
	EasyLD:update(dt)
	EasyLD:updateComponents(dt)
end

function drystal.draw()
	EasyLD:draw()
end
