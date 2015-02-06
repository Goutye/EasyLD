package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'

AdapterImage = require 'LoveImage'
AdapterGraphics = require 'LoveGraphics'
EasyLD = require 'EasyLD'
EasyLD.load.adapterImage(AdapterImage)
EasyLD.load.adapterGraphics(AdapterGraphics)
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
	--tl = EasyLD.tileset:new("assets/tilesets/tileset.png", 32)
	--map = EasyLD.map:new("assets/maps/map2.map", tl)
	--map:load()
	box = EasyLD.box:new(200,270, 54, 45,EasyLD.color:new(255,25,25,125), "fill")
	box1 = EasyLD.circle:new(170,335, 20,EasyLD.color:new(25,25,25,125), "fill")
	box2 = EasyLD.box:new(80,89, 54, 45,EasyLD.color:new(255,255,25,125), "fill")
	area = EasyLD.area:new(box)
	area:attach(box1)
	area:attach(box2)
	boxR = box:copy()
	ox = box.x
	boxR:rotate(math.pi/4, ox, box.y)
	boxR.c = EasyLD.color:new(0,255,0,125)
	--boxR:rotate(math.pi/4, ox, box.y)

	m = EasyLD.matrix:new(2, 2)
	for i = 0, 1 do
		for j = 0, 1 do
			m.d[i][j] = math.random(-3, 4)
		end
	end

	print(EasyLD.collide:OBB_circle(boxR, box1))
end
function love.update(dt)
end

function love.draw()
	--map:draw(0, 0, 5, 5, 0, 0)
	--EasyLD.graphics:polygon("fill", EasyLD.point:new(1,1), EasyLD.point:new(1,90), EasyLD.point:new(50,159), EasyLD.point:new(59,1))
	box:draw()
	box1:draw()
	boxR:draw()
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