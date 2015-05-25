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
	system = EasyLD.particles:new(EasyLD.point:new(600,100), "assets/texture.png")
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
	s2:setTexture(surf)
	s2:setDirection(0, math.pi)
	s2:setSpinEmitter(math.pi/4)
	--s2:setRotation(0,math.pi/2, 8)
	s2:setRelativeRotation(9)
	s2:start()
	self.isStopped = true
	font = EasyLD.font:new("assets/visitor.ttf")
end

function EasyLD:preCalcul(dt)
	return dt
end

function EasyLD:update(dt)
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
	if EasyLD.keyboard:isPressed("x") then
		EasyLD.camera:tilt(EasyLD.vector:new(1,1), 50, 3)
	end
	if EasyLD.keyboard:isPressed("c") then
		if not cPressed then
			EasyLD.camera:setMode("elasticout")
			EasyLD.camera:moveTo(200,-200, 3)
			EasyLD.camera:setMode("normal")
			cPressed = true
		else
			EasyLD.camera:setMode("elasticout")
			EasyLD.camera:moveTo(0,0, 3)
			EasyLD.camera:setMode("normal")
			cPressed = false
		end
	end
	if EasyLD.keyboard:isPressed("v") then
		if not vPressed then
			EasyLD.camera:setMode("elasticout")
			EasyLD.camera:rotateTo(math.pi/2,nil,nil, 3)
			EasyLD.camera:setMode("normal")
			vPressed = true
		else
			EasyLD.camera:setMode("elasticout")
			EasyLD.camera:rotateTo(0,nil,nil, 3)
			EasyLD.camera:setMode("normal")
			vPressed = false
		end
	end
	if EasyLD.keyboard:isPressed("b") then
		if not bPressed then
			EasyLD.camera:setMode("elasticout")
			EasyLD.camera:scaleTo(0.5)
			EasyLD.camera:setMode("normal")
			bPressed = true
		else
			EasyLD.camera:setMode("elasticout")
			EasyLD.camera:scaleTo(1)
			EasyLD.camera:setMode("normal")
			bPressed = false
		end
	end
	s2.follower:moveTo(EasyLD.mouse:getPosition():get())
	system:update(dt)
	s2:update(dt)
	
end

function EasyLD:draw()
	system:draw()
	s2:draw()
	font:print([[Left click: Play/Stop Particles
Right click: Emit 20 particles
X: tilt
C: Move camera
V: Rotate camera
B: Zoom]], 20, EasyLD.box:new(0, 0, 300, 150), nil, nil, EasyLD.color:new(255,255,255))
end