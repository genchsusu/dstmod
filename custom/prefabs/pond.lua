local function ModifyPondPlantType(inst)
    if inst and inst.planttype == "marsh_plant" then
        inst.planttype = "mandrake_planted"
    end
end

AddPrefabPostInit("pond", ModifyPondPlantType)
AddPrefabPostInit("pond_mos", ModifyPondPlantType)
AddPrefabPostInit("pond_cave", ModifyPondPlantType)