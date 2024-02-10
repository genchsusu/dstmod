--------------------------------------------------------------------------
--[[ all_backpacks ]]
--------------------------------------------------------------------------
-- Configs
local backpacks_plus_function = GetModConfigData('backpacks_plus_function') -- "保温。防高脚鸟。补脑。不会饥饿。"
local backpacks_armor = GetModConfigData('backpacks_armor')
local backpacks_light_range = GetModConfigData('backpacks_light_range')
--------------------------------------------------------------------------
local DST = GLOBAL.TheSim.GetGameID ~= nil and GLOBAL.TheSim:GetGameID() == "DST"

local function DoNothing() end

-- 保护不受动物攻击
local function ProtectFromAnimal(inst, owner, animals)
    local range = 10
    local x, y, z = owner.Transform:GetWorldPosition()
    local found = false

    for _, tag in ipairs(animals) do
        if #TheSim:FindEntities(x, y, z, range, {tag}) > 0 then
            found = true
            break
        end
    end

    if found then
        if owner.components.debuffable ~= nil then
            if not owner.components.debuffable:HasDebuff("spawnprotectionbuff") then
                owner.components.debuffable:AddDebuff("spawnprotectionbuff", "spawnprotectionbuff")
            end
        end
    else
        if owner.components.debuffable ~= nil then
            if owner.components.debuffable:HasDebuff("spawnprotectionbuff") then
                owner:DoTaskInTime(3, function (owner)
                    owner.components.debuffable:RemoveDebuff("spawnprotectionbuff")
                end)
            end
        end
    end
end

local function ModifyBackpack(inst)
    inst:AddTag("fridge")

    if not inst.components.waterproofer then
        inst:AddTag("waterproofer")
        inst:AddComponent("waterproofer")
    end

    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)

    if backpacks_light_range then
        inst.entity:AddLight()
        inst.Light:SetRadius(backpacks_light_range)
        inst.Light:SetFalloff(0.5)
        inst.Light:SetIntensity(0.8)
        inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)
    end

    if backpacks_armor then
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(TUNING.ARMORRUINS, backpacks_armor)

        inst:AddTag("Infinite")
        if DST then inst:AddTag("hide_percentage") end
        inst.components.armor.SetCondition = DoNothing
    end
    inst.components.equippable.walkspeedmult = 2

    if backpacks_plus_function then
        inst.components.equippable.dapperness = 15.1515
        inst.components.equippable.insulated = true
    end

    local old_onequip = inst.components.equippable.onequipfn
    inst.components.equippable:SetOnEquip(function(inst, owner)
        old_onequip(inst, owner)
        if backpacks_light_range then inst.Light:Enable(true) end
        owner.components.health:StartRegen(2, 1)

        if backpacks_plus_function then
            if owner and owner.components.temperature then
                if inst.periodTask then
                    inst.periodTask:Cancel()
                end
    
                inst.periodTask = owner:DoPeriodicTask(.3, function(owner)
                    local animals = {"tallbird"}
                    ProtectFromAnimal(inst, owner, animals)
                    inst.insulation = 25 - TheWorld.state.temperature
                    owner.components.temperature:SetModifier("backpacks", inst.insulation)
                end)
            end
    
            owner:AddDebuff("hungerregenbuff", "hungerregenbuff")
        end
    end)

    local old_onunequip = inst.components.equippable.onunequipfn
    inst.components.equippable:SetOnUnequip(function(inst, owner)
        old_onunequip(inst, owner)
        owner.components.health:StopRegen()

        if inst.periodTask then
            inst.periodTask:Cancel()
            inst.periodTask = nil
        end

        if owner and owner.components.temperature then
            owner.components.temperature:SetModifier("backpacks", nil)
        end

        if backpacks_plus_function then
            owner:RemoveDebuff("hungerregenbuff")
        end
        
        if owner.components.foodmemory ~= nil then
            owner.components.foodmemory:RememberFood("hungerregenbuff")
        end
    end)

    inst:ListenForEvent("ondropped", function(inst)
        if backpacks_light_range then inst.Light:Enable(true) end
    end)
end

local items = {"krampus_sack", "piggyback", "backpack"}

for _, item in ipairs(items) do
    AddPrefabPostInit(item, ModifyBackpack)
end