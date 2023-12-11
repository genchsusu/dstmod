local rock1 = {
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'rocks',  1.00},
    {'nitre',  1.00},
    {'nitre',  1.00},
    {'flint',  1.00},
    {'flint',  1.00},
    {'marble',  1.00},
    {'gears',  1.00},
}

local rock2 = {
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'goldnugget',  1.00},
    {'marble',  1.00},
    {'gears',  1.00},
}

local rock_flintless = {
    {'bluegem',  0.50},
    {'redgem',  0.50},
    {'orangegem',  0.50},
    {'yellowgem',  0.50},
    {'greengem',  0.50},
    {'purplegem',  0.50},
    {'thulecite',  0.50},
}

local rock_flintless_med = {
    {'bluegem',  0.50},
    {'redgem',  0.50},
    {'orangegem',  0.50},
    {'yellowgem',  0.50},
    {'greengem',  0.50},
    {'purplegem',  0.50},
    {'thulecite',  0.50},
}


local rock_flintless_low = {
    {'bluegem',  0.50},
    {'redgem',  0.50},
    {'orangegem',  0.50},
    {'yellowgem',  0.50},
    {'greengem',  0.50},
    {'purplegem',  0.50},
    {'thulecite',  0.50},
}
local rock_moon = {
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
}

local rock_moon_shell = {
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
    {'moonrocknugget',  1.00},
}

local rock_moon_glass = {
    {'moonglass',       1.00},
    {'moonglass',       1.00},
    {'moonglass',       1.00},
    {'moonglass',       1.00},
    {'moonglass',       1.00},
    {'moonglass',       1.00},
}

local function ModifyRockPrefab(inst)
    local old_onwork = inst.components.workable.onwork
    inst.components.workable.onwork = function(inst, worker, workleft, ...)
        inst.components.workable.workleft = 10
        if old_onwork then
            old_onwork(inst, worker, workleft, ...)
        end
    end
    inst.doNotRemoveOnWorkDone = true
end

-- Apply the loot table and modifications to each rock prefab
local rock_prefabs = {
    { name = "rock1", loot = rock1_loot },
    { name = "rock2", loot = rock2_loot },
    { name = "rock_flintless", loot = rock_flintless },
    { name = "rock_flintless_med", loot = rock_flintless_med },
    { name = "rock_flintless_low", loot = rock_flintless_low },
    { name = "rock_moon", loot = rock_moon },
    { name = "rock_moon_shell", loot = rock_moon_shell },
    { name = "moonglass_rock", loot = rock_moon_glass },
}

for _, rock in ipairs(rock_prefabs) do
    GLOBAL.SetSharedLootTable(rock.name, rock.loot)
    AddPrefabPostInit(rock.name, ModifyRockPrefab)
end