local function CreateDeployableItemFn(prefabToSpawn)
    return function(inst)
        if inst and not inst.components.deployable then
            inst:AddComponent("deployable")
            inst.components.deployable.ondeploy = function(item, pt)
                GLOBAL.SpawnPrefab(prefabToSpawn).Transform:SetPosition(pt:Get())
                item.components.stackable:Get():Remove()
            end
            inst.components.deployable:SetDeploySpacing(DEPLOYSPACING["NONE"])
        end
    end
end

local deployable_items = {
    cutreeds = "reeds",
    petals = "flower_rose",
}

for prefab, spawnPrefab in pairs(deployable_items) do
    AddPrefabPostInit(prefab, CreateDeployableItemFn(spawnPrefab))
end