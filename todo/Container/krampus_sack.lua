local assets =
{
    Asset("ANIM", "anim/backpack.zip"),
    Asset("ANIM", "anim/swap_krampus_sack.zip"),
    Asset("ANIM", "anim/ui_krampusbag_2x5.zip"),
}

-- Gin
-- local function keep_temp(owner, inst)
--     owner.components.temperature:SetTemperature(35)
--     if inst.components.equippable:IsEquipped() then
--         owner:DoTaskInTime(1, keep_temp, inst)
--     end
-- end
-- Gin

local function onequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("backpack", skin_build, "backpack", inst.GUID, "swap_krampus_sack" )
        owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "swap_krampus_sack" )
    else
        owner.AnimState:OverrideSymbol("backpack", "swap_krampus_sack", "backpack")
        owner.AnimState:OverrideSymbol("swap_body", "swap_krampus_sack", "swap_body")
    end
    -- Gin
    inst.Light:Enable(true)
    owner:DoPeriodicTask(.1, function(owner)
        owner.components.temperature:SetTemperature(35)
    end)
    -- keep_temp(owner, inst)
    -- Gin
    inst.components.container:Open(owner)
end

local function onunequip(inst, owner)
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    -- Gin
    inst.Light:Enable(false)
    -- Gin
    inst.components.container:Close(owner)
end

local function onequiptomodel(inst, owner)
    inst.components.container:Close(owner)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.MiniMapEntity:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_krampus_sack")
    inst.AnimState:PlayAnimation("anim")

    inst.foleysound = "dontstarve/movement/foley/krampuspack"

    inst:AddTag("backpack")

    --waterproofer (from waterproofer component) added to pristine state for optimization
    inst:AddTag("waterproofer")

    local swap_data = {bank = "backpack1", anim = "anim"}
    MakeInventoryFloatable(inst, "med", 0.1, 0.65, nil, nil, swap_data)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddTag("fridge") -- Gin 冰箱

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    inst.components.equippable:SetOnEquipToModel(onequiptomodel)

    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
    -- inst.components.waterproofer:SetEffectiveness(0)
    -- Gin
    -- inst:AddTag("HASHEATER")
    inst.entity:AddLight()

    inst.Light:Enable(false)
    inst.Light:SetRadius(6)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)

    -- inst:AddComponent("sanityaura")
    -- inst.components.sanityaura.aura = TUNING.SANITYAURA_SUPERHUGE
    -- -- 恢复脑
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SUPERHUGE
    -- -- 绝缘
    inst.components.equippable.insulated = true
    -- Gin

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("krampus_sack")
    inst.components.container.skipclosesnd = true
    inst.components.container.skipopensnd = true

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("krampus_sack", fn, assets)
