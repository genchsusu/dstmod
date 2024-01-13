GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

Recipe2("rope",                        {Ingredient("cutgrass", 3)},                                                  TECH.SCIENCE_ONE,   {numtogive = 20})
Recipe2("boards",                      {Ingredient("log", 4)},                                                       TECH.SCIENCE_ONE,   {numtogive = 20})
Recipe2("cutstone",                    {Ingredient("rocks", 3)},                                                     TECH.SCIENCE_ONE,   {numtogive = 20})
Recipe2("papyrus",                     {Ingredient("cutreeds", 4)},                                                  TECH.SCIENCE_ONE,   {numtogive = 20})
Recipe2("transistor",                  {Ingredient("goldnugget", 2), Ingredient("cutstone", 1)},                     TECH.SCIENCE_ONE,   {numtogive = 20})
Recipe2("waxpaper",                    {Ingredient("papyrus", 1), Ingredient("beeswax", 1)},                         TECH.SCIENCE_TWO,   {numtogive = 20})
Recipe2("beeswax",                     {Ingredient("honeycomb", 1)},                                                 TECH.SCIENCE_TWO,   {numtogive = 20})
Recipe2("marblebean",                  {Ingredient("marble", 1)},                                                    TECH.SCIENCE_TWO,   {numtogive = 20})
Recipe2("bearger_fur",                 {Ingredient("furtuft", 90)},                                                  TECH.SCIENCE_TWO,   {numtogive = 30})
Recipe2("nightmarefuel",               {Ingredient("petals_evil", 4)},                                               TECH.MAGIC_TWO,     {numtogive = 20})
Recipe2("purplegem",                   {Ingredient("redgem",1), Ingredient("bluegem", 1)},                           TECH.MAGIC_TWO,     {no_deconstruction=true, numtogive = 20})
Recipe2("moonrockcrater",              {Ingredient("moonrocknugget", 3)},                                            TECH.SCIENCE_TWO,   {numtogive = 20})
Recipe2("malbatross_feathered_weave",  {Ingredient("malbatross_feather", 6), Ingredient("silk", 1)},                 TECH.SCIENCE_TWO,   {numtogive = 20})
Recipe2("refined_dust",                {Ingredient("saltrock", 1), Ingredient("rocks", 2), Ingredient("nitre", 1)},  TECH.LOST,          {numtogive = 20})

Recipe2("wall_hay_item",               {Ingredient("cutgrass", 4), Ingredient("twigs", 2)},                          TECH.SCIENCE_ONE,   {numtogive=99})
Recipe2("fence_item",                  {Ingredient("twigs", 3), Ingredient("rope", 1)},                              TECH.SCIENCE_ONE,   {numtogive=99})
Recipe2("wall_wood_item",              {Ingredient("boards", 2), Ingredient("rope", 1)},                             TECH.SCIENCE_ONE,   {numtogive=99})
Recipe2("wall_stone_item",             {Ingredient("cutstone", 2)},                                                  TECH.SCIENCE_TWO,   {numtogive=99})
Recipe2("wall_moonrock_item",          {Ingredient("moonrocknugget", 4)},                                            TECH.SCIENCE_TWO,   {numtogive=99})
Recipe2("wall_dreadstone_item",        {Ingredient("dreadstone", 4)},                                                TECH.LOST,          {numtogive=99})



-- 可以制作坎普斯背包
STRINGS.RECIPE_DESC.KRAMPUS_SACK = "Can carry more stuff."

AddRecipe2(
    "krampus_sack",
    {Ingredient("cutgrass", 4), Ingredient("twigs", 4)},
    TECH.SCIENCE_ONE,
    nil,
    {"CONTAINERS"}
)
