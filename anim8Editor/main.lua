package.path = package.path .. ';src/?.lua'
package.path = package.path .. ';lib/?.lua'

ezld = require 'EasyLD'
Area = require 'Area'
Point = require 'Point'
Vector = require 'Vector'

require 'table_io'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 600

oldMouse = nil

START_POS = EasyLD.point:new(100,100)

function EasyLD:load()
	EasyLD.window:resize(WINDOW_WIDTH, WINDOW_HEIGHT)

	--[[
	point = EasyLD.point:new(10,10)
	point2 = EasyLD.point:new(20,20)
	point3 = EasyLD.point:new(70, 70)
	boxxx = EasyLD.circle:new(70, 50, 80, EasyLD.color:new(210, 192, 27, 150))
	box2x = boxxx:copy()
	boxxx3 = EasyLD.box:new(70, 70, 50, 50, EasyLD.color:new(210, 192, 27, 150))
	areaaa = EasyLD.area:new(boxxx3)
	areaaa:follow(point3)
	areaa = EasyLD.area:new(box2x)
	areaa:attach(boxxx)
	areaa:follow(point2)
	areaa:attach(point3)
	areaa:attach(areaaa)

	areaaCopy = areaa:copy()
	areaaCopy.forms[#areaaCopy.forms]:follow(areaaCopy.forms[#areaaCopy.forms-1])
	areaaCopy:translate(200, 0)
	areaaCopy.forms[2].c = EasyLD.color:new(255,125,125,125)

	areaa2 = EasyLD.area:new(point)
	areaa2:attach(point2)
	areaa2:attach(areaa)
	areaa2:attach(areaaCopy)]]

	point = EasyLD.point:new(25,50)
	point2 = EasyLD.point:new(0,100)
	point3 = EasyLD.point:new(50,100)
	line = EasyLD.segment:new(EasyLD.point:new(0,100), EasyLD.point:new(0,150))
	line2 = EasyLD.segment:new(EasyLD.point:new(50,100), EasyLD.point:new(50,150))
	areaJambe1 = EasyLD.area:new(line)
	areaJambe2 = EasyLD.area:new(line2)
	areaJambe1:follow(point2)
	areaJambe2:follow(point3)
	line3 = EasyLD.segment:new(EasyLD.point:new(25,50), EasyLD.point:new(0,100))
	line4 = EasyLD.segment:new(EasyLD.point:new(25,50), EasyLD.point:new(50,100))
	areaCuisse1 = EasyLD.area:new(line3)
	areaCuisse2 = EasyLD.area:new(line4)
	areaCuisse1:attach(point2)
	areaCuisse1:attach(areaJambe1)
	areaCuisse2:attach(point3)
	areaCuisse2:attach(areaJambe2)
	areaCuisse1:follow(point)
	areaCuisse2:follow(point)
	box = EasyLD.box:new(5,5, 45, 45)
	areaGlobal = EasyLD.area:new(box)
	areaGlobal:attach(point)
	areaGlobal:attach(areaCuisse1)
	areaGlobal:attach(areaCuisse2)
	areaa2 = areaGlobal

	areaa2:moveTo(START_POS.x,START_POS.y)
	--[[sasa = EasyLD.areaAnimation:new(EasyLD.point:new(200,200), areaa2, {4,4,1}, { {{ease = "expoout", translation = {x = 50, y = 50}}, {rotation = math.pi}, {ease = "backin", translation = {x = -50, y = 50}}, {ease = "backout",rotation = -math.pi}}, 
																{{rotation = math.pi*2}, {translation = {x = -50, y = -50}}, {rotation = math.pi*2}, {translation = {x = -50, y = -50}}},
																{{ease = "expoin", translation = {x = -50, y = -50}, rotation = -math.pi*2}, {rotation = math.pi, translation = {x = 50, y = 50}}, {translation = {x = 50, y = -50}, rotation = -math.pi*2}, {rotation = -math.pi, translation = {x = 50, y = 50}}} }, true)
	]]

	--BEGIN MAIN AREA
	font = EasyLD.font:new("assets/visitor.ttf")
	font:load(20, EasyLD.color:new(0,0,0))
	point = EasyLD.point:new(0,0)
	areaText = EasyLD.area:new(point)

	nb = 1
	box = {}
	areaList = {}
	fontSize = 20
	fullfilAreaText({forms = {areaa2}}, 0)
	--areaText:moveTo(WINDOW_WIDTH-150, 0)
	current = 1

	frame = {{}}
	idFrame = 1
	isComputing = false
	saveFrame()
	newFrame()

	tableAnim8 = {}
	isPlay = false
	oldMouse = EasyLD.mouse:getPosition()
end

function fullfilAreaText(a, stage)
	for i,s in ipairs(a.forms) do
		box[nb] = EasyLD.box:new(stage * 10 + WINDOW_WIDTH - 150, (nb-1)*fontSize, 100, fontSize)
		box[nb].text = string.sub(tostring(s.class), 7, -1)
		box[nb].obj = s
		box[nb].origin = {x = s.x, y = s.y, angle = s.angle}
		areaText:attach(box[nb])
		
		nb = nb + 1
		if s:isInstanceOf(Area) then
			if stage ~= 0 then table.insert(areaList, s) end
			box[nb-1].c = EasyLD.color:new(255,200,200)
			fullfilAreaText(s, stage + 1)
		end
	end

	if stage == 0 then
		boxAreaText = EasyLD.box:new(WINDOW_WIDTH-150, 0, 150, nb * fontSize)
	end
end 

function EasyLD:update(dt)
	local mousePos = EasyLD.mouse:getPosition()

	if EasyLD.mouse:isPressed("l") and EasyLD.collide:AABB_point(boxAreaText, mousePos) then
		for i,v in ipairs(box) do
			if EasyLD.collide:AABB_point(v, mousePos) and i ~= current then
				current = i
				v.c = EasyLD.color:new(200,255,200)
			else
				if v.obj:isInstanceOf(Area) then
					v.c = EasyLD.color:new(255,200,200)
				elseif v.obj.isFollowed then
					v.c = EasyLD.color:new(200,200,255)
				else
					v.c = EasyLD.color:new(255,255,255)
				end
			end
		end
	elseif EasyLD.mouse:isPressed("r") and box[current].obj:isInstanceOf(Area) then
		vOld = Vector:of(box[current].obj.follower, mousePos)
		vOldAngle = box[current].obj.angle
	end
	if EasyLD.mouse:isDown("r") and box[current].obj:isInstanceOf(Area) then
		local p = EasyLD.point:new(box[current].origin.x, box[current].origin.y)
		local vMouseOld = Vector:of(box[current].obj.follower, oldMouse)
		local vNew = Vector:of(box[current].obj.follower, mousePos)
		local angleNewOld = vNew:getAngle() - vOld:getAngle()
		local angleDirection = vNew:getAngle() - vMouseOld:getAngle()
		if angleDirection > 0 then
			if angleNewOld < 0 then angleNewOld = angleNewOld + math.pi*2 end
		elseif angleDirection < 0 then
			if angleNewOld >= 0 then angleNewOld = angleNewOld - math.pi*2 end
		end 
		if angleDirection ~= 0 then
			box[current].obj:rotateTo(angleNewOld + vOldAngle)
		end
	end
	if EasyLD.mouse:isDown("l") and not EasyLD.collide:AABB_point(boxAreaText, mousePos) 
		and box[current].obj:isInstanceOf(Area) then
		box[current].obj:moveTo(mousePos:get())
	end

	if EasyLD.keyboard:isPressed("s") then
		saveFrame()
	elseif EasyLD.keyboard:isPressed("f") then
		newFrame()
	elseif EasyLD.keyboard:isPressed("q") then
		idFrame = idFrame - 1
		if idFrame < 1 then idFrame = #frame end
		goFrame()
	elseif EasyLD.keyboard:isPressed("d") then
		idFrame = idFrame + 1
		if idFrame > #frame then idFrame = 1 end
		goFrame()
	elseif EasyLD.keyboard:isPressed("p") then
		play()
	elseif EasyLD.keyboard:isPressed("v") then
		saveAnim()
	end

	oldMouse = mousePos
end

function saveAnim()
	table.save(tableAnim8, "assets/anim8.anim8")
	table.save(frame[1], "assets/anim8.anim8init") --attention la frame est décalé de 100 100 actuellmenet
end

function saveFrame()
	areaa2:moveTo(0,0)
	local t = {}
	for i,v in ipairs(areaList) do
		table.insert(t, {x = v.x, y = v.y, angle = v.angle})
	end
	frame[idFrame] = t
	tprint(t)
	areaa2:moveTo(START_POS:get())
end

function newFrame()
	idFrame = idFrame + 1
	if idFrame <= #frame then
		for i = #frame, idFrame, -1 do
			frame[i + 1] = frame[i]
		end
	end
	frame[idFrame] = {}
end

function goFrame()
	for i,v in ipairs(frame[idFrame]) do
		areaList[i]:rotateTo(v.angle)
		areaList[i]:moveTo(v.x, v.y)
	end
end

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))      
    else
      print(formatting .. v)
    end
  end
end

function compute()
	areaa2:moveTo(0,0)
	tableAnim8 = {}
	tableTime = {}

	for i = 2, #frame+1 do
		idFrame = i - 1
		goFrame()
		local f = frame[i] or frame[1]
		local t = {}

		for i,v in ipairs(f) do
			local tArea = {}
			if areaList[i].angle ~= v.angle then
				tArea.rotation = v.angle - areaList[i].angle
				areaList[i]:rotateTo(v.angle)
			end

			local vTest = Vector:new(areaList[i].x - v.x, areaList[i].y - v.y)
			if vTest:length() >= 1 then
				local p = Point:new(v.x, v.y)
				local p2 = Point:new(areaList[i].x, areaList[i].y)
				local vTr = Vector:of(p, p2)
				vTr:rotate(-areaList[i].angle)
				
				tArea.translation = {x = -vTr.x, y = -vTr.y}
				areaList[i]:moveTo(v.x, v.y)
			end
			table.insert(t, tArea)
		end

		table.insert(tableAnim8, t)
		table.insert(tableTime, 2)
	end

	tprint(tableAnim8)
end

function play()
	if not isPlay then
		idFrame = 1
		goFrame()
		isPlay = true
		compute()
		idFrame = 1
		goFrame()
		sasa = EasyLD.areaAnimation:new(EasyLD.point:new(100,100), areaa2, tableTime, tableAnim8, true)
		sasa:play()
	else
		isPlay = false
		sasa:stop()
		areaa2:moveTo(100,100)
	end
end

function EasyLD:draw()
	areaa2:draw()
	areaText:draw()
	for i,v in ipairs(box) do
		font:print(v.text, fontSize, v, "left", "center", EasyLD.color:new(0,0,0))
	end
	font:print("Frame: " .. idFrame .. "/" .. #frame, fontSize, EasyLD.box:new(0, WINDOW_HEIGHT-50, 50, 50), nil, nil, EasyLD.color:new(255,255,255))
end