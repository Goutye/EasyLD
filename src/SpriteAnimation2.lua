local class = require 'middleclass'
local AreaFile = require 'Area'

local SA = class('SA')

local function exploreArea(area)
	local areaList = {}
	for i,v in ipairs(area.forms) do
		if v:isInstanceOf(AreaFile) then
			table.insert(areaList, v)
			local tab = { exploreArea(v) }

			for i2,v2 in ipairs(tab) do
				table.insert(areaList, v2)
			end
		end
	end

	return unpack(areaList)
end

function SA:initialize(pos, area, timeFrames, frames, looping, callback, args)
	self.obj = area
	area:moveTo(pos.x, pos.y)
	self.timeFrames = timeFrames
	self.frames = frames
	self.looping = looping
	self.areaList = { exploreArea(area) }
	--Init ->	loading of all shapes
	--			list of all area
	--			create a list of transformation in area
	--A point is where an area is "attached".  (follow for rotation)
	--EASY EASY EASY translation OR rotation cascade.
	--Frame : Each frame contains two moves : Translation/Rotation
	--callback end of animation
	self.frameTween = {}
	self.current = 1
	self.timer = nil

	self.callback = callback
	self.args = args
	self.shouldStop = false
end

function SA:pause()
	for i,v in ipairs(self.frameTween) do
		v:stop()
	end
end

function SA:stop()
	self.shouldStop = true
end

function SA:play()
	if self.shouldStop then
		self.shouldStop = false
	elseif #self.frameTween > 0 then
		for i,v in ipairs(self.frameTween) do
			v:play()
		end
	else
		self:nextFrame()
	end
end

function SA:nextFrame()
	if self.looping and self.current > #self.frames then
		self.current = 1
		if self.shouldStop then
			self.shouldStop = false
			return
		end
	end

	self.frameTween = {}
	

	if self.current <= #self.frames then
		for i,v in ipairs(self.frames[self.current]) do
			local easeFct = "linear"
			local vars = {}
			if v.rotation ~= nil then
				vars.angle = v.rotation
			end
			if v.translation ~= nil then
				vars.x = v.translation.x
				vars.y = v.translation.y
			end

			if v.ease ~= nil then
				easeFct = v.ease
			end

			local tween = EasyLD.flux.to(self.areaList[i], self.timeFrames[self.current], vars, "relative", "relative"):ease(easeFct)

			if i == 1 then
				self.areaList[i].SA = self
				tween:oncomplete(function(obj)
									obj.SA:nextFrame()
								end)
			end

			table.insert(self.frameTween, tween)
		end
	else
		self.callback(unpack(self.args))
	end
	self.current = self.current + 1
end

function SA:draw(mapX, mapY, angle)
	self.obj:draw()
end

return SA