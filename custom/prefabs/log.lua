local function onburnt(inst)
    local number = 10
    for i = 1, number do
        SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())
        SpawnPrefab("charcoal").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end

    inst:Remove()
end

AddPrefabPostInit("log", function(inst)
    if inst.components.burnable then
        inst.components.burnable:SetOnBurntFn(onburnt)
    end
end)
