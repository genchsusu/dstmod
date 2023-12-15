AddPrefabPostInit("world", function(inst)
    local r_s = GLOBAL.require("components/stackable_replica")

    r_s._ctor = function(self, inst)
        self.inst = inst
        self._stacksize = GLOBAL.net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
        self._maxsize = GLOBAL.net_tinybyte(inst.GUID, "stackable._maxsize")
    end
end)