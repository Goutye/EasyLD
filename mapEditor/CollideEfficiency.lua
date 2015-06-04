local Collide = {}

function Collide:cutInBox(mapCollide, map)
	local boxes = {}
	local isCollide = true
	local tab = {}

	for i = 0, #mapCollide do
		tab[i] = {}
		for j = 0, #mapCollide[i] do
			tab[i][j] = mapCollide[i][j]
		end
	end

	for startJ = 0, map.h-1 do
		for startI = 0, map.w-1 do
			isCollide = tab[startI][startJ] == 1
			if isCollide then
				local maxI, maxJ = 0, 0
				local i, j
				while isCollide do
					if maxI == maxJ then
						i = startI + maxI + 1
						for k = startJ, maxJ+startJ do
							isCollide = isCollide and i < map.w and tab[i][k] == 1
						end
						if isCollide then
							maxI = maxI + 1
						end
					else
						j = startJ + maxJ + 1
						for k = startI, maxI+startI do
							isCollide = isCollide and j < map.h and tab[k][j] == 1
						end
						if isCollide then
							maxJ = maxJ + 1
						end
					end
				end
				isCollide = true
				if maxI == maxJ then --case i failed
					while isCollide do
						j = startJ + maxJ + 1
						for k = startI, maxI+startI do
							isCollide = isCollide and j < map.h and tab[k][j] == 1
						end
						if isCollide then
							maxJ = maxJ + 1
						end
					end
				else --case j failed
					while isCollide do
						i = startI + maxI + 1
						for k = startJ, maxJ+startJ do
							isCollide = isCollide and i < map.w and tab[i][k] == 1
						end
						if isCollide then
							maxI = maxI + 1
						end
					end
				end
				table.insert(boxes, {x = startI, y = startJ, w = maxI+1, h = maxJ+1})
				for i = startI, maxI+startI do
					for j = startJ, maxJ+startJ do
						tab[i][j] = 0
					end
				end
			end
		end
	end

	for _,b in ipairs(boxes) do
		print(b.x, b.y, b.w, b.h)
	end

	return boxes
end

return Collide