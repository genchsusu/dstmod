require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/campfire_fire.zip"),
}

local function onhammered(inst, worker)
    inst:Remove()
end

local function MakeObstaclePhysicsBlockAll(inst, rad, height)
    inst:AddTag("blocker")
    local phys = inst.entity:AddPhysics()
    phys:SetMass(0) -- Bullet wants 0 mass for static objects
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:SetCollisionGroup(COLLISION.FLYERS)
    phys:SetCollisionGroup(COLLISION.GIANTS)
    phys:SetCollisionGroup(COLLISION.GROUND)
    phys:SetCollisionGroup(COLLISION.ITEMS)
    phys:SetCollisionGroup(COLLISION.OBSTACLES)
    phys:SetCollisionGroup(COLLISION.SMALLOBSTACLES)
    phys:SetCollisionGroup(COLLISION.WORLD)

    phys:ClearCollisionMask()
    phys:CollidesWith((TheWorld.has_ocean and COLLISION.GROUND) or COLLISION.WORLD)
    phys:CollidesWith(COLLISION.CHARACTERS)
    phys:CollidesWith(COLLISION.FLYERS)
    phys:CollidesWith(COLLISION.GIANTS)
    phys:CollidesWith(COLLISION.GROUND)
    phys:CollidesWith(COLLISION.ITEMS)
    phys:CollidesWith(COLLISION.OBSTACLES)
    phys:CollidesWith(COLLISION.SMALLOBSTACLES)
    phys:CollidesWith(COLLISION.WORLD)
    phys:SetCapsule(rad, height or 2)
    return phys
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeObstaclePhysicsBlockAll(inst, .5)

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
        local players = TheSim:FindEntities(x, y, z, 1.8, {"player"})
        if #players > 0 then
            inst.Physics:SetActive(false)
        else
            inst.Physics:SetActive(true)
        end
    end)

    return inst
end

return Prefab("fire_wall", fn, nil, nil)