function IS_DST()
	return TheSim:GetGameID() == "DST"
end

local ArchorButton = require("widgets/archorbutton")
local MastButton = require("widgets/mastbutton")

-- The file path for the data is dynamically constructed based on whether the game is 'Don't Starve Together' (DST). 
-- If IS_DST is true, it appends '_CLIENT' to the file path, indicating a client-specific configuration for DST. 
-- Otherwise, it uses the base file path 'mod_config_data/Boat_Save_Data' or 'mod_config_data/Boat_Save_Data_CLIENT'
BoatSaveData = require("utils/savedata")("mod_config_data/Boat_Save_Data" .. (IS_DST() and "_CLIENT" or ""));

local function MakeButton(controls, button)
    -- Set the button's position to the saved position
	button:SetOnDragFinish(function(oldpos, newpos)
		BoatSaveData:Set(button.key_position, newpos)
		BoatSaveData:Save(function(success)
		end)
	end)

    -- Only show the button when the player is near a boat
    button.inst:DoPeriodicTask(0.5, function()
        if button:IsVisible() then
            button:Show()
        else
            button:Hide()
        end
	end)

    -- Load the saved position, or reset the position if it doesn't exist
	local saved_pos = BoatSaveData:Get(button.key_position)
	if saved_pos ~= nil then
		button:SetPosition(saved_pos.x, saved_pos.y, saved_pos.z)
    else
        button:ResetPosition()
	end

	return button
end

AddClassPostConstruct("widgets/controls", function(controls)
    local archor_button = ArchorButton()
    local mast_button = MastButton()

    -- Load the saved data
    BoatSaveData:Load()
    controls.bottomright_root:AddChild(MakeButton(controls, archor_button))
    controls.bottomright_root:AddChild(MakeButton(controls, mast_button))

	print("Button Added")
end)
