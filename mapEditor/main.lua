package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'

AdaptaterImage = require 'LoveImage'
EasyLD = require 'EasyLD'
EasyLD.load.adaptaterImage(AdaptaterImage)

local Mouse = require 'Mouse'
local Keyboard = require 'Keyboard'

mouse = nil
keyboard = nil

--HERE THE USER CAN EDIT THE FOLLWING VAR
srcTileset = nil
srcMap = nil
--END OF THE EDITION POSSIBLE BY THE USER

--GLOBAL VARIABLE
WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

love.window.setTitle("Map Editor")
love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
love.graphics.setBackgroundColor(0,0,0)

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

function love.load()
	mouse = Mouse:new()
	keyboard = Keyboard:new()

	if srcTileset == nil then
		srcTileset = "assets/tilesets/tileset.png"
	end
	if srcMap == nil then
		srcMap = "assets/maps/0.map"
	end
	tl = EasyLD.tileset:new(srcTileset, 32)
 	tilesetWidth = tilesetNbTilesX * tl.tileSize
 	tilesetBox.x, tilesetBox.y = 0, 0
 	tilesetBox.w, tilesetBox.h = tilesetNbTilesX * tl.tileSize, tilesetNbTilesY * tl.tileSizeY

	map = EasyLD.map:new(srcMap, tl)

	if file_exists(srcMap) then
		map:load()
	else
		map:generate(10,10)
	end

	mapBox.x, mapBox.y = 0, tilesetNbTilesY * tl.tileSizeY
	mapNbTilesX = math.floor(WINDOW_WIDTH / tl.tileSize)
	mapNbTilesY = math.floor((WINDOW_HEIGHT - tilesetBox.h) / tl.tileSizeY )
	mapBox.w, mapBox.h = mapNbTilesX*tl.tileSize, mapNbTilesY*tl.tileSizeY
end

function love.update(dt)
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
			elseif EasyLD.collide:AABB_point(widthMinusBox, pos) then
				map:resize(-1,0)
			elseif EasyLD.collide:AABB_point(heightPlusBox, pos) then
				map:resize(0,1)
			elseif EasyLD.collide:AABB_point(heightMinusBox, pos) then
				map:resize(0,-1)
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
			map:save()
			print("Map saved (" .. map.src..")")
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

	mouse:reset()
	keyboard:reset()
end

function love.draw()
	map:draw(mapBox.x, mapBox.y, mapNbTilesX, mapNbTilesY, mapBeginX, mapBeginY)
	tl:draw(tilesetBox.x, tilesetBox.y, tilesetNbTilesX, tilesetNbTilesY, tilesetBeginX, tilesetBeginY)

	drawTileSelected()
	love.graphics.print("FPS : "..love.timer.getFPS(), WINDOW_WIDTH-60, WINDOW_HEIGHT-20)
end

function drawTileSelected()
	local x, y = (tileSelected % tl.nbTilesW - tilesetBeginX) * tl.tileSize + tilesetBox.x, math.floor(tileSelected / tl.nbTilesW - tilesetBeginY) * tl.tileSizeY + tilesetBox.y

	if x < tilesetNbTilesX * tl.tileSize + tilesetBox.x 
		and y < tilesetNbTilesY * tl.tileSizeY + tilesetBox.y then
		love.graphics.setColor(200,0,0)
		love.graphics.rectangle("line", x, y, tl.tileSize, tl.tileSizeY)
		love.graphics.setColor(255,255,255)
	end

	love.graphics.printf("W:"..map.w, WINDOW_WIDTH-100, 10, 70, "right")
	love.graphics.printf("H:"..map.h, WINDOW_WIDTH-100, 50, 70, "right")
	love.graphics.printf("tlW:"..tilesetNbTilesX, WINDOW_WIDTH-160, 10, 50, "right")
	love.graphics.printf("tlH:"..tilesetNbTilesY, WINDOW_WIDTH-160, 50, 50, "right")
	love.graphics.rectangle("fill", widthPlusBox.x, widthPlusBox.y, widthPlusBox.w, widthPlusBox.h)
	love.graphics.rectangle("fill", widthMinusBox.x, widthMinusBox.y, widthMinusBox.w, widthMinusBox.h)
	love.graphics.rectangle("fill", heightPlusBox.x, heightPlusBox.y, heightPlusBox.w, heightPlusBox.h)
	love.graphics.rectangle("fill", heightMinusBox.x, heightMinusBox.y, heightMinusBox.w, heightMinusBox.h)
	love.graphics.rectangle("fill", tlWidthPlusBox.x, tlWidthPlusBox.y, tlWidthPlusBox.w, tlWidthPlusBox.h)
	love.graphics.rectangle("fill", tlWidthMinusBox.x, tlWidthMinusBox.y, tlWidthMinusBox.w, tlWidthMinusBox.h)
	love.graphics.rectangle("fill", tlHeightPlusBox.x, tlHeightPlusBox.y, tlHeightPlusBox.w, tlHeightPlusBox.h)
	love.graphics.rectangle("fill", tlHeightMinusBox.x, tlHeightMinusBox.y, tlHeightMinusBox.w, tlHeightMinusBox.h)
	love.graphics.rectangle("fill", buttonSaveBox.x, buttonSaveBox.y, buttonSaveBox.w, buttonSaveBox.h)
	love.graphics.setColor(0,0,0)
	love.graphics.printf("+", widthPlusBox.x, widthPlusBox.y, widthPlusBox.w, "center")
	love.graphics.printf("-", widthMinusBox.x, widthMinusBox.y, widthMinusBox.w, "center")
	love.graphics.printf("+", heightPlusBox.x, heightPlusBox.y, heightPlusBox.w, "center")
	love.graphics.printf("-", heightMinusBox.x, heightMinusBox.y, heightMinusBox.w, "center")
	love.graphics.printf("+", tlWidthPlusBox.x, tlWidthPlusBox.y, tlWidthPlusBox.w, "center")
	love.graphics.printf("-", tlWidthMinusBox.x, tlWidthMinusBox.y, tlWidthMinusBox.w, "center")
	love.graphics.printf("+", tlHeightPlusBox.x, tlHeightPlusBox.y, tlHeightPlusBox.w, "center")
	love.graphics.printf("-", tlHeightMinusBox.x, tlHeightMinusBox.y, tlHeightMinusBox.w, "center")
	love.graphics.printf("Save", buttonSaveBox.x, buttonSaveBox.y, buttonSaveBox.w, "center")
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle("line", mapBox.x, mapBox.y, mapBox.w, mapBox.h)
end

function selectTile(pos)
	local x, y = math.floor((pos.x - tilesetBox.x) / tl.tileSize) + tilesetBeginX, math.floor((pos.y - tilesetBox.y) / tl.tileSizeY) + tilesetBeginY

	tileSelected = x + y * tl.nbTilesW
end

function putTile(pos)
	local x, y = math.floor((pos.x - mapBox.x) / tl.tileSize) + mapBeginX, math.floor((pos.y - mapBox.y) / tl.tileSize) + mapBeginY

	if x < map.w and y < map.h and x >= 0 and y >= 0 then
		map:putTile(tileSelected, x, y)
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

function love.keypressed(key)
	keyboard:keyPressed(key)
end

function love.keyreleased(key)
	keyboard:keyReleased(key)
end

function love.mousepressed(x, y, button)
    mouse:buttonPressed(x,y,button)
end

function love.mousereleased(x, y, button)
    mouse:buttonReleased(x,y,button)
end