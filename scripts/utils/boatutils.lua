-- scripts\utils\boatutils.lua
local BoatUtils = Class(function(self, name)
    -- Base utilities initialization
    name = name or "boatutils"
    self.name = name
    self.boat_control_range = 5
end)

function BoatUtils:IsAnchor(inst)
    return inst.prefab == "anchor"
end

function BoatUtils:IsMast(inst)
    return inst.prefab == "mast" or inst.prefab == "mast_malbatross"
end

function BoatUtils:FindSpecificEntities(inst, radius, fn)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, radius)

    local valid_ents = {}
    for _, ent in ipairs(ents) do
        if ent ~= inst and ent.entity:IsVisible() and (fn == nil or fn(ent, inst)) then
            table.insert(valid_ents, ent)
        end
    end
    return valid_ents
end

return BoatUtils