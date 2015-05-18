local class = require 'middleclass'

local DepthManager = class('DepthManager')

function DepthManager:initialize(fct, ratio, before, after)
	self.depth = {}
	local surface = EasyLD.surface:new()
	self.depth[0] = {s = surface, draw = fct, ratio = ratio or 1, offset = EasyLD.point:new(0,0)}
	self.nbBefore = before
	self.nbAfter = after
	self.follower = nil
end

function DepthManager:follow(obj)
	self.follower = obj
end

function DepthManager:centerOn(x, y)
	self.center = EasyLD.point:new(x, y)
end

function DepthManager:addDepth(id, fct, ratio)
	local surface = EasyLD.surface:new()
	self.depth[id] = {s = surface, draw = fct, ratio = ratio, offset = EasyLD.point:new(0,0)}
end

function DepthManager:update()
	local offset = EasyLD.point:new(self.follower.x, self.follower.y) - self.center

	for i = self.nbAfter, -self.nbBefore, -1 do
		self.depth[i].offset = offset * self.depth[i].ratio
	end
end

function DepthManager:draw()
	for i = self.nbAfter, -self.nbBefore, -1 do --function Surface:draw(x, y, xs, ys, w, h, r)
		local pos = self.depth[i].offset + self.center - EasyLD.point:new(EasyLD.window.w/2, EasyLD.window.h/2)

		print(self.depth[i].offset:get())
		self.depth[i].s:drawOn(true)
		EasyLD.camera:moveTo(pos.x, pos.y)
		self.depth[i].draw()

		EasyLD.camera:moveTo(0,0)
		EasyLD.surface.drawOnScreen()
		self.depth[i].s:draw(0, 0, 0, 0, self.depth[i].s.w, self.depth[i].s.h, 0)
	end
end

return DepthManager