local stack_size = 999

TUNING.STACK_SIZE_LARGEITEM = stack_size
TUNING.STACK_SIZE_MEDITEM = stack_size
TUNING.STACK_SIZE_SMALLITEM = stack_size
TUNING.STACK_SIZE_TINYITEM = stack_size
TUNING.WORTOX_MAX_SOULS = stack_size

AddPrefabPostInit("world", function(inst)
    local r_s = require("components/stackable_replica")

    r_s._ctor = function(self, inst)
        self.inst = inst
        self._stacksize = net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
        self._maxsize = net_tinybyte(inst.GUID, "stackable._maxsize")
    end
end)