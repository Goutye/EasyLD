local class = require 'middleclass'

local Image = require 'AdapterImage'

local DrystalImage = class('DrystalImage', Image)

function DrystalImage:initialize(src, filter)
	self.src = assert(drystal.load_surface(src))
	self.w = self.src.w
	self.h = self.src.h

	if filter == "linear" then
		self.src.set_filter(drystal.filters.linear)
	elseif filter == "nearest" then
		self.src.set_filter(drystal.filters.nearest)
	elseif filter == "bilinear" then
		self.src.set_filter(drystal.filters.bilinear)
	elseif filter == "trilinear" then
		self.src.set_filter(drystal.filters.trilinear)
	end
end

function DrystalImage:draw(x, y)
	self.src:draw_from()
	drystal.draw_image(0, 0, self.w, self.h, x, y)
end

function DrystalImage:drawPart(mapX, mapY, x, y, w, h)
	self.src:draw_from()
	drystal.draw_image(x, y, w, h, mapX, mapY)
end

return DrystalImage