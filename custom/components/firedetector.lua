-- FindFunctionByName: 用于通过名称查找函数
local function FindFunctionByName(inst, name)
    local i, _value, _name = 0, nil, ""
    while _name ~= name do
        i = i + 1
        _name, _value = debug.getupvalue(inst, i)
    end
    return _value
end

-- AddComponentPostInit: 用于修改firedetector组件
AddComponentPostInit("firedetector", function(inst)
    local old_function = FindFunctionByName(inst.DetectFire, "LookForFiresAndFirestarters")
    local i, _value, _name = 0, nil, ""
    if type(old_function) == "function" then
        while _name ~= "NOTAGS" do
            i = i + 1
            _name, _value = debug.getupvalue(old_function, i)
        end
        if type(_value) == "table" then
            table.insert(_value, "campfire")
        end
    end
end)