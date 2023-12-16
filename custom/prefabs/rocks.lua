-------------------------------------------------------------------------
-- Rocks never disappear
local function ModifyRockPrefab(inst)
    local old_onwork = inst.components.workable.onwork
    inst.components.workable.onwork = function(inst, worker, workleft, ...)
        inst.components.workable.workleft = 10
        inst.doNotRemoveOnWorkDone = true
        if old_onwork then
            old_onwork(inst, worker, workleft, ...)
        end
    end
end

local rocks = {
    "rock1", "rock2", 
    "rock_flintless", "rock_flintless_med", "rock_flintless_low", 
    "rock_petrified_tree", "rock_petrified_tree_med", "rock_petrified_tree_tall", "rock_petrified_tree_short", "rock_petrified_tree_old",
    "rock_moon", "rock_moon_shell", 
    "moonglass_rock"
}

for _, rock in ipairs(rocks) do
    AddPrefabPostInit(rock, function(inst)
        ModifyRockPrefab(inst)
    end)
end


-------------------------------------------------------------------------
-- Add more loot to rocks
local function AddLoot(prefab, loot, value)
    if type(prefab) == "table" then
        for _, v in ipairs(prefab) do
            AddLoot(v, loot, value)
        end
        return
    end

    -- Create table if needed
    LootTables[prefab] = LootTables[prefab] or {}

    --Divide loot into single objects, for example 1.5 bluegem will be 2 bluegem with 50% chance
    while value > 0.01 do
        local val = value > 1 and 1 or value
        table.insert(LootTables[prefab], {loot, val})
        value = value - val
    end
end

local function PreInitLoot()
    AddLoot("rock1", "rocks", 10.00)
    AddLoot("rock1", "nitre", 5.00)
    AddLoot("rock1", "flint", 5.00)
    AddLoot("rock1", "marble", 5.00)
    AddLoot("rock1", "gears", 5.0)

    AddLoot("rock2", "goldnugget", 10.00)
    AddLoot("rock2", "marble", 5.00)
    AddLoot("rock2", "gears", 5.0)


    AddLoot("rock_moon", "moonrocknugget", 8.00)
    AddLoot("rock_moon_shell", "moonrocknugget", 8.00)
    AddLoot("rock_moon_glass", "moonglass", 8.00)
    local others = {
        "rock_flintless", "rock_flintless_med", "rock_flintless_low", 
        "rock_petrified_tree", "rock_petrified_tree_med", "rock_petrified_tree_tall", "rock_petrified_tree_short", "rock_petrified_tree_old",
    }
    AddLoot(others,'bluegem', 1.50)
    AddLoot(others,'redgem', 1.50)
    AddLoot(others,'orangegem',  1.50)
    AddLoot(others,'yellowgem', 1.50)
    AddLoot(others,'greengem', 1.50)
    AddLoot(others,'purplegem',  1.50)
    AddLoot(others,'thulecite', 1.50)
end

local function GetGlobal(globalName, defaultValue)
    local result = GLOBAL.rawget(GLOBAL, globalName)
    if defaultValue ~= nil and result == nil then
        GLOBAL.rawset(GLOBAL, globalName, defaultValue)
        return defaultValue
    end
    return result
end

local is_forest
local function ForestInit(inst)
    if is_forest then return end
    is_forest = true

    LootTables = GetGlobal("LootTables", {})
    PreInitLoot()
end

AddPrefabPostInit("world", ForestInit)
AddPrefabPostInit("forest", ForestInit)