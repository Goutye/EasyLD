local class = require 'EasyLD.lib.middleclass'

local IScreen = require 'EasyLD.IScreen'
local screenA = class('screenA', IScreen)

function screenA:initialize()
	self.area = EasyLD.area:new(EasyLD.box:new(-99999,-99999,100,100))
	self.area.display = true
	self.area3 = self.area:copy()
	self.area3:attach(EasyLD.point:new(150,150, false))
	self.area3:moveTo(400,300)
	self.area2 = EasyLD.area:new(EasyLD.box:new(1,1,100,100, EasyLD.color:new(255,0,0)))
	self.area2:attach(self.area)
	self.sfx = EasyLD.sfx:new("assets/bloop.wav", 0.5)
end

function screenA:preCalcul(dt)
	return dt
end

function screenA:update(dt)
	self.area:moveTo(EasyLD.mouse:getPosition():get())

	if EasyLD.mouse:isPressed("l") then
		self.area.display = not self.area.display
		self.sfx:play()
	end

	if self.area3:collide(self.area) then
		self.area3.forms[1].c = EasyLD.color:new(0,255,0)
	else
		self.area3.forms[1].c = EasyLD.color:new(255,255,255)
	end
end

function screenA:draw()
	EasyLD.box:new(0,0,EasyLD.window.w, EasyLD.window.h, EasyLD.color:new(0,100,100)):draw()
	self.area2:draw()
	font:print("A:draw", 16, self.area2.forms[1], "center", "center", EasyLD.color:new(255,255,255))
	font:print("A:draw", 16, self.area.forms[1], "center", "center", EasyLD.color:new(0,0,0))
	
	self.area3:draw()
	font:print("A:draw", 16, self.area3.forms[1], "center", "center", EasyLD.color:new(0,0,0))
end

function screenA:onEnd()

end

return screenA