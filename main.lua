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
	box = EasyLD.box:new(10,70, 54, 45,EasyLD.color:new(255,25,25,125), "fill")
	box1 = EasyLD.box:new(60,80, 100, 45,EasyLD.color:new(25,25,25,125), "fill")
	box2 = EasyLD.box:new(80,89, 54, 45,EasyLD.color:new(255,255,25,125), "fill")
	area = EasyLD.area:new(box)
	area:attach(box1)
	area:attach(box2)
end
function love.update(dt)
end

function love.draw()
	--map:draw(0, 0, 5, 5, 0, 0)
	EasyLD.graphics:polygon("fill", EasyLD.point:new(1,1), EasyLD.point:new(1,90), EasyLD.point:new(50,159), EasyLD.point:new(59,1))
	area:draw()
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