local function DoNothing() end

-- 蜜蜂
AddBrainPostInit("beebrain", function(brain)
    for i, node in ipairs(brain.bt.root.children) do
        if node.name == "Sequence" and (node.children[1].name == "IsWinter" or node.children[1].name == "IsNight") then
            node.children[1].fn = function()
                return false
            end
        end
    end
end)

-- 蝴蝶
AddBrainPostInit("butterflybrain", function(brain)
    for i, node in ipairs(brain.bt.root.children) do
        if node.name == "Sequence" and (node.children[1].name == "IsNight" or node.children[1].name == "IsFullOfPollen") then
            node.children[1].fn = function() return false end
        end
    end
end)

-- 火鸡
AddBrainPostInit("perdbrain", function(brain)
    for i, node in ipairs(brain.bt.root.children) do
        if node.name == "Parallel" and node.children[1].name == "IsNight" then
            node.children[1].fn = function() return false end
        end

        if node.name == "Eat Food" or node.name == "Pick Berries" then
            node.getactionfn = DoNothing
        end

        if node.name == "RunAway" then
            node.see_dist = 1
            node.safe_dist = 1
        end

        if node.name == "Wander" then
            node.homepos = nil
            node.max_dist = 5
        end
    end
end)