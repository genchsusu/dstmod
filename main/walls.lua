local function ModifyWallPrefab(inst)
    -- 添加吸收伤害的能力
    if inst.components.health then
        inst.components.health:SetAbsorptionAmount(1) -- 吸收100%伤害
    end

    -- 修改破坏行为
    if inst.components.workable then
        local old_Destroy = inst.components.workable.Destroy
        inst.components.workable.Destroy = function(self, destroyer)
            if destroyer and destroyer.components.playercontroller then
                return old_Destroy(self, destroyer)
            end
        end
    end

    -- 添加光源和理智光环
    if not inst.entity:IsLight() then
        inst.entity:AddLight()
        inst.Light:SetRadius(3)
        inst.Light:SetFalloff(0.5)
        inst.Light:SetIntensity(0.8)
        inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)
        inst.Light:Enable(true)
    end

    if not inst.components.sanityaura then
        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aura = TUNING.SANITYAURA_SUPERHUGE
    end
end

local wall_types = {"stone", "wood", "hay", "ruins", "moonrock", "dreadstone"}

for _, wall_type in ipairs(wall_types) do
    AddPrefabPostInit("wall_"..wall_type, ModifyWallPrefab)
end