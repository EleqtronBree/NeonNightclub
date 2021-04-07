--[[
Author(s): Electra Bree

This script manages server-sided execution of UI code
These global functions are being used by more than one script (the shop and dance menus) and are placed here for easier maintenance
]]--

--// Resets all the pages in shop - back to page 1 by default
_G["reset_pages_in_shop"] = function(shop_folder)
	for index, menu in pairs(shop_folder:GetChildren()) do
		if menu:IsA("Frame") then
			for index, page in pairs(menu:GetChildren()) do
				if page:IsA("Frame") then
					page.Visible = false
				end
			end
			menu["Page 1"].Visible = true
		end
	end
end

--// Makes all category UI invisible
_G["make_all_category_frames_invisible"] = function(ui)
	for index, menu in pairs(ui:GetChildren()) do
		if menu:IsA("Frame") and menu.Name ~= "Holder" then
			menu.Visible = false
		end
	end
end

--// Gets the current and max page number in a given category UI
_G["get_page_numbers"] = function(category)
	local page_number, max_page_number
	for index, frame in pairs(category:GetChildren()) do
		if frame:IsA("Frame") then
			max_page_number = tonumber(string.match(frame.Name, "%d+"))
			if frame.Visible == true then
				page_number = tonumber(string.match(frame.Name, "%d+"))
			end
		end
	end
	return page_number, max_page_number
end

--// Gets the category UI that is visible to the player for a given UI folder
_G["get_category"] = function(parent)
	local category
	for index, frame in pairs(parent:GetChildren()) do
		if frame:IsA("Frame") and frame.Visible == true then
			category = frame
		end
	end
	return category
end

--// Resets the pages for a given category UI - back to page 1 by default
_G["reset_page"] = function(category, parent)
	parent.ImageLabel.TextLabel.Text = "Page 1"
	local total_pages = 0
	for index, page in pairs(category:GetChildren()) do
		if page:IsA("Frame") then
			total_pages = total_pages + 1
		end
	end
	parent.Previous.Visible = false
	if total_pages > 1 then
		parent.Next.Visible = true
	else
		parent.Next.Visible = false
	end
end

--// Resets the pages in the menu UI's children
_G["reset_menu"] = function(menu)
	local pages = menu:GetChildren()
	for index, page in pairs(pages) do
		if page:IsA("Frame") and page.Name ~= "1" then
			page.Visible = false
		elseif page.Name == "1" then
			page.Visible = true
		end
	end
end

