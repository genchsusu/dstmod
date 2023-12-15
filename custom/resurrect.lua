local _G = GLOBAL
local TheNet = _G.TheNet
if not (TheNet and TheNet:GetIsServer()) then return end

local welcome_tips_time = 30
local resurrect_from = "Gin"
local MY_STRINGS_EN = {
    welcome_msg = "\nEnter #resurrect after press Y(Say) or U(Whisper):\nYou will get a new life.",
    resurrect = "#resurrect",
}

local MY_STRINGS_CN = {
    welcome_msg = "\n按Y(说话)或U(密语)输入: #复活 \n你将获得新的生命。",
    resurrect = "#复活",
}

local function GetCurrentStrings()
    local lang = TheNet:GetLanguageCode()
    if lang == "schinese" or lang == "tchinese" then
        return MY_STRINGS_CN
    else
        return MY_STRINGS_EN
    end
end

local CURRENT_STRINGS = GetCurrentStrings()

-- 获取玩家对象
local function GetPlayerById(playerid)
    for _, v in ipairs(_G.AllPlayers) do
        if v ~= nil and v.userid and v.userid == playerid then
            return v
        end
    end
    return nil
end

-- 玩家是否死亡
local function IsDied(player)
    return player and player:HasTag("playerghost")
end

-- 处理复活命令
local function HandleResurrectCommand(player)
    if player and player:IsValid() and IsDied(player) then
        _G.ExecuteConsoleCommand('local player = UserToPlayer("'..player.userid..'") player:PushEvent("respawnfromghost")')
        player.rezsource = resurrect_from
        player.components.health:SetCurrentHealth(player.components.health.maxhealth)
        if player.components.sanity then
            player.components.sanity:SetPercent(1)
        end
        if player.components.hunger then
            player.components.hunger:SetPercent(1)
        end
    end
end

-- 玩家加入事件处理
AddComponentPostInit("playerspawner", function(OnPlayerSpawn, inst)
    inst:ListenForEvent("ms_playerjoined", function(self, player)
        if player and player.components then
            local welcome_tips = CURRENT_STRINGS.welcome_msg
            player:DoTaskInTime(3, function(target)
                if target.components.talker then
                    target.components.talker:Say(target:GetDisplayName() .. ", " .. welcome_tips, welcome_tips_time)
                end
            end)
        end
    end)
end)

-- 重写聊天处理函数
local Old_Networking_Say = _G.Networking_Say
_G.Networking_Say = function(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    Old_Networking_Say(guid, userid, name, prefab, message, colour, whisper, isemote, ...)
    if string.lower(message) == CURRENT_STRINGS.resurrect then
        local player = GetPlayerById(userid)
        if player then
            HandleResurrectCommand(player)
        end
    end
end