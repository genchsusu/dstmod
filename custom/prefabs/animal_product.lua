local function AddPeriodicSpawnerToPrefab(prefab, spawnPrefab)
    AddPrefabPostInit(prefab, function(inst)
        if not inst.components.periodicspawner then
            inst:AddComponent("periodicspawner")
        end
        inst.components.periodicspawner:SetPrefab(spawnPrefab)
        inst.components.periodicspawner:SetRandomTimes(10, 60)
        inst.components.periodicspawner:Start()
    end)
end

local function RandomSelectItem(items)
    if #items == 0 then
        return nil
    end
    local index = math.random(#items)
    return items[index]
end

-- 猪不吃猪皮
AddPrefabPostInit("pigskin",function(inst)
    inst:RemoveComponent("edible")
end)

AddPeriodicSpawnerToPrefab("perd", "bird_egg")
AddPeriodicSpawnerToPrefab("rabbit", "manrabbit_tail")
AddPeriodicSpawnerToPrefab("beefalo", RandomSelectItem({"beefalowool", "poop"}))
AddPeriodicSpawnerToPrefab("pigman", "pigskin")
AddPeriodicSpawnerToPrefab("lightninggoat", RandomSelectItem({"lightninggoathorn", "goatmilk"}))
AddPeriodicSpawnerToPrefab("spider", RandomSelectItem({"silk", "spidergland"}))
AddPeriodicSpawnerToPrefab("tallbird", "tallbirdegg")
AddPeriodicSpawnerToPrefab("hound", "houndstooth")
AddPeriodicSpawnerToPrefab("squid", "lightbulb")
AddPeriodicSpawnerToPrefab("spat", "steelwool")
AddPeriodicSpawnerToPrefab("mossling", "goose_feather")
AddPeriodicSpawnerToPrefab("leif", "livinglog")

AddPeriodicSpawnerToPrefab("bee", RandomSelectItem({"honey","honeycomb"}))
AddPeriodicSpawnerToPrefab("waterplant", "barnacle")
