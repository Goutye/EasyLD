local class = require 'middleclass'

local Playlist = class('Playlist')

function Playlist:initialize(name, type)
	self.name = name
	self.type = type --Type of the stop/play fct (fading etc)
	self.list = {}
	EasyLD.sound.playlists[name] = self
	self.timer = nil
	self.current = nil
end

function Playlist:add(music)
	table.insert(self.list, music)
end

function Playlist:remove(id)
	if id <= #self.list then
		table.remove(id)
	end
end

function Playlist:play()
	self.current = math.random(1, #self.list)

	self.list[self.current]:play()
	self.timer = EasyLD.timer.after(self.list[c]:length(), self, "play")
end

function Playlist:stop()
	EasyLD.timer.cancel(self.timer)
	self.timer = nil
	self.list[self.current]:stop()
end

return Playlist