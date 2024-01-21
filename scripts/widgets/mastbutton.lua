-- scripts\widgets\mastbutton.lua
local BaseButton = require "widgets/basebutton"
local BoatUtils = require "utils/BoatUtils"

MastButton = Class(BaseButton, function(self)
    local name = "mastbutton"
    -- atlas, normal, focus, disabled, down, selected, scale, offset
    BaseButton._ctor(self , "images/mast.xml", "mast.tex")

    self:SetDraggable(true)
    self:SetInitPosition(Vector3(110, 80, 0))
    self.boat_utils = BoatUtils()
    self.key_position = name .. "_position"

    self:SetOnClick(function() self:OnClickfn() end)
end)

function MastButton:OnClickfn()
    print("Mast button clicked")
    local tags = {"sailraised", "saillowered"}
    local masts = self.boat_utils:FindSpecificEntities(ThePlayer, self.boat_utils.boat_control_range, function(inst) return self.boat_utils:IsMast(inst) end)
    local total_count = #masts
    local raised_count = 0
    print("Number of masts found: " .. total_count)

    for _, mast in ipairs(masts) do
        for _, tag in ipairs(tags) do
            if mast:HasTag(tag) then
                print(mast.prefab .. "has tag" .. tag)
            end
        end

        -- Stupid Developer: "It's not a bug, it's a feature."
        local sail_raised = mast:HasTag("sailraised")
        if mast.prefab == "mast_malbatross" then
            sail_raised = not sail_raised
        end

        if sail_raised then
            raised_count = raised_count + 1
        end
    end

    local raise_all = raised_count <= total_count / 2

    for _, mast in ipairs(masts) do

        local sail_raised = mast:HasTag("sailraised")
        if mast.prefab == "mast_malbatross" then
            sail_raised = not sail_raised
        end
    
        if raise_all and not sail_raised then
            print("Raising sail for mast")
            if mast.prefab == "mast_malbatross" then
                local agent = SpawnPrefab(ThePlayer.prefab)
                agent.Transform:SetPosition(mast.Transform:GetWorldPosition())
                agent.AnimState:SetMultColour(1, 1, 1, 0)
                agent:DoTaskInTime(0, function()
                    local act = BufferedAction(agent, mast, ACTIONS.LOWER_SAIL_BOOST)
                    agent.components.locomotor:PushAction(act, true)
                end)
                agent:DoTaskInTime(4.5, function()
                    agent:Remove()
                end)
            else
                mast.components.mast:UnfurlSail()
            end
        elseif not raise_all and sail_raised then
            print("Lowering sail for mast")
            if mast.prefab == "mast_malbatross" then
                mast.components.mast:UnfurlSail()
            else
                local agent = SpawnPrefab(ThePlayer.prefab)
                agent.Transform:SetPosition(mast.Transform:GetWorldPosition())
                agent.AnimState:SetMultColour(1, 1, 1, 0)
                agent:DoTaskInTime(0, function()
                    local act = BufferedAction(agent, mast, ACTIONS.LOWER_SAIL_BOOST)
                    agent.components.locomotor:PushAction(act, true) 
                end)
                agent:DoTaskInTime(4.5, function()
                    agent:Remove()
                end)
            end
        end
    end
end

function MastButton:IsVisible()
    local target = FindEntity(ThePlayer, self.boat_utils.boat_control_range, function(inst)
        return self.boat_utils:IsMast(inst)
    end)
    
    return target ~= nil
end

return MastButton



