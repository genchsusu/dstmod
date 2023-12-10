local function ModifyWallPrefab(inst)
    -- 添加吸收伤害的能力
    inst.components.health:SetAbsorptionAmount(1) -- 吸收100%伤害

    -- 无法被瞬间摧毁
    local old_Destroy = inst.components.workable.Destroy
    function inst.components.workable:Destroy(destroyer)
        if destroyer.components.playercontroller == nil then return end
        return old_Destroy(self,destroyer)
    end

    -- 添加光源和理智光环
    inst.entity:AddLight()

    inst.Light:Enable(true)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(255 / 255, 230 / 255, 150 / 255)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = TUNING.SANITYAURA_SUPERHUGE
end

local wall_types = {"hay", "wood", "stone", "moonrock", "ruins", "dreadstone"}

for _, wall_type in ipairs(wall_types) do
    AddPrefabPostInit("wall_"..wall_type, ModifyWallPrefab)
end