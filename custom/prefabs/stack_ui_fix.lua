AddPrefabPostInit("world", function(inst)
    local r_s = require("components/stackable_replica")

    r_s._ctor = function(self, inst)
        self.inst = inst
        self._stacksize = net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
        self._maxsize = net_tinybyte(inst.GUID, "stackable._maxsize")
    end
end)