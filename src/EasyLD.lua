local class = require 'middleclass'

local EasyLD = {}
EasyLD.tileset = require 'Tileset'
EasyLD.map = require 'Map'
EasyLD.vector = require 'Vector'
EasyLD.collide = require 'Collide'
EasyLD.box = require 'Box'
EasyLD.point = require 'Point'

function loadAdaptaterImage(base)
	EasyLD.image = base
end

function loadAdaptaterGraphics(base)
	EasyLD.graphics = base
end

EasyLD.load = {}
EasyLD.load.adaptaterImage = loadAdaptaterImage

return EasyLD