local class = require 'middleclass'

local EasyLD = {}
EasyLD.tileset = require 'Tileset'
EasyLD.map = require 'Map'

EasyLD.matrix = require 'Matrix'
EasyLD.vector = require 'Vector'
EasyLD.point = require 'Point'
EasyLD.collide = require 'Collide'

EasyLD.area = require 'Area'
EasyLD.box = require 'Box'
EasyLD.circle = require 'Circle'

EasyLD.color = require 'Color'

EasyLD.mouse = require 'Mouse'
EasyLD.keyboard = require 'Keyboard'

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

EasyLD.load = loadAPI

return EasyLD