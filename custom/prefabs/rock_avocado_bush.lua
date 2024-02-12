AddPrefabPostInit("rock_avocado_bush", function(inst)
    if inst.components.growable ~= nil and inst.components.pickable ~= nil then
        inst.components.growable.stages[1].time = function(inst) return 5 end
        inst.components.growable.stages[2].time = function(inst) return 5 end
        inst.components.growable.stages[3].time = function(inst) return 5 end
        inst.components.growable.stages[4].time = function(inst) return TUNING.TOTAL_DAY_TIME end
        inst.components.growable.stages[4].fn = function(inst)
            inst.components.pickable:ChangeProduct("rock_avocado_fruit")
            if not inst.components.pickable:CanBePicked() then
                inst.components.pickable:Regen()
            end
            inst.AnimState:PlayAnimation("idle4")
        end

        local restart = function(inst)
            if inst.components.pickable ~= nil then
                inst.components.growable:SetStage(1)
                inst.components.growable:StartGrowing()
            end
        end

        inst.components.pickable.onpickedfn = function(inst)
            local picked_anim = (inst.components.growable.stage == 3 and "picked") or "crumble"
            inst.AnimState:PlayAnimation(picked_anim)
            inst.components.pickable.cycles_left = 5
            restart(inst)
        end

        inst.components.pickable.makeemptyfn = restart
        inst.components.pickable.makebarrenfn = restart
    end
end)
