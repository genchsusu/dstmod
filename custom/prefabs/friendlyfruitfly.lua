AddPrefabPostInit("friendlyfruitfly", function(inst)

	inst:RemoveComponent("freezable")
	inst:RemoveComponent("burnable")
	
	if inst.components.health ~= nil then
		inst.components.health:SetMaxHealth(1000)
		inst.components.health:StartRegen(1000, 1)
	end
	
	inst.entity:SetCanSleep(false)
	
end)

-- 不会被冰冻
-- 不会被点燃
-- 最大血量1000且高速回血
-- 远离玩家时依然会工作