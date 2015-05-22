local class = require 'middleclass'

local Particle = class('Particle')

function Particle:initialize(obj, img, x, y, size)
	self.p = drystal.new_system(obj.x, obj.y, size)
	self.follower = obj
	self.size = size or 256
	if img then
		self:setTexture(img, x, y)
	end
end

function Particle:start()
	self.p:start()
end

function Particle:emit(nb)
	self.p:emit(nb or 1)
end

function Particle:stop()
	self.p:stop()
end

function Particle:reset()
	self.p:reset()
end

function Particle:clone()
	local p = self.p:clone()
	local newSystem = Particle:new(self.follower:copy())
	newSystem.p = p
	newSystem.alpha = self.alpha
	return newSystem
end

function Particle:draw()
	drystal.set_alpha(self.alpha)
	self.p:draw(0, 0)
end

function Particle:follow(obj)
	self.follower = obj
end

function Particle:update(dt)
	self:moveTo(self.follower.x, self.follower.y)
	self.p:update(dt)
end

function Particle:moveTo(x, y)
	self.p:set_position(x, y)
end

function Particle:getPosition()
	return EasyLD.point:new(self.p:get_position())
end

function Particle:setDirection(angle, spread)
	spread = spread/2
	angle = -angle
	self.p:set_direction(angle - spread, angle + spread)
end

function Particle:setOffset(x, y)
	self.p:set_offset(x, y)
end

function Particle:getOffset()
	return EasyLD.point:new(self.p:get_offset())
end

function Particle:setSizes(table)
	self.p:set_sizes(table)
end

function Particle:setColors(table)
	local t = {}
	local a = 0
	local c = 0
	for i,v in pairs(table) do
		t[i] = drystal.new_color("rgb", v.r, v.g, v.b)
		if v.a > 0 then
			a = a + v.a
			c = c + 1
		end
	end
	self.p:set_colors(t)
	self.alpha = a/c
end

function Particle:setTexture(img, x, y)
	if x == nil then
		self.p:set_texture(img.s, 0, 0)
	else
		self.surface = drystal.load_surface(img)
		self.p:set_texture(self.surface, x or 0, y or 0)
	end
end

function Particle:setEmissionRate(nb)
	self.p:set_emission_rate(nb)
end

function Particle:getEmissionRate()
	return self.p:get_emission_rate()
end

function Particle:setLifeTime(min, max)
	self.p:set_lifetime(min, max)
end

function Particle:getLifeTime()
	return self.p:get_lifetime()
end

function Particle:setInitialVelocity(nb)
	self.p:set_initial_velocity(nb)
end

function Particle:setInitialAcceleration(nb)
	self.p:set_initial_acceleration(nb)
end

return Particle