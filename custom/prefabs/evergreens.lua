local function ModifyTreeLoot(inst)
    local oldOnBurntFn = inst.components.burnable.onburnt
    inst.components.burnable:SetOnBurntFn(function(inst)
        oldOnBurntFn(inst)

        local charcoal_number = 10
        for i = 1, charcoal_number do
            inst.components.lootdropper:SpawnLootPrefab("charcoal")
        end
    end)

    if inst.components.lootdropper then
        inst.components.lootdropper:SetLoot({"log", "log", "log", "log", "pinecone", "pinecone"})
    end
end

local trees = {
    "evergreen", "evergreen_short", "evergreen_normal", "evergreen_tall",
    "evergreen_sparse", "evergreen_sparse_short", "evergreen_sparse_normal", "evergreen_sparse_tall"
}

for i, tree in ipairs(trees) do
    AddPrefabPostInit(tree, ModifyTreeLoot)
end