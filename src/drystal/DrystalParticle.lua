local class = require 'middleclass'

local Particle = class('Particle')

function Particle:initialize(obj, img, x, y, size)
	self.p = drystal.new_system(obj.x, obj.y, size)
	self.follower = obj
	self.size = size or 256
	self:setTexture(img, x or 0, y or 0)
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
	return newSystem
end

function Particle:draw()
	self.p:draw(0, 0)
end

function Particle:follow(obj)
	self.follower = obj
end

function Particle:update(dt)
	self:moveTo(obj.x, obj.y)
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
	self.p:set_colors(table)
end

function Particle:setTexture(img, x, y)
	self.surface = drystal.load_surface(img)
	self.p:set_texture(self.surface, x or 0, y or 0)
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