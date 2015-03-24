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
	self.tweenFrame = {}
	self.current = 1
	self.timer = nil

	self.callback = callback
	self.args = args
end

function SA:pause()
	EasyLD.timer.cancel(self.timer)
end

function SA:stop()
	EasyLD.timer.cancel(self.timer)
	self.current = 1
end

function SA:play()
	self:nextFrame()
end

function SA:nextFrame()
	if self.looping and self.current > #self.frames then
		self.current = 1
	end
	if self.current <= #self.frames then
		for i,v in ipairs(self.frames[self.current]) do
			local vars = {}
			if v.rotation ~= nil then
				vars.angle = v.rotation
			end
			if v.translation ~= nil then
				vars.x = v.translation.x
				vars.y = v.translation.y
			end
			
			local tween = EasyLD.flux.to(self.areaList[i], self.timeFrames[self.current], vars, "relative", "relative"):ease("linear")

			if i == 1 then
				self.areaList[i].SA = self
				tween:oncomplete(function(obj)
									obj.SA:nextFrame()
								end)
			end
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