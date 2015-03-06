local class = require 'middleclass'

local Playlist = class('Playlist')

function Playlist:initialize(name, type, random)
	self.name = name
	self.type = type --Type of the stop/play fct (fading etc)
	self.list = {}
	EasyLD.sound.playlists[name] = self
	self.timer = nil
	self.current = 1
	self.random =  random or false
end

function Playlist:add(music)
	table.insert(self.list, music)
end

function Playlist:remove(id)
	if id <= #self.list then
		table.remove(id)
	end
end

function Playlist:play(str)
	if self.random then
		self.current = math.random(1, #self.list)
	elseif str == "next" then
		self.current = self.current % #self.list + 1
	end

	self.list[self.current]:play()
	self.timer = EasyLD.timer.after(self.list[c]:length(), self, "play", "next")
end

function Playlist:stop()
	EasyLD.timer.cancel(self.timer)
	self.timer = nil
	self.list[self.current]:stop()
end

return Playlist