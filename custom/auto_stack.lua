if not (TheNet:GetIsServer() or TheNet:IsDedicated()) then
    return
end

local autoStackEnabled = true
local autoStackRange = 10

local function CanAutoStack(item)
    if not item:HasTag("smallcreature") or not item:HasTag("flying") then
        return true
    end
    return false
end

local function TryAddToStack(item, target)
    if item and target and target ~= item and target.prefab == item.prefab
    and item.components.inventoryitem and item.components.inventoryitem.owner == nil
    and target.components.inventoryitem and target.components.inventoryitem.owner == nil
    and target.components.stackable and not target.components.stackable:IsFull()
    and item.components.stackable and not item.components.stackable:IsFull()
    and CanAutoStack(item) then
        target.components.stackable:Put(item)
        return true
    end
    return false
end

local function AutoStack(inst)
    if inst:IsValid() and inst.components.stackable and inst.components.inventoryitem
    and inst.components.inventoryitem.owner == nil and not inst.components.stackable:IsFull()
    and CanAutoStack(inst) then
        local x, y, z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x, y, z, autoStackRange, { "_inventoryitem" }, { "INLIMBO", "NOCLICK", "catchable", "fire" })
        for _, obj in pairs(ents) do
            if TryAddToStack(inst, obj) then
                break
            end
        end
    end
end

AddComponentPostInit("stackable", function(comp)
    local compInst = comp.inst
    compInst:DoTaskInTime(0, function(inst)
        if inst.components.stackable and not inst:HasTag("fire") and inst.components.inventoryitem and inst.components.inventoryitem.owner == nil then
            AutoStack(inst)
        end
    end)
end)