local modimport = modimport
GLOBAL.setfenv(1, GLOBAL)

modimport("main/tuning")
modimport("main/birdspawner")
modimport("main/friendlyfruitfly")

-- inst:AddTag("drive_bird_scarecrow")--驱鸟稻草人标签