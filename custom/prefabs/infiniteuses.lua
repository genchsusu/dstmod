local DST = GLOBAL.TheSim.GetGameID ~= nil and GLOBAL.TheSim:GetGameID() == "DST"

local function DoNothing() end
local function FullPerishablePercent(self) return 1 end

local function RemoveDurability(inst)
    inst:AddTag("Infinite")
    -- To hide percentage on Dont Starve Together we set of the `hide_percentage` tag.
    if DST then inst:AddTag("hide_percentage") end

    local finiteuses = inst.components.finiteuses
    if finiteuses then
        finiteuses.Use = DoNothing
    end

    local perishable = inst.components.perishable
    if perishable then
        perishable.StartPerishing = DoNothing
        local SetPercent = perishable.SetPercent
        perishable.SetPercent = function(self, percent)
            SetPercent(self, 1)
        end

        perishable.GetPercent = FullPerishablePercent
    end

    local fueled = inst.components.fueled
    if fueled then
        fueled.StartConsuming = DoNothing
        fueled.DoDelta = DoNothing
    end

    local armor = inst.components.armor
    if armor then
        armor.SetCondition = DoNothing
    end
end


local function Tweak(prefabs)
    local processed = {}
    for _, prefab in ipairs(prefabs) do
        if not processed[prefab] then
            AddPrefabPostInit(prefab, RemoveDurability)
            processed[prefab] = true
        end
    end
end

local DURABILITIES = {
    WEAPON_DURABILITY = {
        "batbat",                       -- 蝙蝠棒
        "boomerang",                    -- 回旋镖
        "hambat",                       -- 火腿棒
        "ruins_bat",                    -- 铥矿棒 远古短棒
        "spear",                        -- 矛
        "tentaclespike",                -- 触手尖刺
        "spear_wathgrithr",             -- 战斗长矛
        "whip",                         -- 三尾猫鞭
        "glasscutter",                  -- 玻璃刀
        "nightsword",                   -- 暗夜剑
        "fence_rotator",                -- 栅栏击剑
        "shieldofterror",               -- 恐怖盾牌
    },
    ARMOR_DURABILITY = {
        "armor_sanity",                 -- 暗夜甲
        "armordragonfly",               -- 蜻蜓盔甲
        "armorgrass",                   -- 草盔甲
        "armormarble",                  -- 大理石盔甲
        "armorruins",                   -- 铥矿盔甲
        "armorsnurtleshell",            -- 蜗牛龟盔甲
        "armorwood",                    -- 木盔甲
        "beehat",                       -- 蜂帽
        "footballhat",                  -- 猪皮帽
        "ruinshat",                     -- 铥矿帽 远古王冠
        "slurtlehat",                   -- 蜗牛帽
        "hivehat",                      -- 蜂王冠
        "armorskeleton",                -- 骷髅盔甲
        "skeletonhat",                  -- 骷髅帽
        "walterhat",                    -- 松树先锋队帽子
        "antlionhat",                   -- 蚁狮帽
        "wathgrithrhat",                -- 战斗头盔
    },
    STAFF_DURABILITY = {
        "firestaff",                    -- 火焰魔杖
        "greenstaff",                   -- 绿色魔杖
        "icestaff",                     -- 冰魔杖
        "orangestaff",                  -- 橙色魔杖
        "telestaff",                    -- 传送魔杖
        "yellowstaff",                  -- 黄色魔杖
        "nightstick",                   -- 夜棍
        "opalstaff",                    -- 唤月者魔杖
        "staff_tornado",                -- 龙卷风魔杖
    },
    AMULET_DURABILITY = {
        "amulet",                       -- 红色护身符
        "blueamulet",                   -- 蓝色护身符
        "greenamulet",                  -- 绿色护身符
        "yellowamulet",                 -- 黄色护身符
        "purpleamulet",                 -- 紫色护身符
        "orangeamulet",                 -- 橙色护身符
    },
    TOOL_DURABILITY = {
        "bell",                         -- 铃铛
        "bugnet",                       -- 捕虫网
        "featherfan",                   -- 羽毛扇
        "minfan",                       -- 微型风扇
        "fertilizer",                   -- 化肥
        "firesuppressor",               -- 灭火器
        "fishingrod",                   -- 淡水钓竿
        "oceanfishingrod",              -- 海钓竿 
        "horn",                         -- 野牛角
        "panflute",                     -- 排箫

        "brush",                        -- 刷子
        "malbatross_beak",              -- 邪天翁喙

        "pocket_scale",                 -- 弹簧秤
        "saddle_basic",                 -- 基础鞍具
        "saddle_war",                   -- 战争鞍具
        "saddle_race",                  -- 赛跑鞍具 闪亮鞍具
        "saddlehorn",                   -- 鞍角

        "sewing_kit",                   -- 针线包
        "compass",                      -- 指南针
        "heatrock",                     -- 保温石
    },
    PRIMARYTOOL_DURABILITY = {
        "axe",                          -- 斧头
        "goldenaxe",                    -- 黄金斧头
        "pickaxe",                      -- 鹤嘴锄
        "goldenpickaxe",                -- 黄金鹤嘴锄
        "shovel",                       -- 铲子
        "goldenshovel",                 -- 黄金铲子
        "hammer",                       -- 锤子
        "pitchfork",                    -- 草叉
        "multitool_axe_pickaxe",        -- 多功能工具
        "moonglassaxe",                 -- 月光玻璃斧
    },
    TRAP_DURABILITY = {
        "birdtrap",                     -- 鸟陷阱
        "trap",                         -- 陷阱
        "trap_teeth",                   -- 犬牙陷阱
    },
    CLOTHING_DURABILITY = {
        "armorslurper",                 -- 饥饿腰带
        "beargervest",                  -- 熊背心
        "beefalohat",                   -- 牛毛帽
        "catcoonhat",                   -- 浣熊帽
        "earmuffshat",                  -- 兔耳罩
        "eyebrellahat",                 -- 眼球伞
        "eyemaskhat",                   -- 眼罩
        "featherhat",                   -- 羽毛帽
        "flowerhat",                    -- 花环
        "grass_umbrella",               -- 草伞
        "hawaiianshirt",                -- 夏威夷衬衫
        "icehat",                       -- 冰帽
        "onemanband",                   -- 独奏乐器
        "raincoat",                     -- 雨衣
        "rainhat",                      -- 防雨帽
        "reflectivevest",               -- 反光背心
        "spiderhat",                    -- 蜘蛛帽
        "strawhat",                     -- 草帽
        "sweatervest",                  -- 小巧背心
        "tophat",                       -- 高礼帽
        "trunkvest_summer",             -- 夏日背心
        "trunkvest_winter",             -- 寒冬背心
        "umbrella",                     -- 雨伞
        "walrushat",                    -- 海象帽
        "watermelonhat",                -- 西瓜帽
        "winterhat",                    -- 冬帽
        "armor_snakeskin",              -- 蛇皮盔甲
        "armor_windbreaker",            -- 风衣
        "captainhat",                   -- 船长帽
        "snakeskinhat",                 -- 蛇皮帽
        "piratehat",                    -- 海盗帽
        "wornpiratehat",                -- 破旧的海盗帽
        "gashat",                       -- 气体帽
        "aerodynamichat",               -- 空气动力学帽
        "shark_teethhat",               -- 鲨鱼牙帽
        "brainjellyhat",                -- 脑浆果帽
        "grass_umbrella",               -- 草伞
        "palmleaf_umbrella",            -- 棕榈叶伞
        "double_umbrellahat",           -- 双重伞帽
        "cookiecutterhat",              -- 曲奇切割帽
        "goggleshat",                   -- 护目镜
        "deserthat",                    -- 沙漠帽
    },
    LIGHT_DURABILITY = {
        "torch",                        -- 火炬
        "campfire",                     -- 营火
        "firepit",                      -- 石头营火
        "coldfire",                     -- 冷火
        "coldfirepit",                  -- 石头冷火
        "lantern",                      -- 提灯
        "lighter",                      -- 打火机
        "minerhat",                     -- 矿工帽
        "nightlight",                   -- 夜灯
        "pumpkin_lantern",              -- 南瓜灯
        "molehat",                      -- 鼹鼠帽
        "thurible",                     -- 香炉
    },
    FUELS_DURABILITY = {
        "lightbulb",                    -- 荧光果
        "wormlight",                    -- 发光浆果
        "wormlight_lesser",             -- 微光浆果
        "spore_tall",                   -- 蓝色孢子
        "spore_medium",                 -- 红色孢子
        "spore_small",                  -- 绿色孢子
    },
    CAMPING_DURABILITY = {
        "bedroll_furry",                -- 草席卷
        "siestahut",                    -- 遮阳篷
        "tent",                         -- 帐篷
    },
    BOOK_DURABILITY = {
        "book_birds",                   -- 鸟类之书
        "book_brimstone",               -- 闪电之书
        "book_gardening",               -- 催生植物之书
        "book_sleep",                   -- 催眠之书
        "book_tentacles",               -- 触手之书
        "book_horticulture",            -- 园艺学简编版 催熟食用类作物   
        "book_horticulture_upgraded",   -- 园艺学扩展版 催熟更多食用类作物 自动照料
        "book_silviculture",            -- 催熟非食用类植物 应用造林学
        "book_fish",                    -- 垂钓者生存指南 召唤鱼群之书
        "book_fire",                    -- 火焰之书
        "book_web",                     -- 克服蛛形纲恐惧症 蛛网之书
        "book_temperature",             -- 控温学
        "book_light",                   -- 召光之书
        "book_light_upgraded",          -- 召光之书升级版 
        "book_moon",                    -- 满月之书
        "book_rain",                    -- 召雨之书
        "book_bees",                    -- 召蜂之书
        "book_research_station",        -- 万物百科 暂时解锁制作配方
    },
    SEAFARING_DURABILITY = { -- DST only
        "boat_cannon",                  -- 大炮
        "harpoon",                      -- 鱼叉
        "oar",                          -- 船桨
        "oar_driftwood",                -- 船桨
        "mastupgrade_lamp",             -- 
        "mast_malbatross",
    },
    FARMING_DURABILITY = {
        "farm_hoe",                     -- 园艺锄
        "golden_farm_hoe",              -- 黄金园艺锄
        "farm_plow_item",               -- 耕地机
        "wateringcan",                  -- 水壶
        "premiumwateringcan",           -- 鸟嘴壶
        "soil_amender",                 -- 催长剂
    },
}

for _, prefabs in pairs(DURABILITIES) do
    Tweak(prefabs)
end
