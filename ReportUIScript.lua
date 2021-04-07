--[[
Author(s): Electra Bree

This script manages the client events for the report UI, which listens for server calls
This pops up a notification in the staff notification UI, alerting them to assist the client that called it.
]]--

--// Variables
staff_notify = game.ReplicatedStorage:FindFirstChild("StaffNotify")
ui = script.Parent

--// Runs the alert for the notification UI to catch staffs' attention
function timer(frame, respond_wait)
	local color = frame.Background.ImageColor3
	for count = 1,respond_wait do
		frame.Background.ImageColor3 = Color3.fromRGB(90,0,0)
		wait(0.5)
		frame.Background.ImageColor3 = color
		wait(0.5)
	end
	frame:Destroy()
	ui.Notifications.Visible = false
	ui.Notifications.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ui.Notifications.CanvasSize = UDim2.new(0, 0, 0, ui.Notifications.UIListLayout.AbsoluteContentSize.Y)
	end)
end

--// Triggered when the server requests the staff clients for assistance
staff_notify.OnClientEvent:connect(function(player, respond_wait)
	local frame = script.Frame:Clone()
	frame.Name = player.Name
	frame:WaitForChild("Title").Text = string.upper(player.Name).." NEEDS HELP!"
	wait()
	frame.Parent = ui.Notifications
	ui.Notifications.Visible = true
	ui.Notifications.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		ui.Notifications.CanvasSize = UDim2.new(0, 0, 0, ui.Notifications.UIListLayout.AbsoluteContentSize.Y)
	end)	
	timer(frame, respond_wait)
end)