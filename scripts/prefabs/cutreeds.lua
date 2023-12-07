local assets =
{
    Asset("ANIM", "anim/cutreeds.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("cutreeds")
    inst.AnimState:SetBuild("cutreeds")
    inst.AnimState:PlayAnimation("idle")

    inst.pickupsound = "vegetation_grassy"

    MakeInventoryFloatable(inst, "med", nil, 0.6)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    -- Gin 芦苇可以种植
    local function OnDeploy(inst, pt)
        SpawnPrefab("reeds").Transform:SetPosition(pt.x, pt.y, pt.z)
        inst.components.stackable:Get():Remove()
    end
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    -- Gin

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.ROUGHAGE
    inst.components.edible.healthvalue = TUNING.HEALING_TINY
    inst.components.edible.hungervalue = TUNING.CALORIES_TINY/2

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    MakeHauntableLaunchAndIgnite(inst)

    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab("cutreeds", fn, assets)
