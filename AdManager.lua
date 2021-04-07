--[[
Author(s): Electra Bree

This script loads all ads from a Trello list into the ad boards in the game's workspace
This uses the Trello API
]]--

--// Variables
api = require(game.ServerScriptService.TrelloBrain)
board = api:GetBoardID("Advertisement")
list = api:GetListID("Approved", board)

--// Refreshes and loads the ads every 10 seconds
while wait(10) do
	local ad_table = api:GetCardsInList(list) --// some users may purchase ad space in-game and needs to be redefined in this loop
	game.ReplicatedStorage.SetAd:Fire(ad_table, 10)
end