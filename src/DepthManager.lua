local class = require 'middleclass'

local DepthManager = class('DepthManager')

function DepthManager:initialize(follower, fct, ratio, before, after)
	self.depth = {}
	local surface = EasyLD.surface:new()
	self.depth[0] = {s = surface, draw = fct, ratio = ratio or 1, offset = EasyLD.point:new(0,0)}
	self.nbBefore = before
	self.nbAfter = after
	self.follower = follower
	self.pos = EasyLD.point:new(follower.x, follower.y)
	self.center = EasyLD.point:new(0,0)
	self.timer2 = nil
end

function DepthManager:follow(obj, mode, time, typeEase)
	if mode == nil then
		self.follower = obj
	else
		self.pos = EasyLD.point:new(self.follower.x, self.follower.y)
		self.follower = obj
		if self.timer2 ~= nil then
			self.timer2:stop()
		end
		self.timer2 = EasyLD.flux.to(self.pos, time or 0.8, {x = self.follower, y = self.follower}, "follower"):ease(typeEase or "quadout"):oncomplete(function()  
																					self.timer2 = nil
																				end)
	end
end

function DepthManager:centerOn(x, y, mode, time, typeEase)
	if mode == nil then
		self.center = EasyLD.point:new(x, y)
	else
		if self.timer ~= nil then
			self.timer:stop()
		end
		self.timer = EasyLD.flux.to(self.center, time or 0.8, {x = x, y = y}):ease(typeEase or "quadout"):oncomplete(function ()
																					self.timer = nil
																				end)
	end
end

function DepthManager:addDepth(id, ratio, fct)
	local surface = EasyLD.surface:new()
	self.depth[id] = {s = surface, draw = fct, ratio = ratio, offset = EasyLD.point:new(0,0)}
end

function DepthManager:update()
	local offset
	if self.timer2 ~= nil then
		offset = EasyLD.point:new(self.pos.x, self.pos.y) - self.center
	else
		offset = EasyLD.point:new(self.follower.x, self.follower.y) - self.center
	end

	for i = self.nbAfter, -self.nbBefore, -1 do
		self.depth[i].offset = offset * self.depth[i].ratio
	end
end

function DepthManager:draw(noScale)
	for i = self.nbAfter, -self.nbBefore, -1 do
		local pos = self.depth[i].offset + self.center - EasyLD.point:new(EasyLD.window.w/2, EasyLD.window.h/2)
		pos.x, pos.y = math.floor(pos.x+0.5), math.floor(pos.y+0.5)

		self.depth[i].s:drawOn(true)
		EasyLD.camera:moveTo(pos.x, pos.y)
		if not noScale then EasyLD.camera:scaleTo(self.depth[i].ratio) end
		EasyLD.camera:actualize()
		self.depth[i].draw()

		EasyLD.camera:scaleTo(1)
		EasyLD.camera:moveTo(0,0)
		EasyLD.camera:actualize(true)
		EasyLD.surface.drawOnScreen()
		self.depth[i].s:draw(0, 0, 0, 0, self.depth[i].s.w, self.depth[i].s.h, 0)
		EasyLD.camera:actualize()
	end
end

return DepthManager