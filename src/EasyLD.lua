local class = require 'middleclass'

local utf8 = require 'utf8'

local EasyLD = {}
EasyLD.tileset = require 'Tileset'
EasyLD.map = require 'Map'

EasyLD.matrix = require 'Matrix'
EasyLD.vector = require 'Vector'
EasyLD.collide = require 'Collide'

EasyLD.area = require 'Area'
EasyLD.polygon = require 'Polygon'
EasyLD.box = require 'Box'
EasyLD.circle = require 'Circle'
EasyLD.segment = require 'Segment'
EasyLD.point = require 'Point'

EasyLD.color = require 'Color'

EasyLD.mouse = require 'Mouse'
EasyLD.keyboard = require 'Keyboard'

EasyLD.inputText = require 'InputText'
EasyLD.timer = require 'cron'
EasyLD.flux = require 'flux'

local function loadAdapterImage(base)
	EasyLD.image = base
end

local function loadAdapterGraphics(base)
	EasyLD.graphics = base
end

local function loadAdapterMouse(base)
	EasyLD.mouse.getPosition = base.getPosition
end

local function loadAPI(name)
	if name == "Drystal" then
		require 'DrystalKeyboard'
		loadAdapterMouse(require 'DrystalMouse')
		loadAdapterGraphics(require 'DrystalGraphics')
		loadAdapterImage(require 'DrystalImage')
	elseif name == "Löve2D" then
		require 'LoveKeyboard'
		loadAdapterMouse(require 'LoveMouse')
		loadAdapterGraphics(require 'LoveGraphics')
		loadAdapterImage(require 'LoveImage')
	end
end

function EasyLD:update(dt)
	EasyLD.keyboard:reset()
	EasyLD.mouse:reset()
	EasyLD.timer.update(dt)
	EasyLD.flux.update(dt)
end

EasyLD.load = loadAPI

return EasyLD