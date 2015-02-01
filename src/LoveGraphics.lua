local LoveGraphics = {}

function LoveGraphics:rectangle(mode, box, colorR, colorG, colorB, colorA)
	local r, g, b, a = love.graphics.getColor()

	if colorR ~= nil and colorG ~= nil and colorB ~= nil then
		if colorA == nil then
			colorA = 255
		end
		love.graphics.setColor(colorR, colorG, colorB, colorA)
	end

	love.graphics.rectangle(mode, box.x, box.y, box.w, box.h)
	love.graphics.setColor(r, g, b, a)
end

function LoveGraphics:circle(mode, circle, nbSeg, colorR, colorG, colorB, colorA)
	local r, g, b, a = love.graphics.getColor()

	if colorR ~= nil and colorG ~= nil and colorB ~= nil then
		if colorA == nil then
			colorA = 255
		end
		love.graphics.setColor(colorR, colorG, colorB, colorA)
	end

	love.graphics.circle(mode, circle.x, circle.y, circle.r, nbSeg)
	love.graphics.setColor(r, g, b, a)
end

function LoveGraphics:polygon(mode, ...)
	local p = {}
	
	for i,v in ipairs({...}) do
		table.insert(p, v.x)
		table.insert(p, v.y)
	end

	love.graphics.polygon(mode, unpack(p))
end

return LoveGraphics