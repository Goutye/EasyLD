package.path = package.path .. ';../?.lua'

EasyLD = require 'EasyLD'

local utf8 = require 'EasyLD.lib.utf8'

local Collide = require 'CollideEfficiency'

mouse = nil
keyboard = nil

--HERE THE USER CAN EDIT THE FOLLWING VAR
srcTileset = nil
srcTilesetCollide = "assets/tilesets/collide.png"
srcMap = nil
--END OF THE EDITION POSSIBLE BY THE USER

--GLOBAL VARIABLE
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

EasyLD.window:setTitle("Map Editor")
EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)

tl = nil
map = nil
tilesetNbTilesX = 12
tilesetNbTilesY = 3
tilesetWidth = nil
tilesetBeginX = 0
tilesetBeginY = 0
tilesetBox = {}

mapPosY = 0
mapNbTilesX = 20
mapNbTilesY = 20
mapBeginX = 0
mapBeginY = 0
mapBox = {}

modeType = {"map", "collide"}
mode = "map"

mapCollide = {}

buttonBox = {x = WINDOW_WIDTH-20, y = 0, w = 20, h = 80}
widthPlusBox = {x = WINDOW_WIDTH-20, y = 0, w = 20, h = 20}
widthMinusBox = {x = WINDOW_WIDTH-20, y = 20, w = 20, h = 20}
heightPlusBox = {x = WINDOW_WIDTH-20, y = 40, w = 20, h = 20}
heightMinusBox = {x = WINDOW_WIDTH-20, y = 60, w = 20, h = 20}

buttonTlBox = {x = WINDOW_WIDTH-100, y = 0, w = 20, h = 80}
tlWidthPlusBox = {x = WINDOW_WIDTH-100, y = 0, w = 20, h = 20}
tlWidthMinusBox = {x = WINDOW_WIDTH-100, y = 20, w = 20, h = 20}
tlHeightPlusBox = {x = WINDOW_WIDTH-100, y = 40, w = 20, h = 20}
tlHeightMinusBox = {x = WINDOW_WIDTH-100, y = 60, w = 20, h = 20}

buttonSaveBox = {x = WINDOW_WIDTH-70, y = 27, w = 40, h = 20}
buttonOpenBox = {x = WINDOW_WIDTH-70, y = 67, w = 40, h = 20}
inputTextBox = EasyLD.box:new(WINDOW_WIDTH-300, 2, 150, 30)

inputText = nil
clickPos = nil

currentTimeBeforeIncr = 0
TIME_BEFORE_INCR_BY_MOUSE = 0.5

isDraggingOnTileset = false
isDraggingOnMap = false

tileSelected = 0
tileBoxSelected = {}

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function EasyLD:load()
	mouse = EasyLD.mouse
	keyboard = EasyLD.keyboard

	if srcTileset == nil then
		srcTileset = "assets/tilesets/tileset.png"
	end
	if srcMap == nil then
		srcMap = "assets/maps/w1.map"
	end
	tl = EasyLD.tileset:new(srcTileset, 32)
 	tilesetWidth = tilesetNbTilesX * tl.tileSize
 	tilesetBox.x, tilesetBox.y = 0, 0
 	tilesetBox.w, tilesetBox.h = tilesetNbTilesX * tl.tileSize, tilesetNbTilesY * tl.tileSizeY

	if file_exists(srcMap) then
		map = EasyLD.map:new(srcMap, tl)
	else
		map = EasyLD.map:generate(10,10, tl)
	end

	for i = 0, map.w-1 do
		mapCollide[i] = {}
		for j = 0, map.h-1 do
			mapCollide[i][j] = 0
		end
	end

	mapBox.x, mapBox.y = 0, tilesetNbTilesY * tl.tileSizeY
	mapNbTilesX = math.floor(WINDOW_WIDTH / tl.tileSize)
	mapNbTilesY = math.floor((WINDOW_HEIGHT - tilesetBox.h) / tl.tileSizeY )
	mapBox.w, mapBox.h = mapNbTilesX*tl.tileSize, mapNbTilesY*tl.tileSizeY

	font = EasyLD.font:new("assets/fonts/visitor.ttf")
	font:load(24, EasyLD.color:new(255,255,255))
	inputText = EasyLD.inputText:new(inputTextBox, {r=120, g=10, b=10, a=255}, {r=255, g=255, b=255, a=255}, 16, font, 24)
end

function EasyLD:update(dt)
	inputText:update(dt)

	if mouse:isPressed("r") then
		local pos = mouse:getPosition()
		clickPos = pos

		isDraggingOnTileset = EasyLD.collide:AABB_point(tilesetBox, pos)
		isDraggingOnMap = EasyLD.collide:AABB_point(mapBox, pos)
	end

	if mouse:isReleased("r") then
		isDraggingOnMap = false
		isDraggingOnTileset = false
	end

	if mouse:isDown("r") then
		if isDraggingOnTileset then
			local pos = mouse:getPosition()

			if pos.x - clickPos.x >= tl.tileSize and tilesetBeginX > 0 then
				tilesetBeginX = tilesetBeginX - 1
				clickPos.x = clickPos.x + tl.tileSize
			elseif clickPos.x - pos.x >= tl.tileSize and tilesetBeginX < tl.nbTilesW - tilesetNbTilesX then
				tilesetBeginX = tilesetBeginX + 1
				clickPos.x = clickPos.x - tl.tileSize
			end
			
			if pos.y - clickPos.y >= tl.tileSizeY and tilesetBeginY > 0 then
				tilesetBeginY = tilesetBeginY - 1
				clickPos.y = clickPos.y + tl.tileSizeY
			elseif clickPos.y - pos.y >= tl.tileSizeY and tilesetBeginY < tl.nbTilesH - tilesetNbTilesY then
				tilesetBeginY = tilesetBeginY + 1
				clickPos.y = clickPos.y - tl.tileSizeY
			end
		elseif isDraggingOnMap then
			local pos = mouse:getPosition()

			if pos.x - clickPos.x >= tl.tileSize and mapBeginX > 0 then
				mapBeginX = mapBeginX - 1
				clickPos.x = clickPos.x + tl.tileSize
			elseif clickPos.x - pos.x >= tl.tileSize and mapBeginX < map.w - mapNbTilesX then
				mapBeginX = mapBeginX + 1
				clickPos.x = clickPos.x - tl.tileSize
			end
			
			if pos.y - clickPos.y >= tl.tileSizeY and mapBeginY > 0 then
				mapBeginY = mapBeginY - 1
				clickPos.y = clickPos.y + tl.tileSizeY
			elseif clickPos.y - pos.y >= tl.tileSizeY and mapBeginY < map.h - mapNbTilesY then
				mapBeginY = mapBeginY + 1
				clickPos.y = clickPos.y - tl.tileSizeY
			end
		end
	end

	if mouse:isPressed("l") then
		local pos = mouse:getPosition()

		if EasyLD.collide:AABB_point(tilesetBox, pos) then
			selectTile(pos)
		elseif EasyLD.collide:AABB_point(mapBox, pos) then
			putTile(pos)
		end

		if EasyLD.collide:AABB_point(buttonBox, pos) then
			if EasyLD.collide:AABB_point(widthPlusBox, pos) then
				map:resize(1,0)
				resize(mapCollide, 1, 0)
			elseif EasyLD.collide:AABB_point(widthMinusBox, pos) then
				map:resize(-1,0)
				resize(mapCollide, -1, 0)
			elseif EasyLD.collide:AABB_point(heightPlusBox, pos) then
				map:resize(0,1)
				resize(mapCollide, 0, 1)
			elseif EasyLD.collide:AABB_point(heightMinusBox, pos) then
				map:resize(0,-1)
				resize(mapCollide, 0, -1)
			end
			currentTimeBeforeIncr = 0
		end

		if EasyLD.collide:AABB_point(buttonTlBox, pos) then
			if EasyLD.collide:AABB_point(tlWidthPlusBox, pos) then
				changeTilesetNB(1,0)
			elseif EasyLD.collide:AABB_point(tlWidthMinusBox, pos) then
				changeTilesetNB(-1,0)
			elseif EasyLD.collide:AABB_point(tlHeightPlusBox, pos) then
				changeTilesetNB(0,1)
			elseif EasyLD.collide:AABB_point(tlHeightMinusBox, pos) then
				changeTilesetNB(0,-1)
			end
			currentTimeBeforeIncr = 0
		end

		if EasyLD.collide:AABB_point(buttonSaveBox, pos) then
			if inputText.text ~= "" then
				map.src = "assets/maps/" .. inputText.text .. ".map"
			end
			map:save()
			print("Map saved (" .. map.src..")")
		end

		if EasyLD.collide:AABB_point(buttonOpenBox, pos) then
			if inputText.text ~= "" then
				srcMap = "assets/maps/" .. inputText.text .. ".map"

				if file_exists(srcMap) then
					map = EasyLD.map:new(srcMap, tl)
					map:load()
					print("Map opened (" .. map.src..")")
				end
			end
		end
	end

	if mouse:isDown("l") then
		local pos = mouse:getPosition()

		if EasyLD.collide:AABB_point(buttonBox, pos) then
			if currentTimeBeforeIncr >= TIME_BEFORE_INCR_BY_MOUSE then
				if EasyLD.collide:AABB_point(widthPlusBox, pos) then
					map:resize(1,0)
				elseif EasyLD.collide:AABB_point(widthMinusBox, pos) then
					map:resize(-1,0)
				elseif EasyLD.collide:AABB_point(heightPlusBox, pos) then
					map:resize(0,1)
				elseif EasyLD.collide:AABB_point(heightMinusBox, pos) then
					map:resize(0,-1)
				end
			else
				currentTimeBeforeIncr = currentTimeBeforeIncr + dt
			end
		elseif EasyLD.collide:AABB_point(mapBox, pos) then
			putTile(pos)
		end
	end

	if keyboard:isPressed("z") then
		local x = math.floor(tileSelected / tl.nbTilesH)
		if x > 0  then
			tileSelected = tileSelected - tl.nbTilesW

			if x-1 < tilesetBeginY then
				tilesetBeginY = tilesetBeginY - 1
			end
		end
	end
	if keyboard:isPressed("s") then
		local x = math.floor(tileSelected / tl.nbTilesH)
		if x < tl.nbTilesH-1 then
			tileSelected = tileSelected + tl.nbTilesW

			if x+1 >= tilesetBeginY + tilesetNbTilesY then
				tilesetBeginY = tilesetBeginY + 1
			end
		end
	end
	if keyboard:isPressed("q") then
		local x = tileSelected % tl.nbTilesW
		if x > 0  then
			tileSelected = tileSelected - 1

			if x-1 < tilesetBeginX then
				tilesetBeginX = tilesetBeginX - 1
			end
		end
	end
	if keyboard:isPressed("d") then
		local x = tileSelected % tl.nbTilesW
		if x < tl.nbTilesW-1 then
			tileSelected = tileSelected + 1

			if x+1 >= tilesetBeginX + tilesetNbTilesX then
				tilesetBeginX = tilesetBeginX + 1
			end
		end
	end

	if keyboard:isPressed("m") then
		if mode == modeType[1] then
			mode = modeType[2]
			tl = EasyLD.tileset:new(srcTilesetCollide, 32)
			tilesetWidth = tilesetNbTilesX * tl.tileSize
		 	tilesetBox.x, tilesetBox.y = 0, 0
		 	tilesetBox.w, tilesetBox.h = tilesetNbTilesX * tl.tileSize, tilesetNbTilesY * tl.tileSizeY
		 	print("mode2")
		else
			mode = modeType[1]
			tl = EasyLD.tileset:new(srcTileset, 32)
			tilesetWidth = tilesetNbTilesX * tl.tileSize
		 	tilesetBox.x, tilesetBox.y = 0, 0
		 	tilesetBox.w, tilesetBox.h = tilesetNbTilesX * tl.tileSize, tilesetNbTilesY * tl.tileSizeY
		end
	end

	if keyboard:isPressed("c") then
		Collide:cutInBox(mapCollide, map)
	end

	mouse:reset()
	keyboard:reset()
end

function EasyLD:draw()
	EasyLD.graphics:setColor()
	map:draw(mapBox.x, mapBox.y, mapNbTilesX, mapNbTilesY, mapBeginX, mapBeginY)
	if mode == modeType[2] then
		for i = mapBeginX, math.min(mapNbTilesX+mapBeginX, map.w-1) - mapBeginX do
			for j = mapBeginY, math.min(mapNbTilesY+mapBeginY, map.h-1) - mapBeginY do
				tl:drawTile(mapCollide[i][j], mapBox.x + i * tl.tileSize, mapBox.y + j * tl.tileSizeY)
			end
		end
	end
	tl:draw(tilesetBox.x, tilesetBox.y, tilesetNbTilesX, tilesetNbTilesY, tilesetBeginX, tilesetBeginY)

	drawTileSelected()
	inputText:draw()
	love.graphics.print("FPS : "..love.timer.getFPS(), WINDOW_WIDTH-60, WINDOW_HEIGHT-20)
end

function drawTileSelected()
	local x, y = (tileSelected % tl.nbTilesW - tilesetBeginX) * tl.tileSize + tilesetBox.x, math.floor(tileSelected / tl.nbTilesW - tilesetBeginY) * tl.tileSizeY + tilesetBox.y

	if x < tilesetNbTilesX * tl.tileSize + tilesetBox.x 
		and y < tilesetNbTilesY * tl.tileSizeY + tilesetBox.y then
		EasyLD.graphics:rectangle("line", EasyLD.box:new(x, y, tl.tileSize, tl.tileSizeY), EasyLD.color:new(200,0,0))
	end
	
	font:load(16, EasyLD.color:new(255,255,255))
	EasyLD.font.print("W:"..map.w, 1, 16, EasyLD.box:new(WINDOW_WIDTH-100, 10, 70, 30), "right")
	EasyLD.font.print("H:"..map.h, 1, 16, EasyLD.box:new(WINDOW_WIDTH-100, 50, 70, 30), "right")
	EasyLD.font.print("tlW:"..tilesetNbTilesX, 1, 16, EasyLD.box:new(WINDOW_WIDTH-160, 10, 50, 30), "right")
	EasyLD.font.print("tlH:"..tilesetNbTilesY, 1, 16, EasyLD.box:new(WINDOW_WIDTH-160, 50, 50, 30), "right")
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(widthPlusBox.x, widthPlusBox.y, widthPlusBox.w, widthPlusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(widthMinusBox.x, widthMinusBox.y, widthMinusBox.w, widthMinusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(heightPlusBox.x, heightPlusBox.y, heightPlusBox.w, heightPlusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(heightMinusBox.x, heightMinusBox.y, heightMinusBox.w, heightMinusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(tlWidthPlusBox.x, tlWidthPlusBox.y, tlWidthPlusBox.w, tlWidthPlusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(tlWidthMinusBox.x, tlWidthMinusBox.y, tlWidthMinusBox.w, tlWidthMinusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(tlHeightPlusBox.x, tlHeightPlusBox.y, tlHeightPlusBox.w, tlHeightPlusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(tlHeightMinusBox.x, tlHeightMinusBox.y, tlHeightMinusBox.w, tlHeightMinusBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(buttonSaveBox.x, buttonSaveBox.y, buttonSaveBox.w, buttonSaveBox.h), EasyLD.color:new(255,255,255))
	EasyLD.graphics:rectangle("fill", EasyLD.box:new(buttonOpenBox.x, buttonOpenBox.y, buttonOpenBox.w, buttonOpenBox.h), EasyLD.color:new(255,255,255))
	font:load(16, EasyLD.color:new(0,0,0))
	EasyLD.font.print("+", 1, 16, EasyLD.box:new(widthPlusBox.x, widthPlusBox.y, widthPlusBox.w, 30), "center")
	EasyLD.font.print("-", 1, 16, EasyLD.box:new(widthMinusBox.x, widthMinusBox.y, widthMinusBox.w, 30), "center")
	EasyLD.font.print("+", 1, 16, EasyLD.box:new(heightPlusBox.x, heightPlusBox.y, heightPlusBox.w, 30), "center")
	EasyLD.font.print("-", 1, 16, EasyLD.box:new(heightMinusBox.x, heightMinusBox.y, heightMinusBox.w, 30), "center")
	EasyLD.font.print("+", 1, 16, EasyLD.box:new(tlWidthPlusBox.x, tlWidthPlusBox.y, tlWidthPlusBox.w, 30), "center")
	EasyLD.font.print("-", 1, 16, EasyLD.box:new(tlWidthMinusBox.x, tlWidthMinusBox.y, tlWidthMinusBox.w, 30), "center")
	EasyLD.font.print("+", 1, 16, EasyLD.box:new(tlHeightPlusBox.x, tlHeightPlusBox.y, tlHeightPlusBox.w, 30), "center")
	EasyLD.font.print("-", 1, 16, EasyLD.box:new(tlHeightMinusBox.x, tlHeightMinusBox.y, tlHeightMinusBox.w, 30), "center")
	EasyLD.font.print("Save", 1, 16, EasyLD.box:new(buttonSaveBox.x, buttonSaveBox.y, buttonSaveBox.w, 30), "center")
	EasyLD.font.print("Open", 1, 16, EasyLD.box:new(buttonOpenBox.x, buttonOpenBox.y, buttonOpenBox.w, 30), "center")
	EasyLD.graphics:rectangle("line", EasyLD.box:new(mapBox.x, mapBox.y, mapBox.w, mapBox.h), EasyLD.color:new(255,255,255))
end

function selectTile(pos)
	local x, y = math.floor((pos.x - tilesetBox.x) / tl.tileSize) + tilesetBeginX, math.floor((pos.y - tilesetBox.y) / tl.tileSizeY) + tilesetBeginY

	tileSelected = x + y * tl.nbTilesW
end

function putTile(pos)
	local x, y = math.floor((pos.x - mapBox.x) / tl.tileSize) + mapBeginX, math.floor((pos.y - mapBox.y) / tl.tileSize) + mapBeginY

	if x < map.w and y < map.h and x >= 0 and y >= 0 then
		if mode == modeType[2] then
			mapCollide[x][y] = tileSelected
		else
			map:putTile(tileSelected, x, y)
		end
	end
end

function changeTilesetNB(x, y)
	if tilesetNbTilesX + x > 0 and tilesetNbTilesX + x <= tl.nbTilesW then
		tilesetNbTilesX = tilesetNbTilesX + x

		if tilesetBeginX + tilesetNbTilesX > tl.nbTilesW then
			tilesetBeginX = tilesetBeginX - 1
		end

		tilesetBox.w = tilesetBox.w + x * tl.tileSize
	end
	if tilesetNbTilesY + y > 0 and tilesetNbTilesY + y <= tl.nbTilesH then
		tilesetNbTilesY = tilesetNbTilesY + y

		if tilesetBeginY + tilesetNbTilesY > tl.nbTilesH then
			tilesetBeginY = tilesetBeginY - 1
		end

		mapBox.y = mapBox.y + y * tl.tileSize
		mapBox.h = mapBox.h - y * tl.tileSize
		mapNbTilesY = mapNbTilesY - y
		tilesetBox.h = tilesetBox.h + y * tl.tileSize
	end
end

function resize(tab, x, y)
	if x > 0 then
		tab[map.w - 1] = {}
		for i = 0, map.h - 1 do
			tab[map.w - 1][i] = 0
		end
	end
	if y > 0 then
		for i = 0, map.w - 1 do
			tab[i][map.h-1] = 0 
		end
	end
end