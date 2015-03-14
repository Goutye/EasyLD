local class = require 'middleclass'
local Shape = class('Shape')

function Shape:initialize()
end

function Shape:attachImg(img, imgType)
	self.img = img
	self.imgType = imgType
end

return Shape