require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/campfire_fire.zip"),
}

local function onhammered(inst, worker)
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("campfire_fire")
    inst.AnimState:SetBuild("campfire_fire")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetRayTestOnBB(true)
    inst.AnimState:SetFinalOffset(3)

    inst.AnimState:PlayAnimation("level1", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("lightningrod")
    inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SUPERHUGE

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback()

    function inst.components.workable:Destroy(destroyer)
        if destroyer.components.playercontroller == nil then return end
    end

    -- Only allow players to cross the wall
    inst:DoPeriodicTask(.1, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local players = TheSim:FindEntities(x, y, z, 3, {"player"})
        if #players > 0 then
            inst.Physics:SetActive(false)
        else
            inst.Physics:SetActive(true)
        end
    end)

    return inst
end

return Prefab("fire_wall", fn, nil, nil)