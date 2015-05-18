local class = require 'middleclass'

local DepthManager = class('DepthManager')

function DepthManager:initialize(fct, before, after)
	self.x = EasyLD.window.w/2
	self.y = EasyLD.window.h/2
	self.depth = {}
	self.depth[0] = {draw = fct, ratio = 1, pos = EasyLD.point:new(self.x, self.y)}
	self.nbBefore = before
	self.nbAfter = after
	self.follower = nil
end

function DepthManager:follow(obj)
	self.follower = obj
end

function DepthManager:centerOn(x, y)
	for i = self.nbAfter, -self.nbBefore, -1 do
		self.depth[i].pos.x = x
		self.depth[i].pos.y = y
	end
	self.x = x
	self.y = y
end

function DepthManager:addDepth(id, fct, ratio)
	self.depth[id] = {draw = fct, ratio = ratio, pos = EasyLD.point:new(self.x, self.y)}
end

function DepthManager:update()
	local dx, dy = self.follower.x - self.x, self.follower.y - self.y

	for i = self.nbAfter, -self.nbBefore, -1 do
		self.depth[i].pos = self.depth[i].pos + EasyLD.point:new(dx * self.depth[i].ratio, dy * self.depth[i].ratio)
	end

	self.x = self.follower.x
	self.y = self.follower.y
end

function DepthManager:draw()
	for i = self.nbAfter, -self.nbBefore, -1 do
		self.depth[i].draw(self.depth[i].pos, 1/self.depth[i].ratio)
	end
end

return DepthManager