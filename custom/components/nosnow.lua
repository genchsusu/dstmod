AddComponentPostInit('weather', function(inst)
	local _OnUpdate = inst.OnUpdate
	function inst:OnUpdate(...)
		_OnUpdate(self, ...)
		GLOBAL.TheWorld.Map:SetOverlayLerp(0)
	end
end)