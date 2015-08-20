package.path = package.path .. ';../../?.lua'

require 'EasyLD'
local Player = require 'Player'

local i = 1

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

function EasyLD:load()
	EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)
	
	tl = EasyLD.tileset:new("assets/tileset.png", 32)

	maps = {}
	maps[1] = EasyLD.map:new("assets/w1.map", tl)
	maps[2] = EasyLD.map:new("assets/w2.map", tl)
	maps[3] = EasyLD.map:new("assets/w3.map", tl)

	p = EasyLD.point:new(0, 0)
	p.depth = 0
	player = Player:new(p.x, p.y, EasyLD.area:new(EasyLD.circle:new(p.x, p.y, 10)))
	player.depth = 0

	player2 = player:copy()
	player2.pos.x = 100
	player2.collideArea.forms[1].c = EasyLD.color:new(255,255,0)

	nbEntities = 2

	slices = {}
	slices[1] = EasyLD.worldSlice:new(maps[1], EasyLD.point:new(0, -30))
	slices[2] = EasyLD.worldSlice:new(maps[2], EasyLD.point:new(0, 30))
	slices[3] = EasyLD.worldSlice:new(maps[3], EasyLD.point:new(0, 0))

	slices[3]:addEntity(player)
	slices[3]:addEntity(player2)

	DM = EasyLD.depthManager:new(player, slices[3], 1, 0, 2)
	DM:addDepth(1, 0.5, slices[2])

	DM:addDepth(2, 0.25, slices[1])
	DM:centerOn(0, 0)

	font = EasyLD.font:new("assets/visitor.ttf")
	timer = nil
end

function EasyLD:preCalcul(dt)
	return dt
end

function EasyLD:update(dt)
	p = player.pos

	if EasyLD.mouse:isPressed("l") then
		local point = EasyLD.point:new(-100, -100)
		point.pos = point
		if DM.follower.y ~= -100 then DM:follow(point, true, 2, "elasticout")
		else DM:follow(player, true, 2, "elasticout") end
	end
	if EasyLD.mouse:isPressed("r") then
		drawWithoutZoom = not drawWithoutZoom
	end
	if EasyLD.mouse:isPressed("m") then
		if DM.center.x < 200 then DM:centerOn(400, 200, true, 2)
		else DM:centerOn(0, 0, true, 2) end
	end

	if EasyLD.keyboard:isDown("z") then
		nbEntities = nbEntities + 1
		local entity = player:copy()
		entity.collideArea.forms[1].c = EasyLD.color:new(math.random(22,232),math.random(22,232),math.random(22,232))
		entity.update = function(dt) end
		entity.collide = function() return false end
		entity.spriteAnimation = entity.collideArea
		entity.spriteAnimation:moveTo(math.random(50, 800), math.random(0, 200))
		entity.pos.x = entity.spriteAnimation.x
		entity.pos.y = entity.spriteAnimation.y
		--entity.collideArea = nil
		slices[3]:addEntity(entity)
	end

	if EasyLD.keyboard:isPressed("e") then
		if timer == nil then
			local oldDepth, newDepth = math.floor(player.depth), math.floor(player.depth + 1) % 3
			timer = EasyLD.flux.to(player, 0.8, {depth = newDepth}):oncomplete(function() timer = nil end)
			slices[3 - oldDepth]:removeEntity(player)
			slices[3 - newDepth]:addEntity(player)
			timer2 = EasyLD.flux.to(DM.depth[newDepth], 0.8, {alpha = 255}):oncomplete(function() timer2 = nil end)
			timer3 = EasyLD.flux.to(DM.depth[oldDepth], 0.8, {alpha = 150}):oncomplete(function() timer3 = nil end)
		end
	end
	if EasyLD.keyboard:isPressed("q") then
		if timer == nil then
			local oldDepth, newDepth = math.floor(player.depth), math.floor(player.depth - 1) % 3
			timer = EasyLD.flux.to(player, 0.8, {depth = newDepth}):oncomplete(function() timer = nil end)
			slices[3 - oldDepth]:removeEntity(player)
			slices[3 - newDepth]:addEntity(player)
			timer2 = EasyLD.flux.to(DM.depth[newDepth], 0.8, {alpha = 255}):oncomplete(function() timer2 = nil end)
			timer3 = EasyLD.flux.to(DM.depth[oldDepth], 0.8, {alpha = 150}):oncomplete(function() timer3 = nil end)
		end
	end
	DM:update(dt)
end

function EasyLD:draw()
	DM:draw(drawWithoutZoom)
	font:print([[Q-E: Lower-Upper ground
WASD: Move the circle
Left click: Change of follower
Right click: Draw with or without zoom
Middle click: Change of perspective point]], 20, EasyLD.box:new(0, 0, 300, 150), nil, nil, EasyLD.color:new(255,255,255))
	font:print("FPS: "..EasyLD:getFPS() .. " Entities: " .. nbEntities, 20, EasyLD.box:new(0, WINDOW_HEIGHT-50, 100, 50), nil, "bottom")
end