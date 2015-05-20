local class = require 'middleclass'

local Surface = class('Surface')

Surface.table = {}

function Surface.drawOnScreen()
	drystal.screen:draw_on()
end

function Surface:initialize(w, h)
	self.w = w or EasyLD.window.w
	self.h = h or EasyLD.window.h
	self.s = drystal.new_surface(self.w,self.h)
	EasyLD.surface.table[self.s] = self
end

function Surface:drawOn(clear)
	if clear then self:clear() end
	local s = self.s:draw_on()
	if EasyLD.surface.table[s] == nil then
		local surf = Surface:new()
		surf.s = s
		EasyLD.surface.table[s] = surf
		return surf
	else
		return EasyLD.surface.table[s]
	end
end

function Surface:draw(x, y, xs, ys, w, h, r)
	self.s:draw_from()
	drystal.draw_sprite_rotated({x=xs, y=ys, w=w or self.s.w, h=h or self.s.h}, x, y, r or 0)
end

function Surface:setFilter(type)
	self.s:set_filter(drystal.filters[type])
end

function Surface:getPixel(x, y)
	return EasyLD.color:new(self.s:get_pixel(x,y))
end

function Surface:clear()
	local old = self.s:draw_on()
	drystal.set_alpha(0)
	drystal.draw_background()
	drystal.set_color(255, 255, 255)
	drystal.set_alpha(255)
	old:draw_on()
end

return Surface