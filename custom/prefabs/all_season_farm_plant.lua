--------------------------------------------------------------------------
--[[ all_season_farm_plant ]]
--------------------------------------------------------------------------
-- Configs
local enable_quick_grow = GetModConfigData('enable_quick_grow')
local enable_replant = GetModConfigData('enable_replant')
local always_oversized = GetModConfigData('always_oversized')
--------------------------------------------------------------------------
local PlantDefs = require("prefabs/farm_plant_defs").PLANT_DEFS
local all_seasons = {autumn = true, winter = true, spring = true, summer = true}
local State = {seed = true, sprout = true, small = true, med = true}

local function SetAllSeasonsGrowth(prefab)
    prefab.good_seasons = all_seasons
end

local function DoModification(prefab)
    AddPrefabPostInit(prefab, function(inst)
        -- Remove stress
        if always_oversized then
            if inst.components.farmplantstress ~= nil then
                inst.components.farmplantstress.stressors = {}
                inst.components.farmplantstress.stressors_testfns = {}
                inst.components.farmplantstress.stressor_fns = {}
            end
        end
        -- QuickGrow and replant
        if inst.components.growable and inst.components.growable.stages then
            local stages = deepcopy(inst.components.growable.stages)

            -- Replant
            if enable_replant then
                local MakePickableFunc, _ = Waffles.FindUpvalue(stages[1].fn, "MakePickable")
                local _, index = Waffles.FindUpvalue(MakePickableFunc, "OnPicked")
                if index then
                    local function OnPicked(inst, doer)
                        local x, y, z = inst.Transform:GetWorldPosition()
                        if TheWorld.Map:GetTileAtPoint(x, y, z) == WORLD_TILES.FARMING_SOIL then
                            local soil = SpawnPrefab("farm_soil")
                            soil.Transform:SetPosition(x, y, z)
                            soil:PushEvent("breaksoil")
                        end
                    
                        local plant_name = "farm_plant_" .. inst.plant_def.product
                        local new_plant = SpawnPrefab(plant_name)
                        if new_plant ~= nil then
                            new_plant.Transform:SetPosition(inst.Transform:GetWorldPosition())
                        end
                    end
                    debug.setupvalue(MakePickableFunc, index, OnPicked)
                end  
            end
            -- -- growth
            -- local old_grow_fn = stages[6].fn
            -- local PlayStageAnimFunc, _ = Waffles.FindUpvalue(stages[6].fn, "PlayStageAnim")
            -- stages[6].fn = function(...)
            --     old_grow_fn(...)
            --     inst:RemoveTag("farm_plant_killjoy")
            --     inst:RemoveTag("pickable_harvest_str")
            --     -- Replace rotten with full anim
            --     if PlayStageAnimFunc then
            --         PlayStageAnimFunc(inst, inst.is_oversized and "oversized" or "full")
            --     end
            -- end
            -- Keep the plant from dying
            stages[5].time = function(inst) return 480000 end

            inst.components.growable.stages = stages
            inst.force_oversized = true
            inst.components.growable:StartGrowing()

            -- Rapid growth
            if enable_quick_grow then
                while inst.components.growable:GetStage() < 5 do
                    inst.components.growable:DoGrowth()
                end
            end 
        end
    end)
end

for _, v in pairs(PlantDefs) do
    if v.prefab then
        SetAllSeasonsGrowth(v)
    end
    if not v.is_randomseed then
        DoModification(v.prefab)
    end
end

-- Remove defender
TUNING.FARM_PLANT_DEFENDER_SEARCH_DIST = 0

-- Remove useless
local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
for _, v in pairs(WEED_DEFS) do
    if not v.data_only then --allow mods to skip our prefab constructor.
        AddPrefabPostInit(v.prefab, function (inst)
            if TheWorld.ismastersim then
                inst:ListenForEvent("on_planted", function (inst,data)
                    if data.in_soil then
                        SpawnAt("farm_soil",inst:GetPosition())
                    end
                    inst:Remove()
                end)
            end
        end)
    end
end

-- farm_plow_item
AddPrefabPostInit("farm_plow", function(inst)
    -- Rewrite the OnTerraform function
    if inst.components.terraformer ~= nil then
        local old_OnTerraform = inst.components.terraformer.onterraformfn
        local FinishedFunc, _ = Waffles.FindUpvalue(old_OnTerraform, "Finished")
        if FinishedFunc ~= nil then
            inst.components.terraformer.onterraformfn = function(inst, pt, old_tile_type, old_tile_turf_prefab)
                local cx, cy, cz = TheWorld.Map:GetTileCenterPoint(pt:Get())
            
                -- Deploy the 3 x 3 grid of farm soil
                local gridSize = 3
                local offset = (gridSize - 1) * 1.25 / 2
            
                for dx = -offset, offset, 1.25 do
                    for dz = -offset, offset, 1.25 do
                        SpawnPrefab("farm_soil").Transform:SetPosition(cx + dx, cy, cz + dz)
                    end
                end
                FinishedFunc(inst)
            end
        end
    end

    -- Rewrite the dirt_anim function
    if inst.OnLoadPostPass ~= nil then
        local DoDrillingFunc, _ = Waffles.FindUpvalue(inst.OnLoadPostPass, "DoDrilling")
        if DoDrillingFunc then
            local _, index = Waffles.FindUpvalue(DoDrillingFunc, "dirt_anim")
            if index then
                local dirt_anim = function(inst, quad, timer)
                    local t = math.min(1, timer/(TUNING.FARM_PLOW_DRILLING_DURATION))
                    local duration_delay = Lerp(TUNING.FARM_PLOW_DRILLING_DIRT_DELAY_BASE_START, TUNING.FARM_PLOW_DRILLING_DIRT_DELAY_BASE_END, t)
                    local delay = duration_delay + math.random() * TUNING.FARM_PLOW_DRILLING_DIRT_DELAY_VAR
                
                    inst:DoTaskInTime(delay, dirt_anim, quad, timer + delay)
                end
                Waffles.SetUpvalue(DoDrillingFunc, index, dirt_anim)
            end
        end
    end
end)