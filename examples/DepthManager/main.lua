package.path = package.path .. ';../../?.lua'

require 'EasyLD'

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
	player = EasyLD.area:new(EasyLD.circle:new(p.x, p.y, 10))
	player:follow(p)

	level = 0

	DM = EasyLD.depthManager:new(p, function () 
								maps[3]:draw(0, 000, 100, 7, 0, 0)
								if level == 0 then
									player:draw()
								end
							end, 1, 0, 2)
	DM:addDepth(1, 0.5, function ()
				maps[2]:draw(0, 30, 100, 7, 0, 0)
				if level == 1 then
					player:draw()
				end
			end)

	DM:addDepth(2, 0.25, function ()
				maps[1]:draw(0, -30, 100, 7, 0, 0)
				if level == 2 then
					player:draw()
				end	
			end)
	DM:centerOn(0, 0)

	font = EasyLD.font:new("assets/visitor.ttf")
end

function EasyLD:preCalcul(dt)
	return dt
end

function EasyLD:update(dt)
	if EasyLD.mouse:isPressed("l") then
		if DM.follower.y ~= -100 then DM:follow(EasyLD.point:new(-100, -100), true, 2, "elasticout")
		else DM:follow(p, true, 2, "elasticout") end
	end
	if EasyLD.mouse:isPressed("r") then
		drawWithoutZoom = not drawWithoutZoom
	end
	if EasyLD.mouse:isPressed("m") then
		if DM.center.x < 200 then DM:centerOn(400, 200, true, 2)
		else DM:centerOn(0, 0, true, 2) end
	end

	local FORCE = 3

	if EasyLD.keyboard:isDown("a") then
		p.x = p.x - FORCE
	end
	if EasyLD.keyboard:isDown("w") then
		p.y = p.y - FORCE
	end
	if EasyLD.keyboard:isDown("d") then
		p.x = p.x + FORCE
	end
	if EasyLD.keyboard:isDown("s") then
		p.y = p.y + FORCE
	end

	if EasyLD.keyboard:isPressed("e") then
		level = (level + 1) % 3
	end
	if EasyLD.keyboard:isPressed("q") then
		level = (level - 1) % 3
	end
	DM:update()

	player:moveTo(p:get())
end

function EasyLD:draw()
	DM:draw(drawWithoutZoom)
	font:print([[Q-E: Lower-Upper ground
WASD: Move the circle
Left click: Change of follower
Right click: Draw with or without zoom
Middle click: Change of perspective point]], 20, EasyLD.box:new(0, 0, 300, 150), nil, nil, EasyLD.color:new(255,255,255))
end