local plants = {
    grass = "cutgrass",
    berrybush = "berries",
    berrybush2 = "berries",
    berrybush_juicy = "berries_juicy",
    monkeytail = "cutreeds",
    sapling = "twigs",
    sapling_moon = "twigs",
    -- 更多植物及其产品可以添加到这里
}

local function ModifyPrefab(inst, product)
    if inst.components.pickable then
        inst.components.pickable:SetUp(product, TUNING.TOTAL_DAY_TIME*0.5, 10)
    end

    if inst.components.workable ~= nil then
        local old_dig_up = inst.components.workable.onfinish
        if old_dig_up ~= nil then
            inst.components.workable.onfinish = function(inst, worker, ...)
                old_dig_up(inst, worker, ...)
                inst.components.lootdropper:SetLoot({"dug_"..inst.prefab, "dug_"..inst.prefab, "dug_"..inst.prefab, "dug_"..inst.prefab, "dug_"..inst.prefab, "dug_"..inst.prefab, "dug_"..inst.prefab, "dug_"..inst.prefab, "dug_"..inst.prefab})
                local pt = inst:GetPosition()
                inst.components.lootdropper:DropLoot(pt)
            end
        end
    end

    if inst.components.pickable ~= nil then
        local old_ontransplantfn = inst.components.pickable.ontransplantfn
        if old_ontransplantfn ~= nil then
            inst.components.pickable.ontransplantfn = function(inst, ...)
                old_ontransplantfn(inst, ...)
                inst.components.pickable:MakeEmpty()
            end
        end

        local old_onpickedfn = inst.components.pickable.onpickedfn
        if old_onpickedfn ~= nil then
            inst.components.pickable.onpickedfn = function(inst, picker, ...)
                inst.components.pickable.cycles_left = 20
                old_onpickedfn(inst, picker, ...)
            end
        end
    end
end

for prefab, product in pairs(plants) do
    AddPrefabPostInit(prefab, function(inst) 
        ModifyPrefab(inst, product) 
    end)
end

---

AddPrefabPostInit("reeds", function(inst)
    if inst.components.pickable ~= nil then
        inst.components.pickable.quickpick = true
        inst.components.pickable:SetUp("cutreeds", TUNING.REEDS_REGROW_TIME, 10)
    end
    
    local function dig_up(inst, chopper)
        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:SpawnLootPrefab("cutreeds")
        end
        inst:Remove()
    end
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(GLOBAL.ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)
    inst:AddComponent("lootdropper")
end)