local class = require 'middleclass'

local Particle = class('Particle')

function Particle:initialize(obj, img, x, y, size)
	self.follower = obj
	self.size = size or 256
	if img then
		self.p = love.graphics.newParticleSystem(img, size)
		self:setTexture(img, x, y)
	end
	self.isStopped = false
end

function Particle:start()
	self.p:start()
	self.isStopped = false
end

function Particle:emit(nb)
	local n = self.p:getCount()
	if n + nb > self.size then
		self.size = self.size * 2
		self.p:setBufferSize(self.size)
	end
	self.p:emit(nb)
end

function Particle:stop()
	self.p:stop()
	self.isStopped = true
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
	love.graphics.draw(self.p)
end

function Particle:follow(obj)
	self.follower = obj
end

function Particle:update(dt)
	self:moveTo(self.follower.x, self.follower.y)
	self.p:update(dt)

	local nb = self.p:getCount()
	if nb > self.size * 0.95 then
		self.size = self.size *2
		self.p:setBufferSize(self.size)
	elseif nb < 0.475 * self.size and self.size > 256 then
		self.size = self.size / 2
		self.p:setBufferSize(self.size)
	end
end

function Particle:moveTo(x, y)
	self.p:moveTo(x, y)
end

function Particle:getPosition()
	return EasyLD.point:new(self.p:get_position())
end

function Particle:setDirection(angle, spread)
	self.p:setSpread(spread)
	self.p:setDirection(angle)
end

function Particle:setOffset(x, y)
	self.p:setOffset(x, y)
end

function Particle:getOffset()
	return EasyLD.point:new(self.p:getOffset())
end

function Particle:setSizes(tab)
	local t = {}
	local dist = {1,1,1,1,1,1,1}
	for i,v in pairs(tab) do
		if i == 0 then
			t[1] = v
		elseif i < 3/14 and math.abs(i-1/7) < dist[1] then
			t[2] = v
			dist[1] = math.abs(i-1/7)
		elseif i < 5/14 and math.abs(i-2/7) < dist[2] then
			t[3] = v
			dist[2] = math.abs(i-2/7)
		elseif i < 7/14 and math.abs(i-3/7) < dist[3] then
			t[4] = v
			dist[3] = math.abs(i-3/7)
		elseif i < 9/14 and math.abs(i-4/7) < dist[4] then
			t[5] = v
			dist[4] = math.abs(i-4/7)
		elseif i < 11/14 and math.abs(i-5/7) < dist[5] then
			t[6] = v
			dist[5] = math.abs(i-5/7)
		elseif i < 13/14 and math.abs(i-6/7) < dist[6] then
			t[7] = v
			dist[6] = math.abs(i-6/7)
		elseif math.abs(i - 1) < dist[7] then
			t[8] = v
			dist[7] = math.abs(i-1)
		end
	end
	local prev, next = 0, 0
	for i=1,8 do
		print(t[i])
		if t[i] == nil then
			for j = i+1, 8 do
				if t[j] ~= nil then
					next = j
				end
			end
			if next < i then
				t[i] = t[prev]
			else
				local weight = 1/(i-prev) + 1/(next-i)
				t[i] = (t[prev] * 1/(i-prev) + t[next] * 1/(next-i))/weight
			end
		end
		prev = i
	end
	self.p:setSizes(unpack(t))
	self.t = t
end

function Particle:setColors(tab)
	local t = {}
	local dist = {1,1,1,1,1,1,1}
	for i,v in pairs(tab) do
		if i == 0 then
			t[1] = v
		elseif i < 3/14 and math.abs(i-1/7) < dist[1] then
			t[2] = v
			dist[1] = math.abs(i-1/7)
		elseif i < 5/14 and math.abs(i-2/7) < dist[2] then
			t[3] = v
			dist[2] = math.abs(i-2/7)
		elseif i < 7/14 and math.abs(i-3/7) < dist[3] then
			t[4] = v
			dist[3] = math.abs(i-3/7)
		elseif i < 9/14 and math.abs(i-4/7) < dist[4] then
			t[5] = v
			dist[4] = math.abs(i-4/7)
		elseif i < 11/14 and math.abs(i-5/7) < dist[5] then
			t[6] = v
			dist[5] = math.abs(i-5/7)
		elseif i < 13/14 and math.abs(i-6/7) < dist[6] then
			t[7] = v
			dist[6] = math.abs(i-6/7)
		elseif math.abs(i - 1) < dist[7] then
			t[8] = v
			dist[7] = math.abs(i-1)
		end
	end
	local prev, next = 0, 0
	for i=1,8 do
		if t[i] == nil then
			for j = i+1, 8 do
				if t[j] ~= nil then
					next = j
				end
			end
			if next < i then
				t[i] = t[prev]
			else
				local weight = 1/(i-prev) + 1/(next-i)
				t[i] = {}
				for i,v in ipairs({r,g,b,a}) do
					t[i][v] = (t[prev][v] * 1/(i-prev) + t[next][v] * 1/(next-i))/weight
				end
			end
		end
		prev = i
	end
	tab = {}
	for i,v in ipairs(t) do
		print(v)
		table.insert(tab, v.r)
		table.insert(tab, v.g)
		table.insert(tab, v.b)
		table.insert(tab, v.a)
	end
	self.p:setColors(unpack(tab))
end

function Particle:setTexture(img, x, y)
	if x == nil then
		self.p:setTexture(img)
	else
		local s = EasyLD.surface:new(64, 64)
		local old = s:drawOn()
		EasyLD.camera:push()
		EasyLD.camera:reset()
		img:drawPart(0, 0, x, y, 64, 64)
		self.surface = s
		old:drawOn()
		EasyLD.camera:pop()
		EasyLD.actualize()

		self.p:setTexture(s)
	end
end

function Particle:setEmissionRate(nb)
	self.p:setEmissionRate(nb)
end

function Particle:getEmissionRate()
	return self.p:getEmissionRate()
end

function Particle:setLifeTime(min, max)
	self.p:setParticleLifetime(min, max)
end

function Particle:getLifeTime()
	return self.p:getParticleLifetime()
end

function Particle:setInitialVelocity(nb)
	self.p:setSpeed(nb)
end

function Particle:setInitialAcceleration(nb)
	self.p:setRadialAcceleration(nb)
end


return Particle