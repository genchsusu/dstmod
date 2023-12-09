local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS

AddPrefabPostInit("poop", function(inst)
    if inst.components.fertilizer then
        inst.components.fertilizer:SetNutrients(FERTILIZER_DEFS.compostwrap.nutrients)
    end
end)

AddPrefabPostInit("soil_amender", function(inst)
    if not inst.components.stackable then
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
    end
end)