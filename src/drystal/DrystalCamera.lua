function Camera.scale(scale)
	drystal.camera.zoom = scale
end

function Camera.move(dx, dy)
	drystal.camera.x = drystal.camera.x + dx
	drystal.camera.y = drystal.camera.y + dy
end

function Camera.rotate(angle, ox, oy)
	if ox ~= nil and oy ~= nil then

	elseif Camera.follower ~= nil then

	else
		--Camera.ox Camera.oy Currently : rotation around the center of the screen
	end

	drystal.camera.angle = drystal.camera.angle + angle
end