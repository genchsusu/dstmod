local function TogglePickable(pickable, iswinter)
    pickable:Resume()
end

local function MakeNoGrowInWinter(inst)
    if inst.components.pickable then
        inst.components.pickable:WatchWorldState("iswinter", TogglePickable)
        TogglePickable(inst.components.pickable, GLOBAL.TheWorld.state.iswinter)
    end
end


GLOBAL.TogglePickable = TogglePickable
GLOBAL.MakeNoGrowInWinter = MakeNoGrowInWinter

