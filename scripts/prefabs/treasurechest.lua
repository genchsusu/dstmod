require "prefabutil"

local SUNKEN_PHYSICS_RADIUS = .45

-- Gin vacuum_chest
local VACUUM_RANGE = 20
local VACUUM_PERIOD = 0.1
-- Gin vacuum_chest

local function onopen(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("open")

        if inst.skin_open_sound then
            inst.SoundEmitter:PlaySound(inst.skin_open_sound)
        else
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
        end
    end
end

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", false)

        if inst.skin_close_sound then
            inst.SoundEmitter:PlaySound(inst.skin_close_sound)
        else
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
        end
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    if inst.skin_place_sound then
        inst.SoundEmitter:PlaySound(inst.skin_place_sound)
    else
        inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
    end
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

-- Gin vacuum_chest
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
-- Gin vacuum_chest

local function MakeChest(name, bank, build, indestructible, master_postinit, prefabs, assets, common_postinit, force_non_burnable)
    local default_assets =
    {
        Asset("ANIM", "anim/"..build..".zip"),
        Asset("ANIM", "anim/ui_chest_3x2.zip"),
        Asset("ANIM", "anim/ui_chest_5x16.zip"),
        Asset("ANIM", "anim/ui_chest_8x20.zip"),
    }
    assets = assets ~= nil and JoinArrays(assets, default_assets) or default_assets

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddMiniMapEntity()
        inst.entity:AddNetwork()

        inst.MiniMapEntity:SetIcon(name..".png")

        inst:AddTag("structure")
        inst:AddTag("chest")
        inst:AddTag("fridge") -- Gin
        -- Gin vacuum_chest
        --Dedicated server does not need deployhelper
        if not TheNet:IsDedicated() then
            inst:AddComponent("deployhelper")
            inst.components.deployhelper.onenablehelper = OnEnableHelper
        end
        -- Gin vacuum_chest
        inst.AnimState:SetBank(bank)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("closed")

        inst.scrapbook_anim="closed"

        if name == "pandoraschest" or name == "terrariumchest" then
            inst.scrapbook_specialinfo = "TREASURECHEST"
        end

		MakeSnowCoveredPristine(inst)

        if common_postinit ~= nil then
            common_postinit(inst)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            -- Gin vacuum_chest
            inst.OnEntityReplicated = function(inst) 
                inst.replica.container:WidgetSetup(name) 
            end
            -- Gin vacuum_chest
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("container")
        inst.components.container:WidgetSetup(name)
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose
        inst.components.container.skipclosesnd = true
        inst.components.container.skipopensnd = true


        if not indestructible then
            inst:AddComponent("lootdropper")
            inst:AddComponent("workable")
            inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
            inst.components.workable:SetWorkLeft(2)
            inst.components.workable:SetOnFinishCallback(onhammered)
            inst.components.workable:SetOnWorkCallback(onhit)

            -- Gin 仅玩家攻击
            local old_Destroy = inst.components.workable.Destroy
            function inst.components.workable:Destroy(destroyer)
                if destroyer.components.playercontroller == nil then return	end
                return old_Destroy(self,destroyer)
            end
            -- Gin 仅玩家攻击
            if not force_non_burnable then
                MakeSmallBurnable(inst, nil, nil, true)
                MakeMediumPropagator(inst)
            end
        end

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        inst:ListenForEvent("onbuilt", onbuilt)
        MakeSnowCovered(inst)

        -- Gin vacuum_chest
        local function suckit(item)
            if inst.AnimState:IsCurrentAnimation("closed") or inst.AnimState:IsCurrentAnimation("close") then
                inst.AnimState:PlayAnimation("hit")
                inst.AnimState:PushAnimation("closed", false)
            end
            inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
            inst.components.container:GiveItem(item)
        end
    
    	-- 禁拿清单
        local itemLists = {"bullkelp_beached", "spoiled_food", "mandrake", "cursed_monkey_token"}
        local function itemExists(item)
            for i = 0, #itemLists do
                if itemLists[i] == item then
                    return true
                end
            end
            return false
        end

        local function vacuum(inst)
            local SEARCH_RADIUS = VACUUM_RANGE
    
            local function IsItem(ent)
                return ent.components.inventoryitem and ent.components.inventoryitem.canbepickedup and ent.components.inventoryitem.cangoincontainer and ent and (not itemExists(ent.prefab)) or nil
            end
    
            local Item = FindEntity(inst, SEARCH_RADIUS, IsItem,{"_inventoryitem"} , {"INLIMBO", "NOCLICK", "catchable", "fire", "trap", "minesprung", "mineactive"})
            
            if Item then
                if not inst.components.container:IsFull() then
                    local pos = Item:GetPosition() 
                    local shadowpuff = SpawnPrefab("shadow_puff_large_front")
                    shadowpuff.Transform:SetPosition(pos.x, 0, pos.z)
                    shadowpuff.Transform:SetScale(0.7, 0.7, 0.7)
                    SpawnPrefab("shadow_despawn").Transform:SetPosition(pos.x, 1, pos.z)
    
                    suckit(Item)
    
                    inst:DoTaskInTime(0, function(inst)
                        SpawnPrefab("pandorachest_reset").Transform:SetPosition(inst.Transform:GetWorldPosition())
                    end)
                    return
                elseif Item.components.stackable then
                    local stack = inst.components.container:FindItem(function(i) return (i.prefab == Item.prefab and not i.components.stackable:IsFull()) end)
                
                    if stack then
                        suckit(Item)
                        local pos = Item:GetPosition() 
                        local shadowpuff = SpawnPrefab("shadow_puff_large_front")
                        shadowpuff.Transform:SetPosition(pos.x, 0, pos.z)
                        shadowpuff.Transform:SetScale(0.7, 0.7, 0.7)			
                
                        SpawnPrefab("shadow_despawn").Transform:SetPosition(pos.x, 1, pos.z)
        
                        suckit(Item)
        
                        inst:DoTaskInTime(0, function(inst)
                            SpawnPrefab("pandorachest_reset").Transform:SetPosition(inst.Transform:GetWorldPosition())
                        end)
                        return
                    end
                end
            end
        end

        inst:DoPeriodicTask(VACUUM_PERIOD, vacuum)

        -- Gin vacuum_chest

		-- Save / load is extended by some prefab variants
        inst.OnSave = onsave
        inst.OnLoad = onload

        if master_postinit ~= nil then
            master_postinit(inst)
        end

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

--------------------------------------------------------------------------
--[[ pandora ]]
--------------------------------------------------------------------------

local pandora_scrapbook_adddeps = {
    "armorwood",
    "footballhat",
    "spear",
    "nightmarefuel",
    "redgem",
    "bluegem",
    "purplegem",
    "thulecite_pieces",
    "thulecite",
    "yellowgem",
    "orangegem",
    "greengem",
    "batbat",
    "firestaff",
    "icestaff",
    "multitool_axe_pickaxe",
    "spider_dropper",
}

local function pandora_master_postinit(inst)
    inst.scrapbook_adddeps = pandora_scrapbook_adddeps

    inst:ListenForEvent("resetruins", function()
        local was_open = inst.components.container:IsOpen()

        if inst.components.scenariorunner == nil then
            inst.components.container:Close()
            inst.components.container:DropEverythingWithTag("irreplaceable")
            inst.components.container:DestroyContents()

            inst:AddComponent("scenariorunner")
            inst.components.scenariorunner:SetScript("chest_labyrinth")
            inst.components.scenariorunner:Run()
        end

        if not inst:IsAsleep() then
            if not was_open then
                inst.AnimState:PlayAnimation("hit")
                inst.AnimState:PushAnimation("closed", false)
                inst.SoundEmitter:PlaySound("dontstarve/common/together/chest_retrap")
            end

            SpawnPrefab("pandorachest_reset").Transform:SetPosition(inst.Transform:GetWorldPosition())
        end
    end, TheWorld)
end

--------------------------------------------------------------------------
--[[ minotaur ]]
--------------------------------------------------------------------------

local minotaur_scrapbook_adddeps = {
    "atrium_key",
    "armorruins",
    "ruinshat",
    "ruins_bat",
    "orangestaff",
    "yellowstaff",
    "orangeamulet",
    "yellowamulet",
    "yellowgem",
    "orangegem",
    "greengem",
    "thulecite",
    "thulecite_pieces",
    "gears",
}

local function minotuar_master_postinit(inst)
    inst.scrapbook_adddeps = minotaur_scrapbook_adddeps

    inst:ListenForEvent("resetruins", function()
        inst.components.container:Close()
        inst.components.container:DropEverything()

        if not inst:IsAsleep() then
            local fx = SpawnPrefab("collapse_small")
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx:SetMaterial("wood")
        end

        inst:Remove()
    end, TheWorld)
end


--------------------------------------------------------------------------
--[[ Terrarium ]]
--------------------------------------------------------------------------

local function terrarium_GetStatus(inst)
    return inst.fx ~= nil and "SHIMMER" 
			or inst:HasTag("burnt") and "BURNT"
			or nil
end

local function terrarium_removefx(inst)
	if inst.fx ~= nil then
		inst.fx:Remove()
		inst.fx = nil
		inst:RemoveEventCallback("onburnt", terrarium_removefx)
		inst:RemoveEventCallback("onopen", terrarium_removefx)
		inst.SoundEmitter:KillSound("shimmer")
	end
end

local terrarium_scrapbook_adddeps = {
    "terrarium",
    "spear",
    "blowdart_pipe",
    "boomerang",
    "fireflies",
    "razor",
    "grass_umbrella",
    "papyrus",
    "gunpowder",
    "cutstone",
    "marble",
    "rope",
    "healingsalve",
    "torch",
    "messagebottleempty",
    "goldnugget",
    "log",
}

local function terrarium_master_postinit(inst)
    inst.scrapbook_adddeps = terrarium_scrapbook_adddeps
    inst.components.inspectable.getstatus = terrarium_GetStatus

	if TUNING.SPAWN_EYEOFTERROR then
		inst:DoTaskInTime(0, function(i)
			if i.components.scenariorunner ~= nil then
				i.fx = SpawnPrefab("terrariumchest_fx")
				i.fx.entity:SetParent(i.entity)

				i:ListenForEvent("onburnt", terrarium_removefx)
				i:ListenForEvent("onopen", terrarium_removefx)

				inst.SoundEmitter:PlaySound("terraria1/terrarium/shimmer_chest_lp", "shimmer")
			end
		end)
	end
end

local function terrariumchest_fx_fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst:AddTag("FX")

	inst.AnimState:SetBuild("terrariumchest_fx")
	inst.AnimState:SetBank("terrariumchest_fx")
	inst.AnimState:PlayAnimation("idle_back", true)
	inst.AnimState:SetFinalOffset(1)
	

	if not TheNet:IsDedicated() then
		local fx_front = CreateEntity()
		fx_front.entity:AddTransform()
		fx_front.entity:AddAnimState()
		fx_front.entity:SetParent(inst.entity)

		fx_front:AddTag("FX")
		fx_front:AddTag("CLASSIFIED")

		fx_front.AnimState:SetBuild("terrariumchest_fx")
		fx_front.AnimState:SetBank("terrariumchest_fx")
		fx_front.AnimState:PlayAnimation("idle_front", true)
		fx_front.AnimState:SetFinalOffset(-3)
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.persists = false

	return inst
end

--------------------------------------------------------------------------
--[[ sunken ]]
--------------------------------------------------------------------------

local function sunken_onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        if inst.components.container ~= nil then
            inst.components.container:Close()
        end
    end
end

local function sunken_OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function sunken_OnEquip(inst, owner)
    if inst.components.container ~= nil then
		inst.components.container:Close()
	end
    owner.AnimState:OverrideSymbol("swap_body", "swap_sunken_treasurechest", "swap_body")
end

local function sunken_OnSubmerge(inst)
	if inst.components.container ~= nil then
		inst.components.container:Close()
	end
end

local function sunken_GetStatus(inst)
    return (inst.components.container ~= nil and not inst.components.container.canbeopened) and "LOCKED" or nil
end

local function sunken_common_postinit(inst)
	inst:AddTag("heavy")

	MakeHeavyObstaclePhysics(inst, SUNKEN_PHYSICS_RADIUS)
	inst:SetPhysicsRadiusOverride(SUNKEN_PHYSICS_RADIUS)
end

local sunken_scrapbook_adddeps = require("messagebottletreasures").GetPrefabs()

local function sunken_master_postinit(inst)
    inst.scrapbook_adddeps = sunken_scrapbook_adddeps
    inst.components.workable:SetOnWorkCallback(sunken_onhit)

    inst.components.inspectable.getstatus = sunken_GetStatus

	inst:AddComponent("heavyobstaclephysics")
	inst.components.heavyobstaclephysics:SetRadius(SUNKEN_PHYSICS_RADIUS)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(sunken_OnEquip)
    inst.components.equippable:SetOnUnequip(sunken_OnUnequip)
    inst.components.equippable.walkspeedmult = TUNING.HEAVY_SPEED_MULT

    inst.components.container.canbeopened = false

	inst:AddComponent("submersible")
	inst:AddComponent("symbolswapdata")
    inst.components.symbolswapdata:SetData("swap_sunken_treasurechest", "swap_body")

	inst:ListenForEvent("on_submerge", sunken_OnSubmerge)
end

return MakeChest("treasurechest", "chest", "treasure_chest", false, nil, { "collapse_small" }),
    MakePlacer("treasurechest_placer", "chest", "treasure_chest", "closed"),
    MakeChest("pandoraschest", "pandoras_chest", "pandoras_chest", true, pandora_master_postinit, { "pandorachest_reset" }),
    MakeChest("minotaurchest", "pandoras_chest_large", "pandoras_chest_large", true, minotuar_master_postinit, { "collapse_small" }),
    MakeChest("terrariumchest", "chest", "treasurechest_terrarium", false, terrarium_master_postinit, { "collapse_small", "terrariumchest_fx" }, { Asset("ANIM", "anim/treasurechest_terrarium.zip") }),
	Prefab("terrariumchest_fx", terrariumchest_fx_fn, { Asset("ANIM", "anim/terrariumchest_fx.zip") }, { "collapse_small" }),
	MakeChest("sunkenchest", "sunken_treasurechest", "sunken_treasurechest", false, sunken_master_postinit, { "collapse_small", "underwater_salvageable", "splash_green" }, { Asset("ANIM", "anim/swap_sunken_treasurechest.zip") }, sunken_common_postinit, true)
