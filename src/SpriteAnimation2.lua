local class = require 'middleclass'

local SpriteAnimation = class('SpriteAnimation')
local AreaFile = require 'Area'

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

function SpriteAnimation:initialize(pos, area, timeFrames, frames, looping, callback, args)
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

function SpriteAnimation:pause()
	EasyLD.timer.cancel(self.timer)
end

function SpriteAnimation:stop()
	EasyLD.timer.cancel(self.timer)
	self.current = 1
end

function SpriteAnimation:play()
	self.timer = EasyLD.timer.after(self.timeFrame[(self.current - 2) % #self.timerFrame + 1], self.nextFrame, self)
end

function SpriteAnimation:nextFrame()
	self.current = self.current + 1
	if self.looping and self.current > #self.frames then
		self.current = 1
	end

	if self.current <= #self.frames then
		for i,v in ipairs(self.tweenFrame) do
			v:stop()
		end

		for i,v in ipairs(self.frames[self.current]) do
			if v.rotation ~= nil then
				EasyLD.flux.to(self.areaList[i], self.timeFrames[self.current], {angle = v.rotation}, "relative"):ease("linear")
			end
			if v.translation ~= nil then
				EasyLD.flux.to(self.areaList[i], self.timeFrames[self.current], {x = v.translation.x, y = v.translation.y}, "relative"):ease("linear")
			end
		end
		--EasyLD.timer.cancel(self.timer)
		self.timer = EasyLD.timer.after(self.timeFrames[self.current], self.nextFrame, self)
	else
		self.callback(unpack(self.args))
	end
end

function SpriteAnimation:draw(mapX, mapY, angle)

end

return SpriteAnimation