local class = require 'middleclass'

local Image = require 'AdapterImage'

local LoveImage = class('LoveImage', Image)

function LoveImage:initialize(src, filter1, filter2)
	self.src = love.graphics.newImage(src)
	self.w = self.src:getWidth()
	self.h = self.src:getHeight()

	if filter1 == nil then
		self.src:setFilter("nearest", "linear")
	elseif filter2 == nil then
		self.src:setFilter(filter1, "linear")
	else
		self.src:setFilter(filter1, filter2)
	end

	self.id = {}
	self.quad = {}
	self.batch = love.graphics.newSpriteBatch(self.src, 1)
end

function LoveImage:draw(x, y, r, sx, sy, ox, oy, kx, ky)
	love.graphics.draw(self.src, x, y, r, sx, sy, ox, oy, kx, ky)
end

function LoveImage:drawPart(mapX, mapY, x, y, w, h, id)
	if id ~= nil then
		if self.id[id] == nil then
			self.id[id] = true
			self.quad[id] = love.graphics.newQuad(x, y, w, h, self.w, self.h)
		end

		self.batch:bind()
		self.batch:clear()
		self.batch:add(self.quad[id], mapX, mapY)
		self.batch:unbind()

		love.graphics.draw(self.batch, 0, 0)
	else
		local quad = love.graphics.newQuad(x, y, w, h, self.w, self.h)
		local batch = love.graphics.newSpriteBatch(self.src, 1)
		batch:bind()
		batch:clear()
		batch:add(quad, mapX, mapY)
		batch:unbind()

		love.graphics.draw(batch, 0, 0)
	end
end

return LoveImage