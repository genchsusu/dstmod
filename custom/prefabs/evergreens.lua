local function ModifyTreeLoot(inst)
    print("Modifying tree loot for: " .. inst.prefab)

    local oldOnBurntFn = inst.components.burnable.onburnt
    inst.components.burnable:SetOnBurntFn(function(inst)
        oldOnBurntFn(inst)
        print("Burnt: " .. inst.prefab)

        local charcoal_number = 10
        for i = 1, charcoal_number do
            inst.components.lootdropper:SpawnLootPrefab("charcoal")
        end
    end)

    if inst.components.lootdropper then
        print("Setting loot for: " .. inst.prefab)
        inst.components.lootdropper:SetLoot({"log", "log", "log", "log", "log", "log", "log", "log", "log", "log", "pinecone", "pinecone"})
    end
end

local trees = {
    "evergreen", "evergreen_short", "evergreen_normal", "evergreen_tall",
    "evergreen_sparse", "evergreen_sparse_short", "evergreen_sparse_normal", "evergreen_sparse_tall"
}

for _, tree in ipairs(trees) do
    AddPrefabPostInit(tree, ModifyTreeLoot)
end