local class = require 'EasyLD.lib.middleclass'

local IScreen = require 'EasyLD.IScreen'
local screenB = class('screenB', IScreen)

function screenB:initialize()
	self.area = EasyLD.area:new(EasyLD.box:new(0,0,80,100))
	point = EasyLD.point:new(50,50)
	self.area:moveTo(300,300)
	self.area:attach(point)
	sign = -1
	self.scale = 1
end

function screenB:preCalcul(dt)
	return dt
end

function screenB:update(dt)
	if EasyLD.mouse:isPressed("l") and self.timer == nil then
		self.timer = EasyLD.flux.to(self.area, 2, {y = sign * 300}, "relative"):ease("bounceinout"):oncomplete(function() 
																							sign = - sign 
																							self.timer = nil
																						end)

	end
end

function screenB:onPause()
	if self.timer then
		self.timer:stop()
		self.timer = nil
	end
end

function screenB:draw()
	EasyLD.box:new(0,0,EasyLD.window.w, EasyLD.window.h, EasyLD.color:new(50,0,50)):draw()
	self.area:draw()
	font:print("B:draw", 16, self.area.forms[1], "center", "center", EasyLD.color:new(0,0,0))
end

function screenB:onEnd()

end

return screenB