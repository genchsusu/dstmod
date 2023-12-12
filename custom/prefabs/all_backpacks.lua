local function ModifyBackpack(inst)
    inst:AddTag("fridge")

    if inst.components.waterproofer then
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
    end

    if not inst.entity:HasTag("light") then
        inst.entity:AddLight()
    end
    inst.Light:Enable(false)
    inst.Light:SetRadius(6)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)

    -- inst:AddComponent("sanityaura")
    -- inst.components.sanityaura.aura = TUNING.SANITYAURA_SUPERHUGE
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SUPERHUGE
    inst.components.equippable.insulated = true

    local old_onequip = inst.components.equippable.onequipfn
    inst.components.equippable:SetOnEquip(function(inst, owner)
        old_onequip(inst, owner)
        inst.Light:Enable(true)
        if owner and owner.components.temperature then
            owner:DoPeriodicTask(.1, function(owner)
                owner.components.temperature:SetTemperature(35)
            end)
        end
    end)

    local old_onunequip = inst.components.equippable.onunequipfn
    inst.components.equippable:SetOnUnequip(function(inst, owner)
        old_onunequip(inst, owner)
        inst.Light:Enable(false)
    end)
end

local items = {"krampus_sack", "piggyback", "backpack"}

for _, item in ipairs(items) do
    AddPrefabPostInit(item, ModifyBackpack)
end