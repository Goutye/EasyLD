function Camera.scale(scale, scaleY)
	love.graphics.scale(scale, scaleY or scale)
end

function Camera.move(dx, dy)
	love.graphics.translate(dx, dy)
end

function Camera.rotate(angle, ox, oy)
	if ox ~= nil and oy ~= nil then

	elseif Camera.follower ~= nil then

	else
		--Camera.ox Camera.oy Currently : rotation around the center of the screen
	end

	drystal.camera.angle = angle
end