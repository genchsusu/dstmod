local function AddProtectionWallComponent(inst)
    inst:AddComponent("protectionwall")
    inst.components.protectionwall:SetRadius(12)

    inst:ListenForEvent("onbuilt", function(inst)
        inst.components.protectionwall:CreateWalls()
    end)

    local old_onfinish = inst.components.workable.onfinish
    inst.components.workable.onfinish = function(inst, worker, ...)
        inst.components.protectionwall:RemoveWalls()
        old_onfinish(inst, worker, ...)    
    end

    local old_onremove = inst.OnRemoveEntity
    inst.OnRemoveEntity = function(inst)
        inst.components.protectionwall:RemoveWalls()
        if old_onremove then old_onremove(inst) end
    end
end

local items = {"campfire", "firepit", "coldfire", "coldfirepit"}

for _, item in ipairs(items) do
    AddPrefabPostInit(item, AddProtectionWallComponent)
end
