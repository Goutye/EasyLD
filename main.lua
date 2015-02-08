package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'

EasyLD = require 'EasyLD'
EasyLD.load("Löve2D")

--LOCAL VARIABLE
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

love.window.setTitle("EasyTest")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
love.graphics.setBackgroundColor(0,0,0)

tl = nil
map = nil
box = nil
area = nil

function love.load()
	box = EasyLD.box:new(200,270, 54, 45,EasyLD.color:new(255,25,25,125), "fill")
	box1 = EasyLD.circle:new(170,335, 20,EasyLD.color:new(25,25,25,125), "fill")
	boxR = box:copy()
	boxL = box:copy()
	ox = box.x
	boxR:rotate(math.pi/4, ox, box.y)
	boxL:rotate(math.pi/3, ox, box.y)
	boxL:translate(100,100)
	boxR.c = EasyLD.color:new(0,255,0,125)

	m = EasyLD.matrix:new(2, 2)
	for i = 0, 1 do
		for j = 0, 1 do
			m.d[i][j] = math.random(-3, 4)
		end
	end

	box2 = box1:copy()
	box2:rotate(math.pi/2, box2.x, box2.y+box2.r)
	box3 = boxR:copy()
	box3.c = EasyLD.color:new(5,255,255,125)
	box2.c = EasyLD.color:new(0,100,255,125)

	area = EasyLD.area:new(box)
	area:attach(box1)
	area:attach(box2)
	area:attach(boxR)
	area:rotate(math.pi/2, box1.x, box1.y)
	area:translate(100, 10)
end
function love.update(dt)
	area:rotate(math.pi/180, box1.x, box1.y)

	boxL:moveTo(love.mouse.getPosition())
	if EasyLD.collide:OBB_OBB(boxR, boxL) then
		boxL.c = EasyLD.color:new(0,255,0,125)
	else
		boxL.c = EasyLD.color:new(255,0,0,125)
	end

	if EasyLD.collide:OBB_point(boxR, EasyLD.point:new(love.mouse.getPosition())) then
		box1.c = EasyLD.color:new(0,0,255,125)
	else
		box1.c = EasyLD.color:new(25,25,25,125)
	end
end

function love.draw()
	area:draw()
	box3:draw()
	boxL:draw()
	love.graphics.print("FPS : "..love.timer.getFPS(), WINDOW_WIDTH-60, WINDOW_HEIGHT-20)
end

function love.keypressed(key)
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end