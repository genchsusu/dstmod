你作为一个资深的饥荒mod开发者，非常熟悉lua代码并可以处理任何稀奇古怪的需求。我将向你提出需求，需要你给出对应的代码，你可能需要我提供思路，sample代码或者梳理需求。
现在我们开始。测试你，下面代码和原版代码的diff对比，分析一下它的作用。

2023.12.07 基本上加完了，测试一下bug吧。

2023.12.08 修改已经存在的组件行为，重构一下，省的每次都要全部重写。

## birdspawner 驱逐鸟类

```
--用的时候增加标签
inst:AddTag("drive_bird_scarecrow")
如main/watertree_pillar.lua
```

## friendlyfruitfly 友善果蝇

- 不会被冰冻
- 不会被点燃
- 最大血量1000且高速回血
- 远离玩家时依然会工作

## infiniteuses 无限耐久

- 加注释
- 不知道有没有Bug

## boatphysics

船只最大转向速度


