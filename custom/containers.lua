local Vector3 = GLOBAL.Vector3
local require = GLOBAL.require
local deepcopy = GLOBAL.deepcopy

local function SetChest_80(container)
    container.widget =
    {
        slotpos = {},
        animbank = "ui_chest_5x16",
        animbuild = "ui_chest_5x16",
        pos = Vector3(0, 215, 0),
        side_align_tip = 160,
    }

    for y = 3.5, -0.5, -1 do
        for x = -0, 15 do
            table.insert(container.widget.slotpos, Vector3(80 * x - 80 * 8.5 + 80, 80 * y - 100 * 2 + 80,0))
        end
    end
end

local function SetChest_160(container)
    container.widget =
    {
        slotpos = {},
        animbank = "ui_chest_8x20",
        animbuild = "ui_chest_8x20",
        pos = Vector3(-28 , 210, 0),
        side_align_tip = 160,
    }

    for y = 7, 0, -1 do
        for x = 0, 19 do
            table.insert(container.widget.slotpos, Vector3(80 * x - 80 * 2 - 602, 80 * y - 80 * 2 - 120, 0))
        end
    end
end

local containers = require("containers")
local params = containers.params

SetChest_160(params.shadowchester)
params.shadow_container = deepcopy(params.shadowchester)
params.shadow_container.widget.animbank = "ui_chest_8x20"
params.shadow_container.widget.animbuild = "ui_chest_8x20"
params.shadow_container.widget.animloop = true
params.dragonflychest = params.shadowchester
params.minotaurchest = params.shadowchester

SetChest_80(params.icebox)
params.saltbox = deepcopy(params.icebox)

SetChest_80(params.treasurechest)


params.pandoraschest = params.treasurechest
params.skullchest = params.treasurechest
params.terrariumchest = params.treasurechest
params.sunkenchest = params.treasurechest

params.quagmire_safe = deepcopy(params.treasurechest)
params.quagmire_safe.widget.animbank = "ui_chest_5x16"
params.quagmire_safe.widget.animbuild = "ui_chest_5x16"

SetChest_80(params.fish_box)

-- Change size of Backpacks
local function updatecontainer(container)
	container.widget =
    {
        slotpos = {},
        animbank = nil,
        animbuild = nil,
        bgatlas = "images/sack27.xml",
        bgimage = "sack27.tex",
        pos = Vector3(-50 - 23 * 2 - 0, 125 - 23 * 8 + 0, 0),
    }

    for y = 0, 8 do
        table.insert(container.widget.slotpos, Vector3(0 + 75, 0 - y * 75 + 300, 0))
        table.insert(container.widget.slotpos, Vector3(0 - 75 + 75, 0 - y * 75 + 300, 0))
        table.insert(container.widget.slotpos, Vector3(0 - 75 - 75 + 75, 0 - y * 75 + 300, 0))
    end
end
updatecontainer(params.backpack)
params.icepack = params.backpack
updatecontainer(params.krampus_sack)
updatecontainer(params.piggyback)


for k, v in pairs(params) do
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

