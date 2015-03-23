--
-- flux
--
-- Copyright (c) 2014, rxi
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--
--
-- Modified by Goutye for Shapes compatibility. 2015
--

local Shape = require 'Shape'
local Vector = require 'Vector'
local Point = require 'Point'

local flux = { _version = "0.1.4" }
flux.__index = flux

flux.tweens = {}
flux.easing = { linear = function(p) return p end }

local easing = {
	quad		= "p * p",
	cubic	 = "p * p * p",
	quart	 = "p * p * p * p",
	quint	 = "p * p * p * p * p",
	expo		= "2 ^ (10 * (p - 1))",
	sine		= "-math.cos(p * (math.pi * .5)) + 1",
	circ		= "-(math.sqrt(1 - (p * p)) - 1)",
	back		= "p * p * (2.7 * p - 1.7)",
	elastic = "-(2^(10 * (p - 1)) * math.sin((p - 1.075) * (math.pi * 2) / .3))"
}

local makefunc = function(str, expr)
	local load = loadstring or load
	return load("return function(p) " .. str:gsub("%$e", expr) .. " end")()
end

for k, v in pairs(easing) do
	flux.easing[k .. "in"] = makefunc("return $e", v)
	flux.easing[k .. "out"] = makefunc([[
		p = 1 - p
		return 1 - ($e)
	]], v)
	flux.easing[k .. "inout"] = makefunc([[
		p = p * 2 
		if p < 1 then
			return .5 * ($e)
		else
			p = 2 - p
			return .5 * (1 - ($e)) + .5
		end 
	]], v)
end



local tween = {}
tween.__index = tween

local function makefsetter(field)
	return function(self, x)
		local mt = getmetatable(x)
		if type(x) ~= "function" and not (mt and mt.__call) then
			error("expected function or callable", 2)
		end
		local old = self[field]
		self[field] = old and function() old() x() end or x
		return self
	end
end

local function makesetter(field, checkfn, errmsg)
	return function(self, x)
		if checkfn and not checkfn(x) then
			error(errmsg:gsub("%$x", tostring(x)), 2)
		end
		self[field] = x
		return self
	end
end

tween.ease	= makesetter("_ease",
								function(x) return flux.easing[x] end,
								"bad easing type '$x'")
tween.delay = makesetter("_delay",
								function(x) return type(x) == "number" end,
								"bad delay time; expected number")
tween.onstart		= makefsetter("_onstart")
tween.onupdate		= makefsetter("_onupdate")
tween.oncomplete	= makefsetter("_oncomplete")


function tween.new(obj, time, vars, mode)
	local self = setmetatable({}, tween)
	self.obj = obj
	self.rate = time > 0 and 1 / time or 0
	self.progress = time > 0 and 0 or 1
	self._delay = 0
	self._ease = "quadout"
	self.vars = {}
	self.varPrev = {}
	self.mode = mode or "absolute"
	for k, v in pairs(vars) do
		if type(v) ~= "number" then
			error("bad value for key '" .. k .. "'; expected number")
		end
		self.vars[k] = v
	end
	return self
end


function tween:init()
	for k, v in pairs(self.vars) do
		local x = self.obj[k]
		if type(x) ~= "number" then
			error("bad value on object key '" .. k .. "'; expected number")
		end
		if self.mode == "relative" then
			self.vars[k] = { start = 0, diff = v }
		else
			self.vars[k] = { start = x, diff = v - x }
		end
	end
	self.inited = true
end


function tween:after(...)
	local t
	if select("#", ...) == 2 then
		t = tween.new(self.obj, ...)
	else
		t = tween.new(...)
	end
	t.parent = self.parent
	self:oncomplete(function() flux.add(self.parent, t) end)
	return t
end


function tween:stop()
	flux.remove(self.parent, self)
end



function flux.group()
	return setmetatable({}, flux)
end


function flux:to(obj, time, vars, mode)
	return flux.add(self, tween.new(obj, time, vars, mode))
end


function flux:update(deltatime)
	for i = #self, 1, -1 do
		local t = self[i]
		if t._delay > 0 then
			t._delay = t._delay - deltatime
		else
			if not t.inited then
				flux.clear(self, t.obj, t.vars)
				t:init()
			end
			if t._onstart then
				t._onstart()
				t._onstart = nil
			end
			t.progress = t.progress + t.rate * deltatime 
			local p = t.progress
			local x = p >= 1 and 1 or flux.easing[t._ease](p)
			if t.obj:isInstanceOf(Shape) then
				if (t.vars.x ~= nil or t.vars.y ~= nil) and t.vars.angle ~= nil then
					if t.varPrev.angle == nil then
						local vect = Vector:new(t.vars.x.diff or 0, t.vars.y.diff or 0)
						t.varsTemp = {r = {diff = vect:length()} }
						t.varPrev.r = 0
						t.varPrev.angle = 0
					end
					local r = x * t.varsTemp.r.diff
					local angle = x * t.vars.angle.diff
					local point = Point:new(t.obj.x, t.obj.y)
					point:rotate(angle - t.varPrev.angle, t.obj.follower.x, t.obj.follower.y)
					local vecto = Vector:of(point, Point:new(t.obj.follower.x, t.obj.follower.y))
					vecto:normalize()
					local dx, dy =  vecto.x * r - vecto.x * t.varPrev.r, vecto.y * r - vecto.y * t.varPrev.r
					t.obj:rotate(angle - t.varPrev.angle)
					t.obj:translate(dx, dy)
					
					t.varPrev.r = r
					t.varPrev.angle = angle
				else
					for k, v in pairs(t.vars) do
						if k == "x" then
							if t.varPrev[k] == nil then
								t.varPrev[k] = 0
							end
							local xvDif = x * v.diff
							t.obj:translate(xvDif - t.varPrev[k], 0)
							t.varPrev[k] = xvDif
						elseif k == "y" then
							if t.varPrev[k] == nil then
								t.varPrev[k] = 0
							end
							local xvDif = x * v.diff
							t.obj:translate(0, xvDif - t.varPrev[k])
							t.varPrev[k] = xvDif
						elseif k == "angle" then
							if t.varPrev[k] == nil then
								t.varPrev[k] = 0
							end
							local xvDif = x * v.diff
							t.obj:rotate(xvDif - t.varPrev[k])
							t.varPrev[k] = xvDif
						else
							if t.mode == "relative" then
								if t.varPrev[k] == nil then
									t.varPrev[k] = 0
								end
								print(k)
								print(t.obj)
								local xDif = x * v.diff
								print(t.obj[k], xDif, t.varPrev[k])
								t.obj[k] = t.obj[k] + xDif - t.varPrev[k]
								t.varPrev[k] = xDif
							else
								t.obj[k] = v.start + x * v.diff
							end
						end
					end
				end
			else
				for k, v in pairs(t.vars) do
					if t.mode == "relative" then
						if t.varPrev[k] == nil then
							t.varPrev[k] = 0
						end
						local xDif = x * v.diff
						t.obj[k] = t.obj[k] + xDif - t.varPrev[k]
						t.varPrev[k] = xDif
					else
						t.obj[k] = v.start + x * v.diff
					end
				end
			end
			if t._onupdate then t._onupdate(t.obj) end
			if p >= 1 then
				flux.remove(self, i)
				if t._oncomplete then t._oncomplete(t.obj) end
			end
		end
	end
end


function flux:clear(obj, vars)
	for t in pairs(self[obj]) do
		if t.inited then
			for k in pairs(vars) do t.vars[k] = nil end
		end
	end
end


function flux:add(tween)
	-- Add to object table, create table if it does not exist
	local obj = tween.obj
	self[obj] = self[obj] or {}
	self[obj][tween] = true
	-- Add to array
	table.insert(self, tween)
	tween.parent = self
	return tween
end


function flux:remove(x)
	if type(x) == "number" then
		-- Remove from object table, destroy table if it is empty
		local obj = self[x].obj
		self[obj][self[x]] = nil
		if not next(self[obj]) then self[obj] = nil end
		-- Remove from array
		self[x] = self[#self]
		return table.remove(self)
	end
	for i, v in pairs(self) do
		if v == x then
			return flux.remove(self, i)
		end
	end
end
	


local bound = {
	to		= function(...) return flux.to(flux.tweens, ...) end,
	update	= function(...) return flux.update(flux.tweens, ...) end,
	remove	= function(...) return flux.remove(flux.tweens, ...) end,
}
setmetatable(bound, flux)

return bound
