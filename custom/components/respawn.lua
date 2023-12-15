-- Don't drop anything on death.
AddComponentPostInit("inventory", function (self)
    if self.inst:HasTag("player") then
        local Old_DropEverything = self.DropEverything

        self.DropEverything = function(self, ondeath, keepequip)
            if (ondeath) then
                -- For WX-78's modules, they will be dropped!
                if (self.inst.components.upgrademoduleowner ~= nil) then
                    -- The game pushes their modules into the ActiveItem slot(the mouse cursor), this prevents them from respawning correctly.
                    -- So drop it!
                    self.inst.components.inventory:DropActiveItem()
                end
            end

            if (not ondeath) then
                Old_DropEverything(self, ondeath, keepequip)
            end
        end
    end
end)

-- When Haunting to Respawn, you'll get Spawn Protection like Griefer Spawn Protection.
AddPlayerPostInit(function (Prefab)
    Prefab:ListenForEvent("respawnfromghost", function (inst)
        inst:DoTaskInTime(15 * GLOBAL.FRAMES, function (inst)
            if (inst.components.debuffable ~= nil) then
                inst.components.debuffable:AddDebuff("spawnprotectionbuff", "spawnprotectionbuff")
            end
        end)
    end)
end)