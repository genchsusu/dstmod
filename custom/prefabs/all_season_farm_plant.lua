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

function Modification(prefab)
    AddPrefabPostInit(prefab, function(inst)
        -- dig_up
        inst.components.workable:SetOnFinishCallback(function(inst, worker)
            SpawnPrefab("farm_soil").Transform:SetPosition(inst.Transform:GetWorldPosition())
            if inst.components.lootdropper ~= nil then
                inst.components.lootdropper:DropLoot()
            end
        
            if inst.components.growable ~= nil then
                local stage_data = inst.components.growable:GetCurrentStageData()
                if stage_data ~= nil and stage_data.dig_fx ~= nil then
                    SpawnPrefab(stage_data.dig_fx).Transform:SetPosition(inst.Transform:GetWorldPosition())
                end
            end
        
            inst:Remove()
        end)

        -- burnt
        local old_onburnt = inst.components.burnable.onburnt
        inst.components.burnable:SetOnBurntFn(function(inst)
            old_onburnt(inst)
            SpawnPrefab("farm_soil").Transform:SetPosition(inst.Transform:GetWorldPosition())
        end)

        -- pickable
        inst.components.pickable.onpickedfn = function(inst, doer)
            local x, y, z = inst.Transform:GetWorldPosition()
            if GLOBAL.TheWorld.Map:GetTileAtPoint(x, y, z) == GLOBAL.WORLD_TILES.FARMING_SOIL then
                local soil = SpawnPrefab("farm_soil")
                soil.Transform:SetPosition(x, y, z)
                soil:PushEvent("breaksoil")
            end
        
            local radius = 10
            local soil_debris = TheSim:FindEntities(x, y, z, radius, {"farm_soil_debris"})
            for i, debris in ipairs(soil_debris) do
                debris:Remove()
            end
        
            local plant_name = "farm_plant_" .. inst.plant_def.product
            local new_plant = SpawnPrefab(plant_name)
            if new_plant ~= nil then
                new_plant.Transform:SetPosition(inst.Transform:GetWorldPosition())
            end
        end

        -- growth
        local old_grow_fn = inst.components.growable.stages[4].fn
        inst.components.growable.stages[4].fn = function(inst)
            old_grow_fn(inst) -- 调用原有的行为
            MakeRotten(inst, false)
        end

        inst.components.farmplantstress:AddStressCategory("nutrients", nil)
        inst.components.farmplantstress:AddStressCategory("moisture", nil)
        inst.components.farmplantstress:AddStressCategory("killjoys", nil)
        inst.components.farmplantstress:AddStressCategory("family", nil)
        inst.components.farmplantstress:AddStressCategory("overcrowding", nil)
        inst.components.farmplantstress:AddStressCategory("season", nil)
        inst.components.farmplantstress:AddStressCategory("happiness", nil, nil)
    end)

end

for _, v in pairs(PlantDefs) do
    if v.prefab then
        SetAllSeasonsGrowth(v)
        QuickGrow(v.prefab)
    end
end

