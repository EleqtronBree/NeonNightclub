--[[
Author(s): Electra Bree & Aaron Spivey

This script manages the music system - it chooses, plays and stops music and repeats
]]--

--// Variables
api = require(game.ServerScriptService.TrelloBrain)
board = api:GetBoardID("Music")
color_debounce = false
music_folder = Instance.new("Folder", game.ServerStorage)
sound = workspace:WaitForChild("Envia Music")
_G.system_ready = false
debounce = false
local current_song

--// Arrays
_G.request_queue = {}

if not game.ReplicatedStorage:FindFirstChild('ChangeColor') then
	local Event = Instance.new('RemoteEvent',game.ReplicatedStorage)
	Event.Name = 'ChangeColor'
end

--// Loads the song into the game's workspace
function load_music()
	pcall(function()
		game.ServerStorage:FindFirstChild("Music"):Destroy()
	end)
	music_folder.Name = "Music"
	for index, genre in pairs(api:GetLists(board)) do
		if genre.name ~= "Generic" then
			local genre_folder = Instance.new("Folder", music_folder)
			genre_folder.Name = genre.name
			local genre_id = api:GetListID(genre.name, board)
			for index, song in pairs(api:GetCardsInList(genre_id)) do
				local string_value = Instance.new("StringValue", genre_folder)
				string_value.Name = song.name
				string_value.Value = song.desc
				local requested_value = Instance.new("StringValue", string_value)
				requested_value.Name = "Requester"
				requested_value.Value = "Song chosen by Envia"
			end
		end
	end
	_G.system_ready = true
end

--// Returns a random song object
function get_random_song()
	local genres = music_folder:GetChildren()
	local random_number = math.random(1, #genres)
	local chosen_genre = genres[random_number]
	local songs = chosen_genre:GetChildren()
	local random_number = math.random(1, #songs)
	return songs[random_number]
end

--// Returns a song that is first in the song request queue
function get_song_in_request_queue()
	if debounce then return end
	debounce = true
	local song = _G.request_queue[1]
	table.remove(_G.request_queue, 1)
	wait(0.1)
	debounce = false
	_G.update_queue()
	return song
end

--// Chooses a random or requested song based on whether the queue is empty or not and returns the song object
function choose_song()
	local song
	if #_G.request_queue == 0 then
		song = get_random_song()
		song.Requester.Value = "Song chosen by Envia"
	else 
		song = get_song_in_request_queue()
	end
	return song
end

--// Plays the song in-game
_G["play_song"] = function()
	repeat wait() until _G.system_ready
	while wait() do
		sound.TimePosition = 0
		game.ReplicatedStorage['NewSong']:FireAllClients()
		local next_song = choose_song()
		local id = string.match(next_song.Value, "%d+")
		local pitch = string.match(next_song.Value, "%d+ (.+)")
		sound.SoundId = "rbxassetid://"..id
		sound.PlaybackSpeed = pitch or 1
		sound.TimePosition = 0
		sound.Volume = 2
		current_song = next_song.Name
		sound.SongName.Value = next_song.Name
		sound.Requester.Value = next_song.Requester.Value
		if not sound.IsLoaded then -- sometimes songs don't like to play
			sound.Loaded:wait()
		end
		sound:Play()
		sound.Ended:Wait()
	end
end

--// This changes the colors of the visualizer in-game
function change_effects_colors()
	for index, visualiser in pairs(workspace["DJ Booth"]["Visualizer Panel"]["Visualizer"]:GetChildren()) do
		visualiser.Color = workspace["DiscoBall"]["ControlledEffect"].Color
	end
	workspace["DJ Booth"].Sign.Color = workspace["DiscoBall"]["ControlledEffect"].Color
	for index, laser in pairs(workspace["DiscoBall"]["Lasers"]:GetChildren()) do
		laser.Color = workspace["DiscoBall"]["ControlledEffect"].Color
	end
end

--// This manages the colors of the visualizer, lazers and other objects in-game
game.ReplicatedStorage['ChangeColor'].OnServerEvent:connect(function()
	if color_debounce then return end
	color_debounce = true
	local ui_color, ball_color = require(script.Colors).generate_both_color_types()
	workspace["DiscoBall"]["ControlledEffect"].Color = ball_color
	workspace["DiscoBall"]["DiscoEffect"].Color = ball_color
	change_effects_colors()
	local laser_table = workspace.LaserSystem.LaserEmitter.Lasers:GetChildren()
	local number = math.random(1, #laser_table)
	local random_laser = laser_table[number]
	for index, laser in pairs(workspace.LaserSystem.LaserEmitter.Lasers:GetChildren()) do
		laser.Enabled = false
	end
	random_laser.Enabled = true
	wait(1.5)
	color_debounce = false
end)

--// Sets up and starts playing songs
load_music()
_G.play_song()