-- 解锁全图鉴
AddPlayerPostInit(
    function(inst)
        inst:DoTaskInTime(0, function()
            if inst == ThePlayer then
                TheScrapbookPartitions:DebugUnlockEverything()
            end
        end)
    end
)

local skilltreedefs = require "prefabs/skilltree_defs"
AddPlayerPostInit(function(inst)
	local skills = skilltreedefs.SKILLTREE_DEFS[inst.prefab]
	local updater = inst.components.skilltreeupdater
	if skills and updater then
		updater.IsActivated = function(self, skill)
			return skills[skill]
		end
		updater.HasSkillTag = function()
			return true
		end
		local activated = updater.skilltree.activatedskills[inst.prefab] or {}
		for skill, data in pairs(skills) do
			if not data.lock_open and not activated[skill] then
				if TheNet:GetIsServer() then
					updater:ActivateSkill_Server(skill)
				end
				if inst == ThePlayer then
					updater:ActivateSkill_Client(skill)
				end
			end
		end
	end
end)
