GLOBAL.setfenv(1, GLOBAL)

local seg_time = TUNING.SEG_TIME
local day_time = TUNING.DAY_SEGS_DEFAULT * seg_time
local dusk_time = TUNING.DUSK_SEGS_DEFAULT * seg_time
local night_time = TUNING.NIGHT_SEGS_DEFAULT * seg_time
local total_day_time = TUNING.TOTAL_DAY_TIME

local wilson_attack = TUNING.SPEAR_DAMAGE
local wilson_health = TUNING.WILSON_HEALTH

local tuning = {
    --大树干和普通树干遮阴范围
    -- SHADE_CANOPY_RANGE_SMALL = 80, -- 移除特效太难看
    -- SHADE_CANOPY_RANGE = 100,      -- 移除特效太难看

    -- 复活
    PORTAL_HEALTH_PENALTY = 1,

    MAXIMUM_HEALTH_PENALTY = 1,
    MAXIMUM_SANITY_PENALTY = 1,

    EFFIGY_HEALTH_PENALTY = 0,
    REVIVE_HEALTH_PENALTY = 0,
    -- 无草蜥蜴
    GRASSGEKKO_MORPH_CHANCE = 0,
    -- 快速挖田
    FARM_PLOW_DRILLING_DURATION = 0.1,

    YELLOWSTAFF_USES = 999,
    YELLOWSTAFF_STAR_DURATION = total_day_time * 9999,

    OPALSTAFF_USES = 999,
    OPALSTAFF_STAR_DURATION = total_day_time * 9999,

    MULTITOOL_DAMAGE = wilson_attack*10,

    CANE_SPEED_MULT = 2,

    -- 火鸡
    PERD_HEALTH = 5,
    PERD_ATTACK_PERIOD = 3,
    PERD_RUN_SPEED = 1,
    PERD_WALK_SPEED = 1,

    -- 池塘刷鱼时间
    FISH_RESPAWN_TIME = 1 ,

    EVERGREEN_GROW_TIME =
    {
        {base=1, random=0},   --short
        {base=1, random=0},   --normal
        {base=999*total_day_time, random=0},   --tall
        {base=1, random=0}    --old
    },
    TWIGGY_TREE_GROW_TIME =
    {
        {base=1, random=0},   --short
        {base=1, random=0},   --normal
        {base=999*total_day_time, random=0},   --tall
        {base=1, random=0}    --old
    },
    PINECONE_GROWTIME = {base=1, random=0},

    DECIDUOUS_GROW_TIME =
    {
        {base=1, random=0},   --short
        {base=1, random=0},   --normal
        {base=999*total_day_time, random=0},   --tall
        {base=1, random=0}    --old
    },
    ACORN_GROWTIME = {base=1, random=0},

    EVERGREEN_CHOPS_SMALL = 5,
    EVERGREEN_CHOPS_NORMAL = 10,
    EVERGREEN_CHOPS_TALL = 15,

    WORMLIGHT_RADIUS = 5,
    WORMLIGHT_DURATION = total_day_time,

    WORMLIGHT_PLANT_REGROW_TIME = 60,

    FROG_HEALTH = 1,
    FROG_DAMAGE = 1,

    MOSQUITO_WALKSPEED = 1,
    MOSQUITO_RUNSPEED = 1,
    MOSQUITO_DAMAGE = 1,
    MOSQUITO_HEALTH = 1,

    TURNON_FUELED_CONSUMPTION = 0,
    TURNON_FULL_FUELED_CONSUMPTION = 0,

    TINY_FUEL = total_day_time*999,
    SMALL_FUEL = total_day_time*999,
    MED_FUEL = total_day_time*999,
    MED_LARGE_FUEL = total_day_time*999,
    LARGE_FUEL = total_day_time*999,

    CAMPFIRE_RAIN_RATE = 0,
    CAMPFIRE_FUEL_MAX = total_day_time*999,
    CAMPFIRE_FUEL_START = total_day_time*999,
    COLDFIRE_RAIN_RATE = 0,
    COLDFIRE_FUEL_MAX = total_day_time*999,
    COLDFIRE_FUEL_START = total_day_time*999,
    ROCKLIGHT_FUEL_MAX = total_day_time*999,
    FIREPIT_RAIN_RATE = 0,
    FIREPIT_FUEL_MAX = total_day_time*999,
    FIREPIT_FUEL_START = total_day_time*999,
    FIREPIT_BONUS_MULT = 2,
    COLDFIREPIT_RAIN_RATE = 0,
    COLDFIREPIT_FUEL_MAX = total_day_time*999,
    COLDFIREPIT_FUEL_START = total_day_time*999,
    COLDFIREPIT_BONUS_MULT = 2,

    EYEBRELLA_PERISHTIME = total_day_time*999,

    GRASS_REGROW_TIME = total_day_time*0.5,
    SAPLING_REGROW_TIME = total_day_time*0.5,
    MARSHBUSH_REGROW_TIME = total_day_time*0.5,
    CACTUS_REGROW_TIME = total_day_time*0.5,
    FLOWER_CAVE_REGROW_TIME = total_day_time*0.5,
    LICHEN_REGROW_TIME = total_day_time*0.5,
    BERRY_REGROW_TIME = total_day_time*0.5,
    BERRY_JUICY_REGROW_TIME =  total_day_time * 0.5,
    REEDS_REGROW_TIME = total_day_time*0.5,

    ARMORMARBLE_SLOW = 2,

    DRY_SUPERFAST = 10,
    DRY_VERYFAST = 10,
    DRY_FAST = 10,
    DRY_MED = 10,

    PERISH_FRIDGE_MULT = -100,

    REPAIR_CUTSTONE_HEALTH = 9999,
    REPAIR_ROCKS_HEALTH = 9999,
    REPAIR_GEMS_WORK = 9999,
    REPAIR_GEARS_WORK = 9999,
    REPAIR_THULECITE_WORK = 9999,
    REPAIR_THULECITE_HEALTH = 9999,
    REPAIR_THULECITE_PIECES_WORK = 9999,
    REPAIR_THULECITE_PIECES_HEALTH = 9999,
    REPAIR_BOARDS_HEALTH = 9999,
    REPAIR_LOGS_HEALTH = 9999,
    REPAIR_STICK_HEALTH = 9999,
    REPAIR_CUTGRASS_HEALTH = 9999,
    REPAIR_TREEGROWTH_HEALTH = 9999,
    REPAIR_KELP_HEALTH = 9999,
    REPAIR_SHELL_HEALTH = 9999,
    REPAIR_MOONROCK_CRATER_HEALTH = 9999,
    REPAIR_MOONROCK_CRATER_WORK = 9999,
    REPAIR_MOONROCK_NUGGET_HEALTH = 9999,
    REPAIR_MOONROCK_NUGGET_WORK = 9999,
    REPAIR_DREADSTONE_HEALTH = 9999,
    REPAIR_DREADSTONE_WORK = 9999,

    INSULATION_TINY = total_day_time*99,
    INSULATION_SMALL = total_day_time*99,
    INSULATION_MED = total_day_time*99,
    INSULATION_MED_LARGE = total_day_time*99,
    INSULATION_LARGE = total_day_time*99,

    ILDFIRE_THRESHOLD = 800,

    MONKEY_MELEE_RANGE = 1,

    FIRESUPPRESSOR_MAX_FUEL_TIME = total_day_time*999,

    EVERGREEN_REGROWTH = {
        OFFSPRING_TIME = total_day_time * 0.5,
        DESOLATION_RESPAWN_TIME = total_day_time * 0.5,
        DEAD_DECAY_TIME = total_day_time * 0.5,
    },

    EVERGREEN_SPARSE_REGROWTH = {
        OFFSPRING_TIME = total_day_time * 0.5,
        DESOLATION_RESPAWN_TIME = total_day_time * 0.5,
        DEAD_DECAY_TIME = total_day_time * 0.5,
    },

    TWIGGY_TREE_REGROWTH = {
        OFFSPRING_TIME = total_day_time * 0.5,
        DESOLATION_RESPAWN_TIME = total_day_time * 0.5,
        DEAD_DECAY_TIME = total_day_time * 0.5,
    },

    DECIDUOUS_REGROWTH = {
        OFFSPRING_TIME = total_day_time * 0.5,
        DESOLATION_RESPAWN_TIME = total_day_time * 0.5,
        DEAD_DECAY_TIME = total_day_time * 0.5,
    },

    MUSHTREE_REGROWTH = {
        OFFSPRING_TIME = total_day_time * 0.5,
        DESOLATION_RESPAWN_TIME = total_day_time * 0.5,
        DEAD_DECAY_TIME = total_day_time * 0.5,
    },

    ROCK_FRUIT_SPROUT_GROWTIME = 0.5*day_time,
    ROCK_FRUIT_REGROW =
    {
        EMPTY = { BASE = 0, VAR = 0 },
        PREPICK = { BASE = 0, VAR = 0 },
        PICK = { BASE = 0, VAR = 0 },
        CRUMBLE = { BASE = total_day_time, VAR = total_day_time },
    },
    MOONGLASSAXE =
    {
        EFFECTIVENESS = 15,
        CONSUMPTION = 1.25,
        DAMAGE = wilson_attack,
        ATTACKWEAR = 2,
        SHADOW_WEAR = 0.5,
    },
    MOON_TREE_REGROWTH = {
        OFFSPRING_TIME = total_day_time * 0.5,
        DESOLATION_RESPAWN_TIME = total_day_time * 0.5,
        DEAD_DECAY_TIME = total_day_time * 0.5,
    },

    MOON_TREE_GROWTH_TIME =
    {
        {base=1, random=0},   --short
        {base=1, random=0},   --normal
        {base=999*total_day_time, random=0},   --tall
    },

    ANCHOR_DEPTH_TIMES = {
        LAND = 0,
        SHALLOW = 1,
        BASIC = 2,
        DEEP = 3,
        VERY_DEEP = 4,
    },
    
    WATERPLANT =
    {
        DAMAGE = wilson_attack * 2,
        ITEM_DAMAGE = wilson_attack * 0.7,
        ATTACK_PERIOD = 5,
        YELLOW_ATTACK_PERIOD = 2.5,
        ATTACK_DISTANCE = 18,
        ATTACK_AOE = 1.5,
        HEALTH = 500,

        MAX_BARNACLES = 999,
        GROW_TIME = 5,
        GROW_VARIANCE = 5,
        REBIRTH_TIME = 5,
        -- MAX_BARNACLES = 3,
        -- GROW_TIME = 2.5 * total_day_time,
        -- GROW_VARIANCE = 1.5 * total_day_time,
        -- REBIRTH_TIME = 2 * total_day_time,

        ANGERING_HIT_VELOCITY = 2.01,

        POLLEN_DURATION = 25,
        POLLEN_FADETIME = 2,
        -- POLLEN_RESETTIME = seg_time * 6,
        -- PINK_POLLEN_RESETTIME = seg_time * 3,
        POLLEN_RESETTIME = 25,
        PINK_POLLEN_RESETTIME = 25,
        POLLEN_RESETVARIANCE = seg_time / 2,

        FISH_SPAWN =
        {
            MAX_CHILDREN = 5,
            SPAWN_RADIUS = 4.5,
            REGEN_PERIOD = 10,
            WHITE_REGEN_PERIOD = 5,
            -- MAX_CHILDREN = 1,
            -- SPAWN_RADIUS = 4.5,
            -- REGEN_PERIOD = seg_time * 8,
            -- WHITE_REGEN_PERIOD = seg_time * 4,
        },
    },
    MAST_LAMP_LIGHTTIME = total_day_time*999,
    FARM_PLANT_CONSUME_NUTRIENT_LOW = 0,
    FARM_PLANT_CONSUME_NUTRIENT_MED = 0,
    FARM_PLANT_CONSUME_NUTRIENT_HIGH = 0,
    FARM_PLANT_DRINK_LOW =  0,
    FARM_PLANT_DRINK_MED =  0,
    FARM_PLANT_DRINK_HIGH = 0,
    PIGHOUSE_SPAWN_TIME = 0,
    PIGHOUSE_ENABLED = true,
    RABBITHOUSE_SPAWN_TIME = 0,
    RABBITHOUSE_ENABLED = true,
    PALMCONETREE_REGROWTH = {
        OFFSPRING_TIME = total_day_time * 0.5,
        DESOLATION_RESPAWN_TIME = total_day_time * 0.5,
        DEAD_DECAY_TIME = total_day_time * 0.5,
    },

    PALMCONETREE_GROWTH_TIME =
    {
        {base=1, random=0},   --short
        {base=1, random=0},   --normal
        {base=999*total_day_time, random=0},   --tall
    },
}

local function merge_tables(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" and type(t1[k]) == "table" then
            merge_tables(t1[k], v)
        else
            t1[k] = v
        end
    end
end

for key, value in pairs(tuning) do
    if TUNING[key] then
        print("OVERRIDE: " .. key .. " in TUNING")
    end

    if type(TUNING[key]) == "table" and type(value) == "table" then
        -- Merge the tables
        merge_tables(TUNING[key], value)
    else
        -- Directly override
        TUNING[key] = value
    end
end

TUNING.BOAT.BUMPERS.KELP.HEALTH = 2000
TUNING.BOAT.BUMPERS.SHELL.HEALTH = 4000
TUNING.BOAT.MAX_HULL_HEALTH_DAMAGE = 0
TUNING.BOAT.WAKE_TEST_TIME = 0.5
TUNING.BOAT.MAX_FORCE_VELOCITY = 5
TUNING.BOAT.RUDDER_TURN_SPEED = 15
TUNING.BOAT.OARS.BASIC.MAX_VELOCITY = 10
TUNING.BOAT.OARS.DRIFTWOOD.USES = 99999
TUNING.BOAT.OARS.DRIFTWOOD.MAX_VELOCITY = 10
TUNING.BOAT.ANCHOR.BASIC.ANCHOR_DRAG = 5
TUNING.BOAT.MAST.BASIC.MAX_VELOCITY = 25
TUNING.BOAT.MAST.BASIC.SAIL_FORCE = 10
TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY = 25
TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE = 10