local function e_or_z(en, zh)
	return (locale == "zh" or locale == "zhr" or locale == "zht") and zh or en
end
name = "Gin's Mod"
author = "OpenSource"
version = "1.0.5"

description = [[
个人mod合集:

船只功能:增强转向速度,永不沉没,吸鱼功能,猴子船hp=1
灭火与保护:灭火器不灭营火,庇护所功能,防蚁狮,避雷针
天气与季节:雪不积累,冬季作物生长,营火生成无热量火墙,只允许玩家通过
生存加强:无惩罚复活,死亡后输入#复活,15秒重生无敌,火鸡晚上不回窝且生蛋
农业改良:四季可种植,自动种植与耕地生成,植物快速成熟,不枯萎,提高产量
特殊物品:蜂箱存量增至999,无蜜蜂出现,可种植特殊植物如芦苇和花瓣,池塘边长曼德拉草
友善果蝇:不会冰冻或燃烧,高血量与快速回血
工具与资源:工具无限耐久,高效工作模式,资源如石矿无限开采
自动化与堆叠:物品自动堆叠,最大堆叠量999,化肥可堆叠,修复堆叠bug
防御系统:墙体坚固,具备多功能防御,玩家可穿透
其他:水中木驱鸟,无草蜥蜴,加速农田挖掘,火鸡行走缓慢,手杖移速加倍,消耗品耐久提升
背包与箱子:全背包具备冰箱功能,防水,发光,增强大脑,保持体温,箱子容量增大,防摧毁,儲物箱添加吸尘器功能
]]

forumthread = ""

api_version = 10

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

dst_compatible = true
client_only_mod = false
all_clients_require_mod = true

priority = 0.1

local function header(label, client)
	return { name = "", label = label, options = { { description = "", data = "" } }, default = "", client = client }
end

local function AddConfig(label, name, hover, options, default)
	return {
		label = label,
		name = name,
		hover = hover or '',
		options = options or {
			{description = e_or_z("On", "开启"), data = true},
			{description = e_or_z("Off", "关闭"), data = false},
		},
		default = default
	}
end

configuration_options = {
    header(e_or_z("Containers", "容器类")),

    AddConfig(
        e_or_z("Backpacks Plus", "背包变态功能"), 
        "backpacks_plus_function", 
        e_or_z("Insulation, Protect from Tallbirds, Brain Boost, No Hunger", "保温。防高脚鸟。补脑。不会饥饿。"),
        nil, 
        false
    ),
    {	
		name = "backpacks_armor",
		label = e_or_z("Armor", "护甲"),
		hover = e_or_z("Set the armor rate of the backpacks", "设置背包的护甲"),
		options =
		{
            { description = e_or_z("Off", "禁用"), data = false },
            { description = "60%", data = 0.6 },
            { description = "75%", data = 0.75 },
            { description = "90%", data = 0.9 },
            { description = "100%", data = 1.0 },
		},
		default = 0.6,
	},
    {	
		name = "backpacks_light_range",
		label = e_or_z("Light Range", "灯光范围"),
		hover = e_or_z("Set the light range of the backpacks", "设置背包的灯光范围"),
		options =
		{
            { description = e_or_z("Tiny", "仅保命"), data = 0.5 },
            { description = e_or_z("Small", "小"), data = 1 },
            { description = e_or_z("Medium", "中"), data = 2 },
            { description = e_or_z("Large", "大"), data = 4 },
		},
		default = 0.5,
	},
    {	
		name = "chest_vaccum",
		label = e_or_z("Vaccum and Pick", "箱子吸纳和采集功能"),
		hover = e_or_z("Set the vaccum/pick range of the treasurechest", "设置箱子的吸收和采集范围"),
		options =
		{
            { description = e_or_z("Off", "禁用"), data = false },
            { description = "5", data = 5 },
            { description = "10", data = 10 },
            { description = "20", data = 20 },
		},
		default = false,
	},

    header(e_or_z("Plants", "种植类")),

    AddConfig(e_or_z("Quick Farm Plant", "快速种植"), "enable_quick_grow", e_or_z("Enable quick grow for farm plants.", "启用农场植物的快速生长。"), nil, false),
    AddConfig(e_or_z("Replant at Original Position", "原位置重新种植"), "enable_replant", e_or_z("Replant at original position after picking.", "在采摘后在原有位置重新种植。"), nil, false),
    AddConfig(e_or_z("Always Oversized Plant", "总是超重植物"), "always_oversized", e_or_z("Always oversized plant.", "总是超重植物。"), nil, false),

    header(e_or_z("Others", "其他类")),

    AddConfig(e_or_z("Periodic Resource Spawning", "动物定期生成资源"), "enable_animal_product", e_or_z("Enable spawning of specific items from animals.", "启用动物定期生成物品。"), nil, false),
    {	
		name = "fishingrod_time",
		label = e_or_z("fishingrod time", "淡水钓鱼时间"),
		hover = e_or_z("Set the fishingrod time", "设置淡水钓鱼时间"),
		options =
		{
            { description = e_or_z("Immediately", "瞬间"), data = 0 },
            { description = "3s", data = 3 },
            { description = "6s", data = 6 },
		},
		default = 3,
	},
}
