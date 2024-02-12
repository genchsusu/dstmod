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

local function ModifyWallPrefab(inst)
    -- 添加吸收伤害的能力
    if inst.components.health ~= nil then
        inst.components.health:SetAbsorptionAmount(1) -- 吸收100%伤害
    end

    -- 无法被瞬间摧毁
    if inst.components.workable ~= nil then
        local old_Destroy = inst.components.workable.Destroy
        function inst.components.workable:Destroy(destroyer)
            if destroyer.components.playercontroller == nil then return end
            return old_Destroy(self,destroyer)
        end
    end

   -- 添加光源和理智光环
    inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(6)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    -- inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)
    inst.Light:SetColour(223/255, 208/255, 69/255)

    --日光效果
    inst:AddTag("daylight")
    inst:AddTag("absolute_guard") --绝对防护
    inst:AddTag("drive_bird_scarecrow")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("quake_blocker") --防止地震（半径10格地皮的圆）

    --避雷针效果
    inst:AddComponent("lightningblocker") 
    inst.components.lightningblocker:SetBlockRange(28)
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SUPERHUGE

    MakeObstaclePhysicsBlockAll(inst, .5)

    inst:DoPeriodicTask(.1, function(inst)
        local x, y, z = inst.Transform:GetWorldPosition()
        local players = TheSim:FindEntities(x, y, z, 1.8, {"player"})
        local anims = {"broken", "onequarter", "half", "threequarter", "fullA", "fullB", "fullC"}

        if #players > 0 then
            if inst.Physics:IsActive() then
                if not inst.savedAnimState then
                    for _, anim in ipairs(anims) do
                        if inst.AnimState:IsCurrentAnimation(anim) then
                            inst.savedAnimState = anim
                            break
                        end
                    end
                end
                inst.Physics:SetActive(false)
                inst._ispathfinding:set(false)
                inst.AnimState:PlayAnimation("broken")
            end
        else
            if not inst.Physics:IsActive() then
                inst.Physics:SetActive(true)
                inst._ispathfinding:set(true)
                if inst.savedAnimState then 
                    inst.AnimState:PlayAnimation(inst.savedAnimState)
                    inst.savedAnimState = nil
                end
            end
        end
    end)
end

local wall_types = {"hay", "wood", "stone", "moonrock", "ruins", "dreadstone"}

for _, wall_type in ipairs(wall_types) do
    AddPrefabPostInit("wall_"..wall_type, ModifyWallPrefab)
end