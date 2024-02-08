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

local TEMPERATURE_MULT =
{
	autumn = 0.5,
    winter = -2,
	spring = 0.5,
	summer = 2,
}

local function ModifyBackpack(inst)
    inst:AddTag("fridge")

    if not inst.components.waterproofer then
        inst:AddTag("waterproofer")
        inst:AddComponent("waterproofer")
    end

    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)

    inst.entity:AddLight()
    inst.Light:SetRadius(4)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)

    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORRUINS, 0.80)

    inst:AddTag("Infinite")
    if DST then inst:AddTag("hide_percentage") end
    inst.components.armor.SetCondition = DoNothing
    inst.components.equippable.walkspeedmult = 2

    inst.components.equippable.dapperness = 15.1515
    inst.components.equippable.insulated = true

    inst.insulation = -25 * (TEMPERATURE_MULT[TheWorld.state.season] or 1)

    local old_onequip = inst.components.equippable.onequipfn
    inst.components.equippable:SetOnEquip(function(inst, owner)
        old_onequip(inst, owner)
        inst.Light:Enable(true)
        owner.components.health:StartRegen(2, 1)

        if owner and owner.components.temperature then
            if inst.periodTask then
                inst.periodTask:Cancel()
            end

            owner.components.temperature:SetModifier("backpacks", inst.insulation)
            inst.periodTask = owner:DoPeriodicTask(.3, function(owner)
                local animals = {"tallbird"}
                ProtectFromAnimal(inst, owner, animals)
            end)
        end

        owner:AddDebuff("hungerregenbuff", "hungerregenbuff")
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
        owner:RemoveDebuff("hungerregenbuff")

        if owner.components.foodmemory ~= nil then
            owner.components.foodmemory:RememberFood("hungerregenbuff")
        end
    end)

    inst:ListenForEvent("ondropped", function(inst)
        inst.Light:Enable(true)
    end)
end

local items = {"krampus_sack", "piggyback", "backpack"}

for _, item in ipairs(items) do
    AddPrefabPostInit(item, ModifyBackpack)
end