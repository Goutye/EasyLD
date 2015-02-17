local DrystalFont = {}

function DrystalFont.newFont(src, size)
	return drystal.load_font(src, size)
end

local function _getX_Y(x, y, text, font, box, modeW, modeH)
	if modeW == "center" then
		local w = font:sizeof(text)
		local dir = box.wP:copy()
		dir:normalize()
		dir = dir * w/2

		x,y = x + box.wP.x/2-dir.x, y + box.wP.y/2 -dir.y
	elseif modeW == "right" then
		local w = font:sizeof(text)
		local dir = box.wP:copy()
		dir:normalize()
		dir = dir * w

		x,y = x + box.wP.x - dir.x, y + box.wP.y - dir.y
	end

	if modeH == "center" then
		local _,h = font:sizeof(text)
		local dir = box.hP:copy()
		dir:normalize()
		dir = dir * h/2

		x,y = x + box.hP.x/2-dir.x, y + box.hP.y/2 -dir.y
	elseif modeH == "bottom" then
		local _,h = font:sizeof(text)
		local dir = box.hP:copy()
		dir:normalize()
		dir = dir * h

		x,y = x + box.hP.x-dir.x, y + box.hP.y -dir.y
	end

	return x,y
end

function DrystalFont.printAdapter(text, font, box, modeW, modeH, color)
	drystal.set_color(color.r, color.g, color.b)
	drystal.set_alpha(color.a)

	if box.angle ~= 0 then
		local x,y = _getX_Y(box.x, box.y, text, font, box, modeW, modeH)
	
	
		local surface = drystal.new_surface(font:sizeof(text))
		local screen = surface:draw_on()

		font:draw(text, 0, 0)
		surface:draw_from()
		screen:draw_on()
		
		local sprite = drystal.new_sprite({x=0, y=0, w=surface.w, h=surface.h}, x, y)
		sprite.angle = box.angle
		sprite:draw()
	else
		font:draw(text, _getX_Y(box.x, box.y, text, font, box, modeW, modeH))
	end
end

function DrystalFont.printOutLineAdapter(text, font, box, modeW, modeH, color, colorOut, thickness)
	drystal.set_color(colorOut.r, colorOut.g, colorOut.b)
	drystal.set_alpha(colorOut.a)

	local x,y = _getX_Y(box.x, box.y, text, font, box, modeW, modeH)

	if box.angle ~= 0 then

		local w, h = font:sizeof(text)
		local surface = drystal.new_surface(w + thickness*2, h + thickness*2)
		local screen = surface:draw_on()

		local wP, hP = box.wP:copy(), box.hP:copy()
		wP:normalize()
		hP:normalize()

		local b = {x = x, y = y}

		for i = -thickness,thickness do
			for j = -thickness,thickness do
				if i ~= j or i ~= 0 then
					b.x, b.y = x + i * (wP.x + hP.x), y + j * (wP.y + hP.y)
					font:draw(text, i + thickness, j + thickness)
				end
			end
		end

		drystal.set_color(color.r, color.g, color.b)
		drystal.set_alpha(color.a)
		font:draw(text, thickness, thickness)

		surface:draw_from()
		screen:draw_on()
		
		local sprite = drystal.new_sprite({x=0, y=0, w=surface.w, h=surface.h}, x, y)
		sprite.angle = box.angle
		sprite:draw()
	else
		local b = {x, y}
		for i = -thickness,thickness do
			for j = -thickness,thickness do
				if i ~= j or i ~= 0 then
					b.x, b.y = x + i, y + j
					font:draw(text, b.x, b.y)
				end
			end
		end

		drystal.set_color(color.r, color.g, color.b)
		drystal.set_alpha(color.a)
		font:draw(text, x, y)
	end
end

function DrystalFont.sizeOfAdapter(font, str)
	return font:sizeof(str)
end

return DrystalFont