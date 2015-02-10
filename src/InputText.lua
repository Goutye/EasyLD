local class = require 'middleclass'

local InputText = class('InputText')

function InputText:initialize(box, colorBack, colorText)
	self.box = box
	self.cBack = colorBack
	self.cText = colorText
end

function InputText:update(dt)
	--all keys azertyuiopqsdgfhfgldsflcxnbw,;vx + MAJ
end

function InputText:draw()
	box:draw("fill", colorBack);
	box:draw("line", colorText);
	--TEXT DRAW
end

return InputText