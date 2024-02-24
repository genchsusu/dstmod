local function countFish(inst, range)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, range, {"oceanfish", "swimming"})
    return #ents
end

local function isPlayerNearby(inst, range)
    local x, y, z = inst.Transform:GetWorldPosition()
    local players = TheSim:FindEntities(x, y, z, range, {"player"})
    return #players > 0
end

local function createFish(inst)
    if countFish(inst, 50) > 20 then
        return false, "TOOMANYFISH"
    end

    local range = 10
    if not isPlayerNearby(inst, range) then
        return false, "NOPLAYERSNEARBY"
    end

    local schoolspawner = TheWorld.components.schoolspawner
    if schoolspawner == nil then
        return false, "NOWATERNEARBY"
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local failed_spawn = 0

    for i=1, TUNING.BOOK_FISH_AMOUNT do
        local angle = math.random() * 2 * PI
        local spawn_success = false

        -- Try to spawn the fish in a circle around the boat, starting at a random angle
        for attempt = 1, 36 do
            local spawn_point = Vector3(x + math.cos(angle) * 10, 0, z + math.sin(angle) * 10)
            local spawn_offset = Vector3(math.random(1,3), 0, math.random(1,3))
            local num_fish_spawned = schoolspawner:SpawnSchool(spawn_point, nil, spawn_offset)
            
            if num_fish_spawned and num_fish_spawned > 0 then
                spawn_success = true
                break
            else
                angle = angle + (PI2 / 18)
            end
        end

        if not spawn_success then
            failed_spawn = failed_spawn + 1
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
    if inst.components.health ~= nil then
        inst.components.health:SetAbsorptionAmount(1)
    end
    inst:ListenForEvent("spawnnewboatleak", NoBoatLeak)
    if inst.components.hullhealth ~= nil then
        inst.components.hullhealth.leakproof = true
    end
    inst:DoPeriodicTask(10, createFish)
end)

AddPrefabPostInit("boat_grass", function(inst)
    if inst.components.health ~= nil then
        inst.components.health:SetAbsorptionAmount(1)
    end
    inst:ListenForEvent("spawnnewboatleak", NoBoatLeak)
    inst:DoPeriodicTask(10, createFish)
end)

AddPrefabPostInit("boat_pirate", function(inst)
    if inst.components.health ~= nil then
        inst.components.health:SetMaxHealth(1)
    end
end)
