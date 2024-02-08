-- Init utils
modimport("scripts/waffles")

Assets = {
    Asset("IMAGE", "images/archor.tex"),
	Asset("ATLAS", "images/archor.xml"),
    Asset("IMAGE", "images/mast.tex"),
	Asset("ATLAS", "images/mast.xml"),
    Asset("ANIM", "anim/ui_chest_5x16.zip"),
    Asset("ANIM", "anim/ui_chest_8x20.zip"),
    Asset("ATLAS", "images/sack27.xml"),
}

PrefabFiles = {
}

GLOBAL.Mod = {
    env = getfenv(1),
    -- config = {
    --     anchor_speed = GetModConfigData('anchor_speed'),
    --     power_rudder = GetModConfigData('power_rudder'),
    --     power_mast = GetModConfigData('power_mast'),
    --     power_anchor = GetModConfigData('power_anchor'),
    --     create_fish = GetModConfigData('create_fish'),
    --     no_boat_leak = GetModConfigData('no_boat_leak'),
    -- },
}

import = kleiloadlua(MODROOT .. "scripts/import.lua")()
import("ui")

modimport("custom/tuning")
modimport("custom/recipes")                         -- 修改配方
modimport("custom/components/birdspawner")          -- 给大树干加驱逐鸟的功能
modimport("custom/prefabs/watertree_pillar")        -- 给大树干加驱逐鸟的功能
modimport("custom/prefabs/friendlyfruitfly")        -- 果蝇强化
modimport("custom/prefabs/infiniteuses")            -- 无限耐久
modimport("custom/components/boatphysics")          -- 船最大转向速度
modimport("custom/prefabs/force_plant")             -- 强制种植无法种植的植物
modimport("custom/prefabs/animal_product")          -- 鸡生蛋, 兔子掉毛,
modimport("custom/prefabs/pond")                    -- 池塘长曼德拉草
modimport("custom/prefabs/soil_amender")            -- soil_amender可堆叠
modimport("custom/prefabs/walls")                   -- 无敌城墙
modimport("custom/prefabs/firesuppressor")          -- 强化灭火器
modimport("custom/prefabs/all_season_farm_plant")   -- 四季时蔬
modimport("custom/standardcomponents")              -- 冬天继续生长
modimport("custom/prefabs/quick_work")              -- 快速工作
modimport("custom/prefabs/log")                     -- 烧木头掉灰和木炭
modimport("custom/prefabs/general_plants")          -- 修改常用植物
modimport("custom/prefabs/beebox")                  -- 修改蜂箱
modimport("custom/prefabs/boat")                    -- 修改船
modimport("custom/prefabs/rocks")                   -- 修改矿物
modimport("custom/prefabs/rock_avocado_bush")       -- 修改rock_avocado_bush

modimport("custom/prefabs/bananabush")              -- 修改香蕉树
-- modimport("custom/prefabs/evergreens")              -- 修改evergreens
modimport("custom/prefabs/scarecrow")               -- 稻草人防鸟
modimport("custom/containers")                      -- 修改箱子大小
modimport("custom/prefabs/all_backpacks")           -- 修改背包
modimport("custom/prefabs/all_chests")              -- 修改箱子
modimport("custom/components/firedetector")         -- 灭火器不检测营火
modimport("custom/components/nosnow")               -- No Snow Covered
modimport("custom/components/respawn")              -- 死亡不掉落 复活无敌15秒
modimport("custom/components/absolute_guard")       -- 绝对防护
modimport("custom/prefabs/stack_ui_fix")            -- 修复堆叠UI Bug

modimport("custom/resurrect")                       -- 打字复活
modimport("custom/auto_stack")                      -- 自动堆叠

modimport("custom/prefabs/mermking")                -- 修改鱼人国王

modimport("custom/show_fish")                       -- 海吊杆显示鱼群信息
modimport("custom/brains/brains")                   -- 修改生物行为

-- modimport("custom/prefabs/")       -- 修改

-- 解锁全图鉴
AddPlayerPostInit(
  function(inst)
    inst:DoTaskInTime(
      0,
      function()
        if inst == ThePlayer then
			TheScrapbookPartitions:DebugUnlockEverything()

            -- 移除特定物品
            local itemsToRemove = { "boatfragment03", "boatfragment04", "boatfragment05", "spoiled_food" }
            for _, itemName in ipairs(itemsToRemove) do
                local items = TheSim:FindEntities(0, 0, 0, 10000, { itemName })
                for i, item in ipairs(items) do
                item:Remove()
                end
            end
          end
        end
    )
  end
)

local skilltreedefs = require "prefabs/skilltree_defs"
AddPlayerPostInit(function(inst)
	local skills = skilltreedefs.SKILLTREE_DEFS[inst.prefab]
	local updater = inst.components.skilltreeupdater
	if skills and updater then
		updater.IsActivated = function(self, skill)
			return skills[skill]
		end
		updater.HasSkillTag = function()
			return true
		end
		local activated = updater.skilltree.activatedskills[inst.prefab] or {}
		for skill, data in pairs(skills) do
			if not data.lock_open and not activated[skill] then
				if GLOBAL.TheNet:GetIsServer() then
					updater:ActivateSkill_Server(skill)
				end
				if inst == GLOBAL.ThePlayer then
					updater:ActivateSkill_Client(skill)
				end
			end
		end
	end
end)
