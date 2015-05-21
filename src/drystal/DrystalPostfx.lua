local Postfx = {}

function Postfx:add(name, code, uniforms)
	return drystal.add_postfx(name, code, uniforms
end

function Postfx:use(name, uniforms)
	drystal.postfx(name, uniforms)
end

return Postfx