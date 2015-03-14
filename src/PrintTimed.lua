local class = require 'middleclass'

local PrintTimed = class('PrintTimed')

function PrintTimed:initialize(text, font, argsFont, type, time, timeBefore, timeAfter)
	self.text = text
	self.timeBefore = timeBefore or 0
	self.time = time + self.timeBefore
	self.timeAfter = (timeAfter or 0) + time
	self.type = type or "fading"
	self.argsFont = argsFont

	self.currentTime = 0
end

function PrintTimed:update(dt)
	self.currentTime = self.currentTime + dt
end

function PrintTimed:print()
	if self.currentTime < self.timeBefore then

	elseif self.currentTime >= self.timeBefore and self.currentTime < self.time then
		local text = string.sub(self.text, 0, math.floor(self.currentTime / self.time * string.len(self.text)) - 1)
		font:print(text, unpack(self.argsFont))
	elseif self.currentTime >= self.time and self.currentTime < self.timeAfter then
		font:print(text, unpack(self.argsFont))
	else
		font:print(text, unpack(self.argsFont))
	end
end

return PrintTimed