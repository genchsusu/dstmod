local require = GLOBAL.require
local PlantDefs = require("prefabs/farm_plant_defs").PLANT_DEFS
local all_seasons = {autumn = true, winter = true, spring = true, summer = true}
local State = {seed = true, sprout = true, small = true, med = true}

local function SetAllSeasonsGrowth(prefab)
    prefab.good_seasons = all_seasons
end

local function QuickGrow(prefab)
    AddPrefabPostInit(prefab, function(inst)
        if inst.components.growable and inst.components.growable.stages then
            local stages = GLOBAL.deepcopy(inst.components.growable.stages)
            for k, v in pairs(stages) do
                if v.name and State[v.name] then
                    v.time = function(inst, stage_num, stage_data)
                        return 0
                    end
                end
            end
            inst.components.growable.stages = stages
            inst.force_oversized = true
            inst.components.growable:StartGrowing()
            inst.components.growable:Pause()
        end
    end)
end
for _, v in pairs(PlantDefs) do
    if v.prefab then
        SetAllSeasonsGrowth(v)
        QuickGrow(v.prefab)
    end
end