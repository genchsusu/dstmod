local function AddPeriodicSpawnerToPrefab(prefab, spawnPrefab)
    AddPrefabPostInit(prefab, function(inst)
        local function CheckEnvironment()
            local x, y, z = inst.Transform:GetWorldPosition()
            local nearbyEnts = TheSim:FindEntities(x, y, z, 10, nil, {"INLIMBO"})
            
            for _, ent in pairs(nearbyEnts) do
                if ent:HasTag("wall") or ent:HasTag("chest") or ent:HasTag("player") then
                    return true
                end
            end
            return false
        end

        if not inst.components.periodicspawner then
            inst:AddComponent("periodicspawner")
        end
        inst.components.periodicspawner:SetPrefab(spawnPrefab)
        inst:DoPeriodicTask(30, function()
            local shouldSpawn = CheckEnvironment()
            if shouldSpawn then
                inst.components.periodicspawner:Start(0)
            else
                inst.components.periodicspawner:Stop()
            end
        end)
    end)
end

local function RandomSelectItem(items)
    if #items == 0 then
        return nil
    end
    local index = math.random(#items)
    return items[index]
end

-- 猪皮, 兔毛不可食用
local nonEdibleItems = { "manrabbit_tail", "pigskin" }

for _, itemName in ipairs(nonEdibleItems) do
    AddPrefabPostInit(itemName, function(inst)
        inst:RemoveComponent("edible")
    end)
end

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
AddPeriodicSpawnerToPrefab("birds", RandomSelectItem({"guano", "bird_egg"}))
