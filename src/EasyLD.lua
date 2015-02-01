local class = require 'middleclass'

local EasyLD = {}
EasyLD.tileset = require 'Tileset'
EasyLD.map = require 'Map'
EasyLD.vector = require 'Vector'
EasyLD.collide = require 'Collide'
EasyLD.box = require 'Box'
EasyLD.circle = require 'Circle'
EasyLD.point = require 'Point'



function loadAdapterImage(base)
	EasyLD.image = base
end

function loadAdapterGraphics(base)
	EasyLD.graphics = base
end

EasyLD.load = {}
EasyLD.load.adapterImage = loadAdapterImage
EasyLD.load.adapterGraphics = loadAdapterGraphics

return EasyLD