local LoveGraphics = {}

function LoveGraphics:rectangle(mode, box, color)
	local r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(color.r, color.g, color.b, color.a)

	love.graphics.rectangle(mode, box.x, box.y, box.w, box.h)
	love.graphics.setColor(r, g, b, a)
end

function LoveGraphics:circle(mode, circle, nbSeg, color)
	local r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(color.r, color.g, color.b, color.a)

	love.graphics.circle(mode, circle.x, circle.y, circle.r, nbSeg)
	love.graphics.setColor(r, g, b, a)
end

function LoveGraphics:polygon(mode, color, ...)
	local p = {}
	local r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(color.r, color.g, color.b, color.a)

	for i,v in ipairs({...}) do
		table.insert(p, v.x)
		table.insert(p, v.y)
	end

	love.graphics.polygon(mode, unpack(p))
	love.graphics.setColor(r, g, b, a)
end

return LoveGraphics