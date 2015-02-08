local DrystalGraphics = {}

function DrystalGraphics:rectangle(mode, box, color)
	drystal.set_color(color.r, color.g, color.b)
	drystal.set_alpha(color.a)

	if mode == "fill" then
		drystal.draw_rect(box.x, box.y, box.w, box.h)
	else
		drystal.draw_square(box.x, box.y, box.w, box.h)
	end

	drystal.set_color(255,255,255)
	drystal.set_alpha(255)
end

function DrystalGraphics:circle(mode, circle, nbSeg, color)
	drystal.set_color(color.r, color.g, color.b)
	drystal.set_alpha(color.a)
	
	if mode == "fill" then
		drystal.draw_circle(circle.x, circle.y, circle.r)
	else
		print("NOT IMPLEMENTED YET")
	end

	drystal.set_color(255,255,255)
	drystal.set_alpha(255)
end

function DrystalGraphics:polygon(mode, color, ...)
	local p = {}
	drystal.set_color(color.r, color.g, color.b)
	drystal.set_alpha(color.a)
	
	for i,v in ipairs({...}) do
		table.insert(p, v.x)
		table.insert(p, v.y)
	end

	if mode == "fill" then
		drystal.draw_polygon(unpack(p))
	else
		drystal.draw_polyline(unpack(p))
	end

	drystal.set_color(255,255,255)
	drystal.set_alpha(255)
end

return DrystalGraphics