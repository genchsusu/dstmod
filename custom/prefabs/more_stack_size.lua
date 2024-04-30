local stack_size = 999

TUNING.STACK_SIZE_LARGEITEM = stack_size
TUNING.STACK_SIZE_MEDITEM = stack_size
TUNING.STACK_SIZE_SMALLITEM = stack_size
TUNING.STACK_SIZE_TINYITEM = stack_size
TUNING.WORTOX_MAX_SOULS = stack_size

local function OnStackSizeDirty(inst)
	local self = inst.replica.stackable
	if not self then
		return
	end

	self:ClearPreviewStackSize()
	inst:PushEvent("inventoryitem_stacksizedirty")
end
	
local mod_stackable_replica = require("components/stackable_replica")

mod_stackable_replica._ctor = function(self, inst)
	self.inst = inst
	self._stacksize = net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
	self._stacksizeupper = net_shortint(inst.GUID, "stackable._stacksizeupper", "stacksizedirty")
	self._ignoremaxsize = net_bool(inst.GUID, "stackable._ignoremaxsize")
	self._maxsize = net_shortint(inst.GUID, "stackable._maxsize")
	
	if not TheWorld.ismastersim then
		inst:ListenForEvent("stacksizedirty", OnStackSizeDirty)
	end
end


-- AddPrefabPostInit("world", function(inst)
--     local r_s = require("components/stackable_replica")

--     r_s._ctor = function(self, inst)
--         self.inst = inst
--         self._stacksize = net_shortint(inst.GUID, "stackable._stacksize", "stacksizedirty")
--         self._maxsize = net_tinybyte(inst.GUID, "stackable._maxsize")
--     end
-- end)
