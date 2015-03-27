local Window = {}

function Window:resize(W, H)
	drystal.resize(W, H)
end

function Window:setTitle(title)
	drystal.set_title(title)
end

function Window:setFullscreen(bool)
	drystal.set_fullscreen(bool)
end

return Window