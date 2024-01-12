local _G = GLOBAL
local TheSim = _G.TheSim
local Sleep = _G.Sleep
local FRAMES = _G.FRAMES
local STRINGS = _G.STRINGS

local default_showoceanfish = true
local show_only_euqiprod = true

local function InGame()
    return _G.ThePlayer and _G.ThePlayer.HUD and not _G.ThePlayer.HUD:HasInputFocus()
end

local function EquipRod(inst)
    if inst and inst.replica.inventory then
        local equiped_hands = inst.replica.inventory:GetEquippedItem("hands")
        return equiped_hands and equiped_hands.prefab == "oceanfishingrod"
    end
    return nil
end

local function CreateLabel(fish)
    local label = fish.entity:AddLabel()
    label:SetFontSize(15)
    label:SetFont(_G.BODYTEXTFONT)
    label:SetWorldOffset(0, 1, 0)
    label:SetColour(1, 1, 1)
    label:Enable(true)
    return label
end

local function ApplyColour(fish)
    if fish.prefab == "oceanfish_small_7" then
        fish.entity:AddLabel():SetColour(0, 1, 0)
    elseif fish.prefab == "oceanfish_small_8" then
        fish.entity:AddLabel():SetColour(1, 0, 0)
    elseif fish.prefab == "oceanfish_small_6" then
        fish.entity:AddLabel():SetColour(1, 165 / 255, 0)
    elseif fish.prefab == "oceanfish_medium_8" then
        fish.entity:AddLabel():SetColour(0, 0, 1)
    else
        fish.entity:AddLabel():SetColour(1, 1, 1)
    end
end

local function GetOceanfishEntities()
    if not _G.ThePlayer then
        return nil, "No _G.ThePlayer for positions"
    end
    local playerpos = _G.ThePlayer:GetPosition()
    local entity_table = TheSim:FindEntities(playerpos.x, 0, playerpos.z, 80, {"oceanfish", "swimming"})
    return entity_table
end

local function StopShowOceanfishThread()
    if not InGame() then
        return
    end
    if _G.ThePlayer and _G.ThePlayer.showoceanfish_thread then
        _G.KillThreadsWithID(_G.ThePlayer.showoceanfish_thread.id)
        _G.ThePlayer.showoceanfish_thread:SetList(nil)
        _G.ThePlayer.showoceanfish_thread = nil
    end
end

local function StartShowOceanfishThread()
    if not InGame() then
        return
    end
    if _G.ThePlayer then
        _G.ThePlayer.showoceanfish_thread = _G.ThePlayer:StartThread(function()
            while _G.ThePlayer and _G.ThePlayer.showoceanfish_thread do
                Sleep(FRAMES)
                if default_showoceanfish and _G.ThePlayer then
                    local ent_table = GetOceanfishEntities()
                    if not ent_table then
                        return nil
                    end
                    for _, ent in pairs(ent_table) do
                        CreateLabel(ent)
                        ApplyColour(ent)
                        local str = STRINGS.NAMES[string.upper(ent.prefab .. "_inv")] or
                                        STRINGS.NAMES[string.upper(ent.prefab)] or nil
                        
                                        
                        -- Show Weight
                        if str and ent.components.weighable and ent.fish_def and ent.fish_def.weight_min and
                            ent.fish_def.weight_max then
                            local weight = math.floor(ent.components.weighable:GetWeightPercent() * 100)
                            if weight >= 70 then
                                str = str .. "\n" .. weight .. "% 󰀫"
                            else
                                str = str .. "\n" .. weight .. "%"
                            end
                        end

                        if str and default_showoceanfish and
                            (show_only_euqiprod == false or (show_only_euqiprod and EquipRod(_G.ThePlayer))) then
                            ent.entity:AddLabel():SetText(str)
                        else
                            ent.entity:AddLabel():SetText("")
                        end
                    end
                else
                    for _, ent in pairs(GetOceanfishEntities() or {}) do
                        if ent then
                            ent.entity:AddLabel():SetText("")
                            ent.entity:AddLabel():Enable(false)
                        end
                    end
                    StopShowOceanfishThread()
                end
            end
        end)
        _G.ThePlayer.showoceanfish_thread.id = "mod_show_oceanfish_thread"
    end
end

AddPlayerPostInit(function(inst)
    inst:DoTaskInTime(1, function()
        if inst == _G.ThePlayer then
            StartShowOceanfishThread()
        end
    end)
end)
