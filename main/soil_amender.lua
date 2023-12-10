AddPrefabPostInit("soil_amender", function(inst)
    if not inst.components.stackable then
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    end
end)