local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

-- local function newStackable(self)
--     local _Put = self.Put
--     self.Put = function(self, item, source_pos)
--         if item.prefab == self.inst.prefab then
--             local newtotal = item.components.stackable:StackSize() + self.inst.components.stackable:StackSize()
--         end
--         return _Put(self, item, source_pos)
--     end
-- end

-- AddComponentPostInit("stackable", newStackable)

-- 遍历需要叠加的动物
local function AddAnimalStackables(value)
	if IsServer == false then
		return
	end
	for k,v in ipairs(value) do
		AddPrefabPostInit(v,function(inst)
			if(inst.components.stackable == nil) then
				inst:AddComponent("stackable")
			end
			inst.components.inventoryitem:SetOnDroppedFn(function(inst)
				-- if(inst.components.perishable ~= nil) then
					-- inst.components.perishable:StopPerishing()
				-- end
				if(inst.sg ~= nil) then
					inst.sg:GoToState("stunned")
				end
				if inst.components.stackable then
					while inst.components.stackable:StackSize() > 1 do
						local item = inst.components.stackable:Get()
						if item then
							if item.components.inventoryitem then
								item.components.inventoryitem:OnDropped()
							end
							item.Physics:Teleport(inst.Transform:GetWorldPosition())
						end
					end
				 end
			end)
		end)
	end
end

-- 遍历需要叠加的物品
local function AddItemStackables(value)
	if IsServer == false then
		return
	end
	for k,v in ipairs(value) do
		AddPrefabPostInit(v,function(inst)
			if  inst.components.sanity ~= nil  then
				return
			end
			if  inst.components.inventoryitem == nil  then
				return
			end
			if(inst.components.stackable == nil) then
				inst:AddComponent("stackable")
			end
		end)
	end
end


--小兔子
AddAnimalStackables({"rabbit",})
--鼹鼠
AddAnimalStackables({"mole",})
--鸟类
AddAnimalStackables({"robin","robin_winter","crow","puffin","canary","canary_poisoned","bird_mutant","bird_mutant_spitter",})
--鱼类
local STACKABLE_OBJECTS_BASE = {"pondfish","pondeel","oceanfish_medium_1_inv","oceanfish_medium_2_inv","oceanfish_medium_3_inv","oceanfish_medium_4_inv","oceanfish_medium_5_inv","oceanfish_medium_6_inv","oceanfish_medium_7_inv","oceanfish_medium_8_inv","oceanfish_small_1_inv","oceanfish_small_2_inv","oceanfish_small_3_inv","oceanfish_small_4_inv","oceanfish_small_5_inv","oceanfish_small_6_inv","oceanfish_small_7_inv","oceanfish_small_8_inv","oceanfish_small_9_inv","wobster_sheller_land","wobster_moonglass_land","oceanfish_medium_9_inv"}
AddAnimalStackables(STACKABLE_OBJECTS_BASE)

--眼球炮塔
AddItemStackables({"eyeturret_item"})
--高脚鸟蛋相关
AddAnimalStackables({"tallbirdegg_cracked","tallbirdegg"})
--岩浆虫卵相关
AddAnimalStackables({"lavae_egg","lavae_egg_cracked","lavae_tooth","lavae_cocoon"})
--暗影心房
AddItemStackables({"shadowheart"})
--犀牛角
AddItemStackables({"minotaurhorn"})
--格罗姆翅膀
AddItemStackables({"glommerwings"})
--月岩雕像
AddItemStackables({"moonrockidol"})
--蜘蛛类
AddAnimalStackables({"spider","spider_healer","spider_hider","spider_moon","spider_spitter","spider_warrior",})
--树叶笔记【额外物品包】
AddItemStackables({"aip_leaf_note"})
--超级打包盒
AddItemStackables({"miao_packbox"})
--荷叶（神话）
AddItemStackables({"myth_lotusleaf"})

-- 催长剂
AddItemStackables({"soil_amender"})
