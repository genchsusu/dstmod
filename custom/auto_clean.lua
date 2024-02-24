local IsServer = TheNet:GetIsServer() or TheNet:IsDedicated()

local lang = TheNet:GetLanguageCode()
if lang == "schinese" or lang == "tchinese" then
    STRINGS.CLEANINGS={
        [1] = "清理中",
        [2] = "清理 %s(%s)\t共 %d组",
        [3] = "世界(地面)",
        [4] = "世界(地洞)",
        [5] = "世界",
        }
        
    STRINGS.CLEAN_NOTICE="防卡：本房间将于 5 秒后清理！"
else
    STRINGS.CLEANINGS={
        [1] = " Cleaning",
        [2] = "Cleaned up %s(%s)\ttotal %d groups",
        [3] = "World(Forest)",
        [4] = "World(Cave)",
        [5] = "World",
        }
        
    STRINGS.CLEAN_NOTICE="Antistun：5s until server clean."
end


-- configs
local clean_cycle = 3
local auto_clean = true
local need_announce = true

local hostile = 10
local festival = 2
local feather = 2
local useless = 0
local tools = 3
--
if IsServer then
    -- 需要清理的物品
    -- @max        地图上存在的最大数量
    -- @stack      标识为true时表示仅清理无堆叠的物品
    -- @reclean    标识为数字,表示超过第n次清理时物品还存在则强制清理(第一次找到物品并未清理的计数为1):超过次数后即使堆叠的物品也会清理
    local function GetLevelPrefabs()
        local levelPrefabs = {
            ------------------------  生物  ------------------------
            hound           = { max = hostile },			-- 狗
            firehound       = { max = hostile },		    -- 火狗
            spider_warrior  = { max = hostile },		    -- 蜘蛛战士
            spider          = { max = hostile },		    -- 蜘蛛
            flies           = { max = hostile },			-- 苍蝇
			grassgekko      = { max = useless },   	        -- 草蜥蜴
            mosquito        = { max = hostile },			-- 蚊子
            bee             = { max = hostile },			-- 蜜蜂
            killerbee       = { max = hostile },			-- 杀人蜂
            frog            = { max = hostile },			-- 青蛙
            beefalo         = { max = 50 },		            -- 牛
            deer            = { max = 50 },			        -- 鹿
            slurtle         = { max = 5 },		            -- 鼻涕虫
            snurtle         = { max = 5 },		            -- 蜗牛
			rocky			= { max = 20 },			        -- 石虾
			
			

            ------------------------  地面物体  ------------------------
            evergreen_sparse    = { max = 150 },				  -- 常青树
            twiggytree          = { max = 150 },                  -- 树枝树
            marsh_tree          = { max = 100 },                  -- 针刺树
            rock_petrified_tree = { max = useless },              -- 石化树
            skeleton_player     = { max = 10 },                   -- 玩家尸体
            spiderden           = { max = 50 },                   -- 蜘蛛巢
            burntground         = { max = 5 },                    -- 陨石痕跡
			
			
            ------------------------  可拾取物品  ------------------------
            spoiled_food    = { max = useless },                  -- 腐烂食物
            
            blueprint   = { max = tools },	 	 -- 蓝图
            axe         = { max = tools }, 	 	 -- 斧子
            torch       = { max = tools },       -- 火炬
            pickaxe     = { max = tools },  	 -- 镐子
            hammer      = { max = tools },   	 -- 锤子
            shovel      = { max = tools },   	 -- 铲子
            razor       = { max = tools },    	 -- 剃刀
            pitchfork   = { max = tools },	     -- 草叉
            bugnet      = { max = tools },    	 -- 捕虫网
            fishingrod  = { max = tools },       -- 鱼竿
            spear       = { max = tools },    	 -- 矛
            earmuffshat = { max = tools },       -- 兔耳罩
            winterhat   = { max = tools },   	 -- 冬帽
			heatrock    = { max = tools },   	 -- 热能石
            trap        = { max = tools },   	 -- 动物陷阱
            birdtrap    = { max = tools },  	 -- 鸟陷阱
            compass     = { max = tools },   	 -- 指南針

            armor_sanity   = { max = 3 },       -- 影甲
            shadowheart    = { max = 3  },      -- 影心

            --------------------  added by yuuuuuxi  ----------------------
			driftwood_log			= { max = 150 },		        -- 浮木桩
            boatfragment03			= { max = useless  },           -- 船碎片
            boatfragment04			= { max = useless  },           -- 船碎片
            boatfragment05			= { max = useless  },           -- 船碎片
			spoiled_fish			= { max = useless  },	        -- 变质的鱼
			spoiled_fish_small		= { max = useless  },	        -- 坏掉的小鱼
			rottenegg				= { max = useless  },	        -- 腐烂的蛋
			feather_crow			= { max = feather  },			-- 黑色羽毛
			feather_robin			= { max = feather  },			-- 红色羽毛
			feather_robin_winter	= { max = feather  },			-- 白色羽毛
			feather_canary			= { max = feather  },			-- 金色羽毛
			slurper_pelt			= { max = feather  },			-- 啜食兽毛皮
			pocket_scale			= { max = 3 },		            -- 弹簧秤
			oceanfishingrod			= { max = 3 },	                -- 海钓竿
			
			
			sketch					= { max = 3 },			        --所有boss草图
			tacklesketch			= { max = 3 },		            --所有广告

            ----------------  四季 boss 和蛤蟆、蜂后的挂饰 -----------------
            winter_ornament_boss_bearger    = { max = festival }, 
            winter_ornament_boss_beequeen   = { max = festival },
            winter_ornament_boss_deerclops  = { max = festival },
            winter_ornament_boss_dragonfly  = { max = festival },
            winter_ornament_boss_moose      = { max = festival },
            winter_ornament_boss_toadstool  = { max = festival },
			
            ------------------------  节日小饰品  ------------------------
            winter_ornament_plain1 = { max = festival, stack = true, reclean = 3 }, 	
            winter_ornament_plain2 = { max = festival, stack = true, reclean = 3 },
            winter_ornament_plain4 = { max = festival, stack = true, reclean = 3 },
            winter_ornament_plain5 = { max = festival, stack = true, reclean = 3 },
            winter_ornament_plain6 = { max = festival, stack = true, reclean = 3 },
            winter_ornament_plain7 = { max = festival, stack = true, reclean = 3 },
            winter_ornament_plain8 = { max = festival, stack = true, reclean = 3 },
            ------------------------  戈尔迪乌姆之结----------------------
            trinket_3   = { max = festival, stack = true, reclean = 3 }, 
            trinket_4   = { max = festival, stack = true, reclean = 3 },
            trinket_6   = { max = festival, stack = true, reclean = 3 },
            trinket_8   = { max = festival, stack = true, reclean = 3 },
			
			--万圣节糖果--
			halloweencandy_1		= { max = festival },		--苹果糖
			halloweencandy_2		= { max = festival },		--玉米糖
			halloweencandy_3		= { max = festival },		--似糖非糖玉米
			halloweencandy_4		= { max = festival },		--黏黏的蜘蛛
			halloweencandy_5		= { max = festival },		--卡通糖果
			halloweencandy_6		= { max = festival },		--葡萄干
			halloweencandy_7		= { max = festival },		--葡萄干（有包装）
			halloweencandy_8		= { max = festival },		--幽灵糖
			halloweencandy_9		= { max = festival },		--果冻虫
			halloweencandy_10		= { max = festival },		--触须棒糖
			halloweencandy_11		= { max = festival },		--巧克力猪
			halloweencandy_12		= { max = festival },		--糖果虱
			halloweencandy_13		= { max = festival },		--末世硬糖
			halloweencandy_14		= { max = festival },		--熔岩胡椒
			
			--万圣节玩具--
			trinket_32				= { max = festival },		--方晶锆石球
			trinket_33				= { max = festival },		--蜘蛛戒指
			trinket_34				= { max = festival },		--猴爪
			trinket_35				= { max = festival },		--空的万能药
			trinket_36				= { max = festival },		--人造尖牙
			trinket_37				= { max = festival },		--折断的棍子
			trinket_38				= { max = festival },		--双筒望远镜
			trinket_39				= { max = festival },		--单只手套
			trinket_40				= { max = festival },		--蜗牛尺
			trinket_41				= { max = festival },		--笨蛋罐
			trinket_42				= { max = festival },		--玩具蛇
			trinket_43				= { max = festival },		--玩具鳄鱼
			trinket_44				= { max = festival },		--坏掉的玻璃容器
			trinket_45				= { max = festival },		--老收音机
			trinket_46				= { max = festival },		--坏掉的吹风机
			
			--冬季盛宴食物--
			winter_food1			= { max = festival },		--姜饼人曲奇饼
			winter_food2			= { max = festival },		--糖屑曲奇饼
			winter_food3			= { max = festival },		--拐杖糖
			winter_food4			= { max = festival },		--永恒水果蛋糕
			winter_food5			= { max = festival },		--巧克力木头蛋糕
			winter_food6			= { max = festival },		--李子布丁
			winter_food7			= { max = festival },		--苹果酒
			winter_food8			= { max = festival },		--热可可
			winter_food9			= { max = festival },		--天堂蛋酒
			
			--冬季盛宴小饰品（8种不规则形状）--
			winter_ornament_fancy1	= { max = festival },
			winter_ornament_fancy2	= { max = festival },
			winter_ornament_fancy3	= { max = festival },
			winter_ornament_fancy4	= { max = festival },
			winter_ornament_fancy5	= { max = festival },
			winter_ornament_fancy6	= { max = festival },
			winter_ornament_fancy7	= { max = festival },
			winter_ornament_fancy8	= { max = festival },	
        }

        return levelPrefabs
    end

    -- 拆掉健康为0的墙
    local function RemoveItem(inst)
        if inst.components.health ~= nil and not inst:HasTag("wall") then
            if inst.components.lootdropper ~= nil then
                inst.components.lootdropper.DropLoot = function(pt) end
            end
            inst.components.health:SetPercent(0)
        else
            inst:Remove()
        end
    end

    local function Clean(inst, level)
        local this_max_prefabs = GetLevelPrefabs()
        local countList = {}

        for _,v in pairs(GLOBAL.Ents) do
            if v.prefab ~= nil then
                repeat
                    local thisPrefab = v.prefab
                    if this_max_prefabs[thisPrefab] ~= nil then
                        if v.reclean == nil then
                            v.reclean = 1
                        else
                            v.reclean = v.reclean + 1
                        end

                        local bNotClean = true
                        if this_max_prefabs[thisPrefab].reclean ~= nil then
                            bNotClean = this_max_prefabs[thisPrefab].reclean > v.reclean
                        end

                        if this_max_prefabs[thisPrefab].stack and bNotClean and v.components and v.components.stackable and v.components.stackable:StackSize() > 1 then break end
                    else break end

                    -- 不可见物品(在包裹内等)
                    if v.inlimbo then break end

                    if countList[thisPrefab] == nil then
                        countList[thisPrefab] = { name = v.name, count = 1, currentcount = 1 }
                    else
                        countList[thisPrefab].count = countList[thisPrefab].count + 1
                        countList[thisPrefab].currentcount = countList[thisPrefab].currentcount + 1
                    end

                    if this_max_prefabs[thisPrefab].max >= countList[thisPrefab].count then break end

                    if (v.components.hunger ~= nil and v.components.hunger.current > 0) or (v.components.domesticatable ~= nil and v.components.domesticatable.domestication > 0) then
                        break
                    end

                    RemoveItem(v)
                    countList[thisPrefab].currentcount = countList[thisPrefab].currentcount - 1
                until true
            end
        end

		if need_announce then
			for k,v in pairs(this_max_prefabs) do
				if countList[k] ~= nil and countList[k].count > v.max then
                    TheNet:Announce(string.format(STRINGS.CLEANINGS[2], countList[k].name, k, countList[k].count - countList[k].currentcount))
				end
			end
		end
    end

    local function CleanDelay()
		local world = STRINGS.CLEANINGS[5]
		if TheWorld:HasTag("forest") then
			world = STRINGS.CLEANINGS[3]
		end
		if TheWorld:HasTag("cave") then
			world = STRINGS.CLEANINGS[4]
		end

		TheNet:Announce(world..STRINGS.CLEANINGS[1])
        TheWorld:DoTaskInTime(5, Clean)
    end
	
	-- 自动清理
	if auto_clean then
		local cleancycle_ultimate = clean_cycle * TUNING.TOTAL_DAY_TIME

		AddPrefabPostInit("world", function(inst)
			TheWorld:DoPeriodicTask( cleancycle_ultimate , CleanDelay)
		end)
	end
	
	-- Get Player var userid
	local function GetPlayerById(playerid)
		for _, v in ipairs(GLOBAL.AllPlayers) do
			if v ~= nil and v.userid and v.userid == playerid then
				return v
			end
		end
		return nil
	end
	
	-- 按U输入#clean_world 手动清理
	local Old_Networking_Say = GLOBAL.Networking_Say
	GLOBAL.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
		Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
		if whisper and string.lower(message) == "#clean_world" then
		    local player = GetPlayerById(userid)
			if not (TheNet:GetIsServerAdmin() and player.components and player.Network:IsServerAdmin()) then
                player:DoTaskInTime(0.5, function() if player.components.talker then player.components.talker:Say(player:GetDisplayName() .. ", " .. "管理员才能清理世界") end end)
                return
            end
            if player then
                local charactername = STRINGS.CHARACTER_NAMES[prefab] or prefab
                player.components.talker:Say(player:GetDisplayName() .. " (" .. charactername .. ") " .. "清理手动清理世界！")
			    player:DoTaskInTime(0.5, CleanDelay)
			end
		end
	end
end
