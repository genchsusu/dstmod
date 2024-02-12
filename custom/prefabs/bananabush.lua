AddPrefabPostInit("bananabush", function(inst)
    if inst.components.growable ~= nil and inst.components.pickable ~= nil then
        inst.components.growable.stages[1].time = function(inst) return 5 end
        inst.components.growable.stages[2].time = function(inst) return 5 end
        inst.components.growable.stages[3].time = function(inst) return 5 end
        inst.components.growable.stages[4].time = function(inst) return TUNING.TOTAL_DAY_TIME end
    
        local restart = function(inst)
            if inst.components.pickable ~= nil then
                inst.components.growable:SetStage(1)
                inst.components.growable:StartGrowing()
            end
        end
    
        inst.components.pickable.onpickedfn = function(inst)
            inst.components.pickable.cycles_left = 5
            restart(inst)
        end
    
        inst.components.pickable.makebarrenfn = restart
        inst.components.growable.loopstages = true
    end
end)
