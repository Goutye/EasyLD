local class = require 'middleclass'

local InputText = class('InputText')

function InputText:initialize(box, colorBack, colorText, charLimit)
	self.box = box
	self.cBack = colorBack
	self.cText = colorText
	self.text = ""
	self.lastKey = nil
	self.focus = false
	self.nbChar = charLimit or 10
end

function InputText:update(dt)
	if EasyLD.mouse:isPressed("l") then
		if EasyLD.collide:AABB_point(self.box, EasyLD.mouse:getPosition()) then
			self.focus = true
		else
			self.focus = false
		end
	end

	if self.focus then
		local key = EasyLD.keyboard:lastKeyPressed()

		if key ~= nil and self.lastKey ~= key then
			if string.len(key) == 1 and string.utf8len(self.text) < self.nbChar then
				self.text = self.text .. (EasyLD.keyboard.lastChar or key)
			elseif key == "backspace" then
				if string.utf8len(self.text) == 1 then
					self.text = ""
				else
					self.text = string.utf8sub(self.text, 0, -2)
				end
			end

			self.lastKey = key
		elseif self.lastKey ~= nil and EasyLD.keyboard:isReleased(self.lastKey) then
			self.lastKey = nil
		end
	end
end

function InputText:draw()
	self.box.c = self.cBack
	self.box:draw("fill")
	self.box.c = self.cText
	self.box:draw("line")
	love.graphics.print(self.text, self.box.x + 5, self.box.y + self.box.h / 2 - 3)
	--TEXT DRAW
end

return InputText