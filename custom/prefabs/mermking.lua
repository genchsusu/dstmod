local function CustomMermKingPostInit(inst)
    inst:AddDebuff("hungerregenbuff", "hungerregenbuff")

    -- if inst.components.hunger then
    --     inst:RemoveComponent("hunger")
    -- end
end

AddPrefabPostInit("mermking", CustomMermKingPostInit)