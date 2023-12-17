你作为一个资深的饥荒mod开发者，非常熟悉lua代码并可以处理任何稀奇古怪的需求。我将向你提出需求，需要你给出对应的代码，你可能需要我提供思路，sample代码或者梳理需求。
现在我们开始。测试你，下面代码和原版代码的diff对比，分析一下它的作用。

创建一个新的Lua文件，并在游戏加载时通过modmain.lua引入它。

2023.12.07 基本上加完了，测试一下bug吧。

2023.12.08 修改已经存在的组件行为，重构一下，省的每次都要全部重写。


components
```
## birdspawner 驱逐鸟类
--用的时候增加标签
inst:AddTag("drive_bird_scarecrow")
如main/watertree_pillar.lua
## boatphysics
船只最大转向速度
## firedetector
firedetector组建不侦测campfire的tag
## nosnow
下雪不堆积
## respawn
死亡不掉落物品 重生15秒无敌
## protectionwall
保护圈 360度保护
```

brain
```
## perdbrain
火鸡晚上不回窝
```

prefabs
```
## all_backpacks
krampus_sack,piggyback,backpack背包冰箱,防水,发光,补脑,体温恒定35度
## all_chests
"dragonflychest", "fish_box", "icebox", "magician_chest", "saltbox", "treasurechest", "shadowchester", "shadow_container", "minotaurchest"
扩大箱子,冰箱,防水,无法被摧毁
其中
treasurechest增加了吸尘器系统
## all_season_farm_plant
四季都可以种植,必然超大果,农田采摘完毕没有荆棘然后生成耕地然后自动种植,dig_up/burnt自动生成耕地
## bananabush
植物不枯萎,高速收获,永远可摘
## beebox
蜂箱提高至999,收获不出蜜蜂
## boat
boat/boat_grass永不沉没and增加吸鱼功能,猴子船降到1滴血
## fire
"campfire", "firepit", "coldfire", "coldfirepit"
调用protectionwall 生成保护墙
## firesuppressor
庇护所 防鸟 防蚁狮 避雷针
## force_plant
可以种植芦苇,花瓣
## friendlyfruitfly 友善果蝇
不会被冰冻
不会被点燃
最大血量1000且高速回血
远离玩家时依然会工作
## general_plants
植物提高产量    
grass,berrybush,berrybush2,berrybush_juicy,monkeytail,sapling,sapling_moon
## infiniteuses
无限耐久
## log
烧木头生成灰10 木炭10
## perd
火鸡生蛋
## pond
池塘边生成曼德拉草
## quick_work
高效工作,采集,砍树,挖矿,锤,淡水急速钓鱼
## rock_avocado_bush
石果快速生成
## rocks
石矿无限开采,提升产量
## soil_amender
化肥可堆叠
## stack_ui_fix
修复堆叠数量显示不正确的bug
## walls
墙吸收100%伤害,无法被瞬间摧毁,庇护所,防鸟,防蚁狮,避雷针,发光,补脑,玩家可以直接穿透
## watertree_pillar
水中木驱鸟

```

Utils
```
## auto_stack
自动堆叠物品
## containers
容器扩大80和160
## resurrect
Y/U根据游戏语言输入#复活/#resurrect 进行复活
## standardcomponents
冬天继续生长
## tuning
堆叠999
复活无惩罚
无草蜥蜴
高速挖田
火鸡走路慢
走路手杖2倍移速
消耗品几乎无消耗
```

TODO 
魔术箱子仍然没有动画
evergreens
farm_plants
farm_plow
weed_plants