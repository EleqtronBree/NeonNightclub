--[[
Author(s): Electra Bree

Manages the player XP
]]--

--// Awards extra stats to a given player who dances in-game
function award_dance_bonus_xp(player, xp)
	if player.PlayerData.Dancing.Value == true then
		player.PlayerData.XP.Value = player.PlayerData.XP.Value + xp
	end
end

--// Awards XP to a given player for being in-game for some time
function award_xp(player, xp)
	player.PlayerData.XP.Value = player.PlayerData.XP.Value + xp
end

--// Updates XP every 60 seconds
while wait(60) do 
	for index, player in pairs(game.Players:GetChildren()) do
		player.PlayerData.TimeWasted.Value = player.PlayerData.TimeWasted.Value + 1
		if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, 6739507) == true then
			award_xp(player, 6)
			award_dance_bonus_xp(player, 2)
		else
			award_xp(player, 3)
			award_dance_bonus_xp(player, 1)
		end
	end
end