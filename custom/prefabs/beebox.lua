local levels =
{
    { amount=999, idle="honey3", hit="hit_honey3" },
    { amount=666, idle="honey2", hit="hit_honey2" },
    { amount=333, idle="honey1", hit="hit_honey1" },
    { amount=0, idle="bees_loop", hit="hit_idle" },
}

local function Start(inst)
    if inst.components.harvestable ~= nil and inst.components.childspawner ~= nil then
        inst.components.harvestable:StartGrowing()
        inst.components.childspawner:StartSpawning()
    end
end

local function Grow(inst)
    if inst.components.harvestable ~= nil then
        inst.components.harvestable:SetGrowTime(1)
        inst.components.harvestable:StartGrowing()
    end
end

local function setlevel(inst, level)
    if not inst:HasTag("burnt") then
        if inst.anims == nil then
            inst.anims = { idle = level.idle, hit = level.hit }
        else
            inst.anims.idle = level.idle
            inst.anims.hit = level.hit
        end
        inst.AnimState:PlayAnimation(inst.anims.idle)
    end
end

local function updatelevel(inst)
    if not inst:HasTag("burnt") then
        for k, v in pairs(levels) do
            if inst.components.harvestable.produce >= v.amount then
                setlevel(inst, v)
                break
            end
        end
    end
end

local function onharvest(inst, picker, produce)
    if not inst:HasTag("burnt") then
        if inst.components.harvestable ~= nil then
            inst.components.harvestable:SetGrowTime(nil)
            inst.components.harvestable.pausetime = nil
            inst.components.harvestable:StopGrowing()
        end
		if produce == levels[1].amount then
			AwardPlayerAchievement("honey_harvester", picker)
		end
        updatelevel(inst)
    end
end

local function ModifyBeeboxPrefab(inst)
    if inst.components.harvestable ~= nil then
        inst.components.harvestable:SetUp("honey", 999, nil, onharvest, updatelevel)
    end
    -- GLOBAL.WorldSettings_ChildSpawner_SpawnPeriod(inst, 1, TUNING.BEEBOX_ENABLED)
    -- GLOBAL.WorldSettings_ChildSpawner_RegenPeriod(inst, 1, TUNING.BEEBOX_ENABLED)
    inst:WatchWorldState("iswinter", Start)
    inst:WatchWorldState("iscaveday", Start)
    inst:ListenForEvent("enterlight", Start)
    inst:ListenForEvent("enterdark", Start)
    inst.OnEntitySleep = Grow
    inst.OnEntityWake = Grow
end

AddPrefabPostInit("beebox", ModifyBeeboxPrefab)