local class = require 'middleclass'

local SpriteAnimation = class('SpriteAnimation')

function SpriteAnimation:initialize(pos, area, timeFrames, frames, looping, callback, args)
	self.obj = area
	area:moveTo(pos.x, pos.y)
	self.areaList = {}
	self.timeFrames = timeFrames
	self.frames = frames
	self.looping = looping
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

end

function SpriteAnimation:stop()

end

function SpriteAnimation:play()

end

function SpriteAnimation:nextFrame()
	self.current = self.current + 1
	if self.looping and self.current > #self.frames then
		self.current = 1
	end

	if self.current <= #self.frames then
		for i,v in self.tweenFrame do
			v:stop()
		end

		for i,v in self.frames[self.current] do
			if v.rotation ~= nil then
				EasyLD.flux.to(self.areaList[i], self.timeFrame[self.current], {angle = self.areaList[i].angle + v.rotation}):ease("linear")
			end
			if v.translation ~= nil then
				EasyLD.flux.to(self.areaList[i], self.timeFrame[self.current], {x = self.areaList[i].x + v.translation.x, y = self.areaList[i].y + v.translation.y}):ease("linear")
			end
		end
		--EasyLD.timer.cancel(self.timer)
		self.timer = EasyLD.timer.after(self.timeFrame[self.current], self.nextFrame, self)
	else
		self.callback(unpack(self.args))
	end
end

function SpriteAnimation:draw(mapX, mapY, angle)

end

return SpriteAnimation