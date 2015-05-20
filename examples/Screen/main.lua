package.path = package.path .. ';../../src/?.lua'
package.path = package.path .. ';../../lib/?.lua'

require 'EasyLD'

local screen = {}
screen[1] = require 'screenA'
screen[2] = require 'screenB'
local i = 1

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

function EasyLD:load()
	EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)
	EasyLD:nextScreen(screen[2]:new())
	box = EasyLD.box:new(450, 350, 100, 100, EasyLD.color:new(255,0,0))
	font = EasyLD.font:new("assets/visitor.ttf")
end

function EasyLD:preCalcul(dt)
	return dt
end

function EasyLD:update(dt)
	if EasyLD.mouse:isPressed("r") then
		EasyLD:nextScreen(screen[i]:new(), 1, "quad", true)
		i = i % 2 + 1
	end
end

function EasyLD:draw()
	box:draw()
	font:print("EasyLD:draw", 16, box, "center", "center", EasyLD.color:new(255,255,255))
	font:print([[Left click: Action
Right click: Change of screen]], 20, EasyLD.box:new(0, EasyLD.window.h-100, 0, 80), nil, "bottom", EasyLD.color:new(255,255,255))
end