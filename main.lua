package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'

AdaptaterImage = require 'LoveImage'
EasyLD = require 'EasyLD'
EasyLD.load.adaptaterImage(AdaptaterImage)
--LOCAL VARIABLE
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

love.window.setTitle("EasyTest")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
love.graphics.setBackgroundColor(0,0,0)

tl = nil
map = nil

function love.load()
	tl = EasyLD.tileset:new("assets/tilesets/tileset.png", 32)
	map = EasyLD.map:new("assets/maps/map2.map", tl)
	map:load()
end
function love.update(dt)
end

function love.draw()
	map:draw(0, 0, 5, 5, 0, 0)
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