-- scripts\utils\savedata.lua
local SaveData = Class(function(self, path)
	assert(type(path) == "string", "SaveData class expected base path for arg#1")
	self.initialized = false
	self.path = path
	self.fast_save = true
	self.compress = false

	self.data = {}
	self.dirty = false
	self.ready = false
end)

function SaveData:IsReady()
	return self.ready
end

function SaveData:IsDirty()
	return self.dirty
end

function SaveData:SetDirty(dirty)
	if self.dirty ~= dirty then
		self.dirty = dirty
	end
end

function SaveData:SetValue(name, value)
	self.data[name] = value
	self:SetDirty(true)
end
SaveData.Set = SaveData.SetValue

function SaveData:GetValue(name)
	return self.data[name]
end
SaveData.Get = SaveData.GetValue

--- Loads save data.
function SaveData:Load()
	--local path = KnownModIndex:GetModConfigurationPath(modname, true) .. "_SECONDARY"
	local path = self.path --.. (client and "_CLIENT" or "")
	
	--local load, parse, save = nil, nil, nil
	TheSim:GetPersistentString(path,
		function(load_success, str)
			if load_success == true then
				local success, savedata = RunInSandboxSafe(str)
				if success and string.len(str) > 0 then
					print("[SaveData] Loaded " .. path)
					self.data = savedata
					self.ready = true
				else
					print("[SaveData] Could not load " .. path)
				end
			else
				print("[SaveData] Error loading load " .. path)
			end
		end
	)

	return self.data
end

function SaveData:Save(callback, force)
	if self.dirty or force then
		if not self.ready then
			self.ready = true
		end

		local str = DataDumper(self.data, nil, self.fast_save)
        
		-- Make sure nothing funky is in here.
		local patterns = {"=nan", "=-nan", "=inf", "=-inf", "=-1.#IND", "=1.#QNAN", "=1.#INF", "=-1.#INF"}
		for i,v in pairs(patterns) do
			local found = string.find(str, v, 1, true)
			if found ~= nil then
				local bad_data = string.sub(str, found - 100, found + 50)
				print(bad_data)
				error("Error saving InsightSaveData, corruption detected.")
			end
		end

		TheSim:SetPersistentString(self.path, str, self.compress, callback)
		print("[SaveData] Saved " .. self.path)
		self:SetDirty(false)
	else
		print("[SaveData] NOT SAVING " .. self.path .. ", did you forget to mark as dirty?")
		if callback then
			return callback(true)
		end
	end
end

return SaveData