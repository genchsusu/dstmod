local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

modimport("main/tuning")

-- 给大树干加驱逐鸟的功能
modimport("main/birdspawner")
modimport("main/watertree_pillar")

-- 果蝇强化
modimport("main/friendlyfruitfly")
-- 无限耐久
modimport("main/infiniteuses")

-- 船最大转向速度
modimport("main/boatphysics")

modimport("main/force_plant")
modimport("main/perd")
modimport("main/pond")

modimport("main/soil_amender")

-- 无敌城墙
modimport("main/walls")

-- 强化灭火器
modimport("main/firesuppressor")


-- 四季时蔬
modimport("main/all_season_farm_plant")

-- 冬天继续生长
modimport("main/override_standardcomponents")


-- 快速工作
modimport("main/quick_work")
