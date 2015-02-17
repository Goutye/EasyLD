local class = require 'middleclass'

local Font = class('Font')

Font.static.fonts = {}

function Font.static.print(text, id, size, box, modeW, modeH, color)
	EasyLD.font.fonts[id]:print(text, size, box, modeW, modeH, color)
end

function Font:initialize(src)
	self.src = src
	self.font = {}
	self.color = {}
	table.insert(EasyLD.font.fonts, self)
end

function Font:load(size, color)
	self.font[size] = EasyLD.font.newFont(self.src, size)
	self.color[size] = color or EasyLD.color:new(255,255,255)
end

function Font:print(text, size, box, modeW, modeH, color)
	if self.font[size] == nil then
		self:load(size, color)
	end
	if color ~= nil then
		self.color[size] = color
	end

	EasyLD.font.printAdapter(text, self.font[size], box, modeW, modeH, self.color[size])
end

function Font:printOutLine(text, size, box, modeW, modeH, color, colorOut, thickness)
	if self.font[size] == nil then
		self:load(size, color)
	end
	if color ~= nil then
		self.color[size] = color
	end

	EasyLD.font.printOutLineAdapter(text, self.font[size], box, modeW, modeH, self.color[size], colorOut, thickness)
end

return Font