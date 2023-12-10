local function ChangeAction(action, fn, name)
    if name then
        AddStategraphActionHandler(name, GLOBAL.ActionHandler(action, fn))
    else
        AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(action, fn))
        AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(action, fn))
    end
end

-- 快速采集
-- "archive_props", "atrium_gate", "bananabush", "berrybush", "bullkelp_plant", "cactus", "carrat", "carrot", "cave_banana_tree", "cave_fern", "compostingbin", "farm_plants", 
-- "flower", "flower_cave", "flower_evil", "flower_withered",
-- "grass", "lichen", "lightflier_flower", "mandrake_planted", "marsh_bush", "monkeytail", "moonbase", "mushrooms", "oceanfishableflotsam", "oceanvine", "reeds", "rock_avocado_bush", "sapling", "sculptingtable",
-- "stalker_berry", "stalker_bulb", "stalker_ferns", "statueglommer", "succulent_plant", "tallbirdnest", "telebase_gemsocket", "tumbleweed", "veggies", "weed_plants", "wintersfeastoven", "worm", "wormlight_plant"

ChangeAction(GLOBAL.ACTIONS.PICK, "doshortaction")
ChangeAction(GLOBAL.ACTIONS.PICK, function(inst, action)
    return action.target ~= nil and action.target.components.pickable ~= nil and "doshortaction" or nil
end, "shadowmaxwell")
-- End

-- 修改砍树
local function ModifyChopAction(prefab)
    AddPrefabPostInit(prefab, function(inst)
        inst.components.tool:SetAction(ACTIONS.CHOP, 15)
    end)
end

local chop_prefabs = {
    "axe",
    "goldenaxe",
    "moonglassaxe",
    "multitool_axe_pickaxe",
    "lucy"
}

for _, prefab in ipairs(chop_prefabs) do
    ModifyChopAction(prefab)
end
-- End

-- 修改挖矿
local function ModifyMineAction(prefab)
    AddPrefabPostInit(prefab, function(inst)
        inst.components.tool:SetAction(ACTIONS.MINE, 15)
    end)
end

local mine_prefabs = {
    "pickaxe",
    "goldenpickaxe",
    "pickaxe_lunarplant",
    "multitool_axe_pickaxe",
}

for _, prefab in ipairs(mine_prefabs) do
    ModifyMineAction(prefab)
end
-- End

-- 修改锤HAMMER
local function ModifyHammerAction(prefab)
    AddPrefabPostInit(prefab, function(inst)
        inst.components.tool:SetAction(ACTIONS.HAMMER, 15)
    end)
end

local hammer_prefabs = {
    "hammer",
    "pickaxe_lunarplant",
}

for _, prefab in ipairs(hammer_prefabs) do
    ModifyHammerAction(prefab)
end
-- End

-- 淡水钓鱼
local function QuickFishing(inst)
    if inst.components.fishingrod then
        inst.components.fishingrod:SetWaitTimes(0, 0)
    end
end
AddPrefabPostInit("fishingrod", QuickFishing)
-- End
