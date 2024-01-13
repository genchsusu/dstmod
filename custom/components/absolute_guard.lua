--防雨(包括酸雨和玻璃雨）（半径7格地皮的圆）
AddComponentPostInit("sheltered", function(self)
	local old_OnUpdate = self.OnUpdate
	self.OnUpdate = function(self, dt)
		local x, y, z = self.inst.Transform:GetWorldPosition()
		if #TheSim:FindEntities(x, y, z, 28, { "absolute_guard" }) > 0 then
			if self.inst.components.rainimmunity == nil then
				self.inst:AddComponent("rainimmunity")
			end
			self.inst.components.rainimmunity:AddSource(self.inst)

			self.sheltered = true

			return
		else
			if self.inst.components.rainimmunity ~= nil then
				self.inst.components.rainimmunity:RemoveSource(self.inst)
			end
		end

		old_OnUpdate(self, dt)
	end
end)

--防蚁狮陷坑
AddComponentPostInit("sinkholespawner", function(self)
	local old_SpawnSinkhole = self.SpawnSinkhole
	self.SpawnSinkhole = function(self, spawnpt)
		local x = spawnpt.x
		local z = spawnpt.z
		if #TheSim:FindEntities(x, 0, z, 28, { "absolute_guard" }) > 0 then
			return
		end

		old_SpawnSinkhole(self, spawnpt)
	end
end)