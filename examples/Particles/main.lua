package.path = package.path .. ';../../lib/?.lua'
package.path = package.path .. ';../../src/?.lua'

require 'EasyLD'

local i = 1

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

function EasyLD:load()
	EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)
	
	surf = EasyLD.surface:new(64,64)
	surf:drawOn()
	EasyLD.box:new(0,0,64,64):draw()
	EasyLD.surface:drawOnScreen()
	system = EasyLD.particles:new(EasyLD.point:new(600,100), surf)
	system:setEmissionRate(20)
	system:setLifeTime(2)
	system:setInitialVelocity(200)
	system:setInitialAcceleration(00)
	system:setDirection(math.pi, math.pi*2)
	system:setColors({[0] = EasyLD.color:new(255,0,0,200), 
					[0.3] = EasyLD.color:new(255,0,255,200), 
					[0.7] = EasyLD.color:new(0,0,255,150), 
					[1] = EasyLD.color:new(0,0,255,00)})
	system:setSizes({[0] = 32,
					[0.3] = 64,
					[0.7] = 32,
					[1] = 16})
	s2 = system:clone()
	s2:setDirection(math.pi/4, math.pi/2)
	s2:start()
	self.isStopped = true
	font = EasyLD.font:new("assets/visitor.ttf")
end

function EasyLD:preCalcul(dt)
	if EasyLD.mouse:isPressed("l") then
		if self.isStopped then
			system:start()
			self.isStopped = false
		else
			system:stop()
			self.isStopped = true
		end
	end
	if EasyLD.mouse:isPressed("r") then
		system:emit(40)
	end
	return dt
end

function EasyLD:update(dt)
	system.follower:moveTo(EasyLD.mouse:getPosition():get())
	system:update(dt)
	s2:update(dt)
	
end

function EasyLD:draw()
	system:draw()
	s2:draw()
	font:print([[Left click: Play/Stop Particles
Right click: Emit 20 particles]], 20, EasyLD.box:new(0, 0, 300, 150), nil, nil, EasyLD.color:new(255,255,255))
end