package.path = package.path .. ';../../lib/?.lua'
package.path = package.path .. ';../../src/?.lua'

require 'EasyLD'

local i = 1

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

function EasyLD:load()
	EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)
	
	surf = EasyLD.surface:new(32,32)
	surf:drawOn()
	EasyLD.box:new(0,0,32,32):draw()
	EasyLD.surface:drawOnScreen()
	system = EasyLD.particles:new(EasyLD.point:new(400,300), surf.s)
	system:setEmissionRate(20)
	system:setLifeTime(2)
	system:setInitialVelocity(200)
	system:setInitialAcceleration(00)
	system:setDirection(math.pi, math.pi*2)
	system:setColors({[0] = EasyLD.color:new(255,0,0,200), 
					[0.3] = EasyLD.color:new(255,0,255,200), 
					[0.7] = EasyLD.color:new(0,0,255,150), 
					[1] = EasyLD.color:new(0,0,255,00)})
	system:setSizes({[0] = 1,
					[0.3] = 2,
					[0.7] = 1,
					[1] = 0.4})
	s2 = system:clone()
	
	font = EasyLD.font:new("assets/visitor.ttf")
end

function EasyLD:preCalcul(dt)
	if EasyLD.mouse:isPressed("l") then
		if self.isStopped then
			system:setEmissionRate(20)
			self.isStopped = false
		else
			system:setEmissionRate(0)
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
	font:print([[Q-E: Lower-Upper ground
WASD: Move the circle
Left click: Change of follower
Right click: Draw with or without zoom
Middle click: Change of perspective point]], 20, EasyLD.box:new(0, 0, 300, 150), nil, nil, EasyLD.color:new(255,255,255))
end