-- local function countNearbyOceanFish(inst, range)
--     local x, y, z = inst.Transform:GetWorldPosition()
--     local entities = TheSim:FindEntities(x, y, z, range, {"oceanfish"}, {"INLIMBO"})
--     return #entities
-- end
local function isPlayerNearby(inst, range)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = TheSim:FindEntities(x, y, z, range, {"player"})
    return #players > 0
end

local function createFish(inst)
    -- local range = 20
    -- if countNearbyOceanFish(inst, range) > 25 then
    --     return false, "TOOMANYFISH"
    -- end
    local range = 10
    if not isPlayerNearby(inst, range) then
        return false, "NOPLAYERSNEARBY"
    end

    local schoolspawner = GLOBAL.TheWorld.components.schoolspawner
    if schoolspawner == nil then
        return false, "NOWATERNEARBY"
    end

    local FISH_SPAWN_OFFSET = 10
    local x, y, z = inst.Transform:GetWorldPosition()
    local delta_theta = GLOBAL.PI2 / 18
    local failed_spawn = 0

    for i=1, TUNING.BOOK_FISH_AMOUNT do
        local theta = math.random() * 2 * GLOBAL.PI
        local failed_attempts = 0
        local max_failed_attempts = 36

        while failed_attempts < max_failed_attempts do
            local spawn_offset = GLOBAL.Vector3(math.random(1,3), 0, math.random(1,3))
            local spawn_point = GLOBAL.Vector3(x + math.cos(theta) * FISH_SPAWN_OFFSET, 0, z + math.sin(theta) * FISH_SPAWN_OFFSET)
            local num_fish_spawned = schoolspawner:SpawnSchool(spawn_point, nil, spawn_offset)
            
            if num_fish_spawned == nil or num_fish_spawned == 0 then
                theta = theta + delta_theta
                failed_attempts = failed_attempts + 1

                if failed_attempts >= max_failed_attempts then
                    failed_spawn = failed_spawn + 1
                end
            else -- Success
                break
            end
        end
    end

    if failed_spawn >= TUNING.BOOK_FISH_AMOUNT then
        return false, "NOWATERNEARBY"
    end

    return true
end

local function NoBoatLeak(inst, data)
	if data ~= nil and data.pt ~= nil then
		if data.playsoundfx then
			inst.SoundEmitter:PlaySoundWithParams(inst.sounds.damage, { intensity = 0.8 })
		end
	end
end

AddPrefabPostInit("boat", function(inst)
    inst.components.health:SetAbsorptionAmount(1)
    inst:ListenForEvent("spawnnewboatleak", NoBoatLeak)
    inst.components.hullhealth.leakproof = true
    inst:DoPeriodicTask(10, createFish)
end)

AddPrefabPostInit("boat_grass", function(inst)
    inst.components.health:SetAbsorptionAmount(1)
    inst:ListenForEvent("spawnnewboatleak", NoBoatLeak)
    inst:DoPeriodicTask(10, createFish)
end)

AddPrefabPostInit("boat_pirate", function(inst)
    inst.components.health:SetMaxHealth(1)
end)

