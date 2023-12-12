GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

Assets = {
    Asset("ANIM", "anim/ui_chest_5x16.zip"),
    Asset("ANIM", "anim/ui_chest_8x20.zip"),
}

modimport("custom/tuning")
modimport("custom/components/birdspawner")          -- 给大树干加驱逐鸟的功能
modimport("custom/prefabs/watertree_pillar")        -- 给大树干加驱逐鸟的功能
modimport("custom/prefabs/friendlyfruitfly")        -- 果蝇强化
modimport("custom/prefabs/infiniteuses")            -- 无限耐久
modimport("custom/components/boatphysics")          -- 船最大转向速度
modimport("custom/prefabs/force_plant")             -- 强制种植无法种植的植物
modimport("custom/prefabs/perd")                    -- 鸡生蛋
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
modimport("custom/containers")                      -- 修改箱子大小
modimport("custom/prefabs/all_backpacks")           -- 修改背包
modimport("custom/prefabs/all_chests")              -- 修改箱子


-- modimport("custom/prefabs/")       -- 修改
-- modimport("custom/prefabs/")       -- 修改

