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
local chest_vacuum = GetModConfigData('chest_vaccum')
if chest_vacuum then
    local VACUUM_RANGE = GetModConfigData('chest_vaccum') or 10
    local VACUUM_PERIOD = 0.1
    local BAN_LIST = {"bullkelp_beached", "spoiled_food", "mandrake", "cursed_monkey_token"}

    local function OnEnableHelper(inst)
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
            local PLACER_SCALE = math.sqrt( VACUUM_RANGE * 300 / 1900)
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
        else
            inst.helper:Remove()
            inst.helper = nil
        end
    end

    local pick_list = {
        "berrybush_juicy",
        "bullkelp_plant",
    }

    for k, v in pairs(pick_list) do  
        AddPrefabPostInit(v, function(inst)
            if not TheWorld.ismastersim then
                return inst
            end

            inst:AddTag("plant_can_pick")
            if inst.components.pickable ~= nil then 
                inst.components.pickable.droppicked = nil
            end 
        end)
    end

    AddPrefabPostInit("treasurechest", function(inst) 
        -- Dedicated server does not need deployhelper
        if not GLOBAL.TheNet:IsDedicated() then
            inst:AddComponent("deployhelper")
            inst.components.deployhelper.onenablehelper = OnEnableHelper
        end

        inst:AddComponent("inventory") --箱子拥有物品栏属性（自动采集需要）
        inst.components.inventory.maxslots = 0
        inst.components.inventory.GetOverflowContainer = function(self)
            return self.inst.components.container
        end

        local function isItemValid(ent)
            return ent.components.inventoryitem 
            and ent.components.inventoryitem.canbepickedup 
            and ent.components.inventoryitem.cangoincontainer 
            and not table.contains(BAN_LIST, ent.prefab)
        end

        local function createShadowEffect(inst, pos)
            -- Create a shadow effect
            local shadowpuff = SpawnPrefab("shadow_puff_large_front")
            shadowpuff.Transform:SetPosition(pos.x, 0, pos.z)
            shadowpuff.Transform:SetScale(0.7, 0.7, 0.7)            
            SpawnPrefab("shadow_despawn").Transform:SetPosition(pos.x, 1, pos.z)
            if inst.AnimState:IsCurrentAnimation("closed") or inst.AnimState:IsCurrentAnimation("close") then
                inst.AnimState:PlayAnimation("hit")
                inst.AnimState:PushAnimation("closed", false)
            end
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
        end

        local function pickupItem(inst, item, pos)
            createShadowEffect(inst, pos)
            inst.components.container:GiveItem(item)
        end

        local function canPickupItem(inst, item)
            -- Check if item can be stacked and if there is a stackable item in the chest
            local canStackItem = item.components.stackable and inst.components.container:FindItem(function(i)
                return (i.prefab == item.prefab and not i.components.stackable:IsFull())
            end)

            return not inst.components.container:IsFull() or canStackItem
        end
        
        local function autoHarvest(inst)
            local x,y,z = inst.Transform:GetWorldPosition() 
            local ents = TheSim:FindEntities(x,y,z, VACUUM_RANGE, nil, { "INLIMBO" }) 
            for _, ent in pairs(ents) do 
                if ent.components.pickable
                and ent.components.pickable:CanBePicked()
                and ent.components.pickable.droppicked == nil 
                and ((ent:HasTag("plant") or ent:HasTag("plant_can_pick")) and not ent.is_oversized) 
                and canPickupItem(inst, ent) then
                    createShadowEffect(inst, ent:GetPosition())
                    ent.components.pickable:Pick(inst) 
                end 
        
                if ent.components.harvestable
                and ent.components.harvestable:CanBeHarvested()
                and ent.components.harvestable.produce == ent.components.harvestable.maxproduce 
                and canPickupItem(inst, ent) then
                    createShadowEffect(inst, ent:GetPosition())
                    ent.components.harvestable:Harvest(inst) 
                end 
        
                if ent.components.dryer
                and ent.components.dryer:IsDone()
                and ent.components.dryer.ingredient == nil
                and canPickupItem(inst, ent) then
                    createShadowEffect(inst, ent:GetPosition())
                    ent.components.dryer:Harvest(inst) 
                end
            end
        end

        local function vacuum(inst)
            local Item = FindEntity(inst, VACUUM_RANGE, isItemValid, {"_inventoryitem"}, {"INLIMBO", "NOCLICK", "catchable", "fire", "trap", "minesprung", "mineactive"})
            
            if Item and canPickupItem(inst, Item) then
                pickupItem(inst, Item, Item:GetPosition())
            end

            autoHarvest(inst)
        end

        inst:DoPeriodicTask(VACUUM_PERIOD, vacuum)
    end)
end