--[[
Author(s): Electra Bree

This script manages gamepass transactions in-game and gives the gamepass perks
]]--

--// Gives items to players when they join the game (already owning the gamepass) or have just completed the transaction
function give_gamepass_perks(player)
	--// Segway gamepass
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, 6311589) or player:GetRankInGroup(2558029) > 1 or not game:GetService("BadgeService"):UserHasBadgeAsync(player.UserId, 2124467231) then
		local segway = game.ServerStorage.Gamepass.HandlessSegway:Clone()
		segway.Parent = player.StarterGear
		local segway = game.ServerStorage.Gamepass.HandlessSegway:Clone()
		segway.Parent = player.Backpack
	end
	--// Jail cell gamepass
	if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, 6703733) or player:GetRankInGroup(2558029) > 1 then
		local jail_cell = game.ServerStorage.Gamepass.JailCell:Clone()
		jail_cell.Parent = player.StarterGear
		local jail_cell = game.ServerStorage.Gamepass.JailCell:Clone()
		jail_cell.Parent = player.Backpack
	end
end

--// Manages the gamepass transactions in-game
game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(function(player, gamepass_id, purchased)
	if player and purchased == true then
		if gamepass_id == 10717879 then
			local shop_menu = player.PlayerGui.MenuGUI.ShopMenu
			shop_menu.ParticlePayOption.Visible = false
			_G.deselect_others(shop_menu.ShopFolder.Particles) -- page
			_G.unequip_particles(player)
			_G.equip_particle(player, shop_menu.ParticlePayOption.Item.Value)
			local selection = shop_menu.ParticlePayOption.Select.Value
			selection.Visible = true
		elseif gamepass_id == 10718851 then
			local shop_menu = player.PlayerGui.MenuGUI.ShopMenu
			shop_menu.TrailPayOption.Visible = false
			_G.deselect_others(shop_menu.ShopFolder.Trails) -- page
			_G.unequip_trail(player)
			_G.equip_trail(player, shop_menu.TrailPayOption.Item.Value)
			local selection = shop_menu.TrailPayOption.Select.Value
			selection.Visible = true
		elseif gamepass_id == 6703597 then
			player.Character.HumanoidRootPart.CFrame = CFrame.new(94.664, 29.11, -1.485)
		elseif gamepass_id == 11170226 then
			--// not yet implemented
		end	
	end
end)

game.Players.PlayerAdded:Connect(give_gamepass_perks)