local function AddProtectionWallComponent(inst)
    inst:AddComponent("protectionwall")
    inst.components.protectionwall:SetRadius(10)

    inst:ListenForEvent("onbuilt", function(inst)
        inst.components.protectionwall:CreateWalls()
    end)

    local old_onfinish = inst.components.workable.onfinish
    inst.components.workable.onfinish = function(inst, worker, ...)
        inst.components.protectionwall:RemoveWalls()
        old_onfinish(inst, worker, ...)    
    end
end

AddPrefabPostInit("campfire", AddProtectionWallComponent)
AddPrefabPostInit("firepit", AddProtectionWallComponent)
AddPrefabPostInit("coldfire", AddProtectionWallComponent)
AddPrefabPostInit("coldfirepit", AddProtectionWallComponent)
