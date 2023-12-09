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

modimport("main/fertilizer")
-- modimport("main/walls")