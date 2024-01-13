local DST = GLOBAL.TheSim.GetGameID ~= nil and GLOBAL.TheSim:GetGameID() == "DST"

local function DoNothing() end

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

    local old_onequip = inst.components.equippable.onequipfn
    inst.components.equippable:SetOnEquip(function(inst, owner)
        old_onequip(inst, owner)
        inst.Light:Enable(true)
        owner.components.health:StartRegen(2, 1)

        if owner and owner.components.temperature then
            if inst.temperatureTask then
                inst.temperatureTask:Cancel()
            end
            inst.temperatureTask = owner:DoPeriodicTask(.1, function(owner)
                owner.components.temperature:SetTemperature(35)
            end)
        end

        owner:AddDebuff("hungerregenbuff", "hungerregenbuff")
    end)

    local old_onunequip = inst.components.equippable.onunequipfn
    inst.components.equippable:SetOnUnequip(function(inst, owner)
        old_onunequip(inst, owner)
        owner.components.health:StopRegen()

        if inst.temperatureTask then
            inst.temperatureTask:Cancel()
            inst.temperatureTask = nil
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