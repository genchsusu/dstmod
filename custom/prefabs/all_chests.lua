local function ModifyChest(inst, name)
    table.insert(GLOBAL.Prefabs[name].assets, Asset("ANIM", GLOBAL.resolvefilepath("anim/ui_chest_8x20.zip")))
    table.insert(GLOBAL.Prefabs[name].assets, Asset("ANIM", GLOBAL.resolvefilepath("anim/ui_chest_5x16.zip")))
    inst.entity:AddAnimState() -- restart anim

    inst:AddTag("fridge")
    inst:AddTag("waterproofer")
    inst:AddComponent("waterproofer")
    -- 禁止燃烧
    if inst.components.burnable ~= nil then
        inst:RemoveComponent("burnable")
    end
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
    
    if inst.components.workable then
        local old_Destroy = inst.components.workable.Destroy
        function inst.components.workable:Destroy(destroyer)
            if destroyer.components.playercontroller == nil then return	end
            return old_Destroy(self,destroyer)
        end
    end
end

local items = {"dragonflychest", "fish_box", "icebox", "magician_chest", "saltbox", "treasurechest", "shadowchester", "shadow_container", "minotaurchest"}

for _, item in ipairs(items) do
    AddPrefabPostInit(item, function(inst)
        ModifyChest(inst, item)
    end)
end

-- 再加个吸尘器系统
local VACUUM_RANGE = 10
local VACUUM_PERIOD = 0.01
local BAN_LIST = {"bullkelp_beached", "spoiled_food", "mandrake", "cursed_monkey_token"}

local function OnEnableHelper(inst, enabled)
    if enabled then
        if inst.helper == nil then
            inst.helper = CreateEntity()

            --[[Non-networked entity]]
            inst.helper.entity:SetCanSleep(false)
            inst.helper.persists = false

            inst.helper.entity:AddTransform()
            inst.helper.entity:AddAnimState()

            inst.helper:AddTag("CLASSIFIED")
            inst.helper:AddTag("NOCLICK")
            inst.helper:AddTag("placer")
            --minus or add 0.25 for every 5 range
            local PLACER_SCALE = VACUUM_RANGE == 10 and 1.255 or VACUUM_RANGE == 15 and 1.55 or VACUUM_RANGE == 20 and 1.75
            -- local PLACER_SCALE = 1.0 + ((VACUUM_RANGE / 5) * 0.25)
            inst.helper.Transform:SetScale(PLACER_SCALE, PLACER_SCALE, PLACER_SCALE)

            inst.helper.AnimState:SetBank("firefighter_placement")
            inst.helper.AnimState:SetBuild("firefighter_placement")
            inst.helper.AnimState:PlayAnimation("idle")
            inst.helper.AnimState:SetLightOverride(1)
            inst.helper.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
            inst.helper.AnimState:SetLayer(LAYER_BACKGROUND)
            inst.helper.AnimState:SetSortOrder(1)
            inst.helper.AnimState:SetAddColour(0, .2, .5, 0)

            inst.helper.entity:SetParent(inst.entity)
        end
    elseif inst.helper ~= nil then
        inst.helper:Remove()
        inst.helper = nil
    end
end

AddPrefabPostInit("treasurechest", function(inst) 
    -- Dedicated server does not need deployhelper
    if not GLOBAL.TheNet:IsDedicated() then
        inst:AddComponent("deployhelper")
        inst.components.deployhelper.onenablehelper = OnEnableHelper
    end

    -- 定义吸入物品的函数
    local function suckit(item)
        if inst.AnimState:IsCurrentAnimation("closed") or inst.AnimState:IsCurrentAnimation("close") then
            inst.AnimState:PlayAnimation("hit")
            inst.AnimState:PushAnimation("closed", false)
        end
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
        inst.components.container:GiveItem(item)
    end

    -- 检查物品是否在禁拿清单上
    local function itemExists(item)
        return table.contains(BAN_LIST, item)
    end

    local function vacuum(inst)
        local function IsItem(ent)
            return ent.components.inventoryitem and ent.components.inventoryitem.canbepickedup and ent.components.inventoryitem.cangoincontainer and not itemExists(ent.prefab)
        end

        local Item = FindEntity(inst, VACUUM_RANGE, IsItem, {"_inventoryitem"}, {"INLIMBO", "NOCLICK", "catchable", "fire", "trap", "minesprung", "mineactive"})
        
        if Item then
            if not inst.components.container:IsFull() or (Item.components.stackable and inst.components.container:FindItem(function(i) return (i.prefab == Item.prefab and not i.components.stackable:IsFull()) end)) then
                local pos = Item:GetPosition() 
                local shadowpuff = SpawnPrefab("shadow_puff_large_front")
                shadowpuff.Transform:SetPosition(pos.x, 0, pos.z)
                shadowpuff.Transform:SetScale(0.7, 0.7, 0.7)			
                SpawnPrefab("shadow_despawn").Transform:SetPosition(pos.x, 1, pos.z)
                suckit(Item)
                inst:DoTaskInTime(0, function(inst)
                    SpawnPrefab("pandorachest_reset").Transform:SetPosition(inst.Transform:GetWorldPosition())
                end)
            end
        end
    end

    inst:DoPeriodicTask(VACUUM_PERIOD, vacuum)
end)