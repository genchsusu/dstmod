-- scripts\widgets\archorbutton.lua
local BaseButton = require "widgets/basebutton"
local BoatUtils = require "utils/BoatUtils"

ArchorButton = Class(BaseButton, function(self)
    local name = "archorbutton"
    -- atlas, normal, focus, disabled, down, selected, scale, offset
    BaseButton._ctor(self , "images/archor.xml", "archor.tex")

    self:SetDraggable(true)
    self:SetInitPosition(Vector3(210, 80, 0))
    self.boat_utils = BoatUtils()
    self.key_position = name .. "_position"

    self:SetOnClick(function() self:OnClickfn() end)
end)

function ArchorButton:OnClickfn()
    print("Archor button clicked")

    local anchors = self.boat_utils:FindSpecificEntities(ThePlayer, self.boat_utils.boat_control_range, function(inst) return self.boat_utils:IsAnchor(inst) end)
    local total_count = #anchors
    local raised_count = 0
    print("Number of anchor found: " .. total_count)

    for _, anchor in ipairs(anchors) do
        if anchor:HasTag("anchor_raised") then
            raised_count = raised_count + 1
        end
    end

    local raise_all = raised_count <= total_count / 2

    for _, anchor in ipairs(anchors) do
        if raise_all and (not anchor:HasTag("anchor_raised") or anchor:HasTag("anchor_transitioning")) then
            local agent = SpawnPrefab(ThePlayer.prefab)
            agent.Transform:SetPosition(anchor.Transform:GetWorldPosition())
            agent.AnimState:SetMultColour(1, 1, 1, 0)
            local act = BufferedAction(agent, anchor, ACTIONS.RAISE_ANCHOR)
            agent.components.locomotor:PushAction(act, true) 
            local remove_time = anchor.components.anchor:GetCurrentDepth()
            print("Removing anchor in " .. remove_time .. " seconds")
            agent:DoTaskInTime(remove_time, function()
                agent:Remove()
            end)
        elseif not raise_all and anchor:HasTag("anchor_raised") and not anchor:HasTag("anchor_transitioning") then
            anchor.components.anchor:StartLoweringAnchor()
        end
    end
end

function ArchorButton:IsVisible()
    local target = FindEntity(ThePlayer, self.boat_utils.boat_control_range, function(inst)
        return self.boat_utils:IsAnchor(inst)
    end)
    
    return target ~= nil
end

return ArchorButton