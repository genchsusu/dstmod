AddPrefabPostInit("perd", function(inst)
    if inst and not inst.components.periodicspawner then
        inst:AddComponent("periodicspawner")
        inst.components.periodicspawner:SetPrefab("bird_egg")
        inst.components.periodicspawner:SetRandomTimes(10, 60)
        inst.components.periodicspawner:Start()
    end
end)