--[[
Author(s): Electra Bree

This manages the Report System and executes server-sided code for the Report UI
]]--

admin_call = Instance.new("RemoteEvent", game.ReplicatedStorage)
admin_call.Name = "AdminCall"
staff_notify = Instance.new("RemoteEvent", game.ReplicatedStorage)
staff_notify.Name = "StaffNotify"
admin_teleport = Instance.new("RemoteEvent", game.ReplicatedStorage)
admin_teleport.Name = "AdminTeleport"
send_report = Instance.new("RemoteEvent", game.ReplicatedStorage)
send_report.Name = "SendReport"

--// This clones the notification UI and places it on the staffs' screens
function give_notifiers(player)
	if player:GetRankInGroup(2558029) >= 252 then
		player.PlayerGui:WaitForChild("MenuGUI").Holder.Report:Destroy()
		local ui = script.StaffNotifier:Clone()
		ui.Parent = player:WaitForChild("PlayerGui")
	end
end

--// Triggered when a client requests staffs' assistance
admin_call.OnServerEvent:connect(function(player, staff_table, respond_wait)
	for index, staff in pairs(staff_table) do 
		staff_notify:FireClient(staff, player, respond_wait)
	end
end)

--// Triggered when a client sends a report to the Discord server
send_report.OnServerEvent:connect(function(player, offender_name, chat)
	local data = {
		["color"] = "#add8e6",
		["username"] = "Player Report", 
		["content"] = 
		">>> __**Game:**__ [["..game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name.."](https://www.roblox.com/games/"..game.PlaceId..")**".."\n"..
		"`Reporter:` **"..player.Name.."** | [Profile](https://www.roblox.com/users/"..player.UserId..")".."\n"..
		"`Player Reported:` **"..offender_name.."** | [Profile](https://www.roblox.com/users/"..game.Players[offender_name].UserId..")".."\n"..
		"`Chat: "..chat.."`"
	}
	data = game:GetService("HttpService"):JSONEncode(data)
	game:GetService("HttpService"):PostAsync("https://discordapp.com/api/webhooks/727829557226373150/AGSaGwIhUDICpaPRicSPDh52ACs7rQbNixdoD9xe3pqPJ9wUWxtR_pM2NKP4pPrzabfD", data)
end)

game.Players.PlayerAdded:Connect(give_notifiers)




