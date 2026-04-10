Duckboard = Duckboard or {}
Duckboard.Config = Duckboard.Config or {}
Duckboard.SessionTimes = Duckboard.SessionTimes or {}
Duckboard.Panel = Duckboard.Panel or {}

local hasOpened = false

surface.CreateFont("DUCK_FONT_HEADER", {
    font = "Arial",
    size = 50,
    weight = 800,
})

surface.CreateFont("DUCK_FONT_SUBHEADER", {
    font = "Arial",
    size = 18,
    weight = 500,
})

surface.CreateFont("DUCK_FONT_LEGEND", {
    font = "Arial",
    size = 13,
    weight = 800,
})

surface.CreateFont("DUCK_FONT_NORMAL", {
    font = "Arial",
    size = 14,
    weight = 500,
})

gameevent.Listen("player_connect")
hook.Add("player_connect", "duckboard_ply_start_connect", function(data)
    local name = data.name
    local sid = data.networkid

    if not hasOpened then return end
    Duckboard:CreatePlayerInfo(name, sid)
    Duckboard:GivePlayerBadge(sid, "connecting")
end)

gameevent.Listen("player_changename")
hook.Add("player_changename", "duckboard_change_name_listen", function()
    hook.Run("Duckboard_Force_Refresh")

    if not hasOpened then return end
    Duckboard:ValidateAllPlayerCards()
end)

net.Receive("duckboard_ply_connect", function()
    local ply = net.ReadEntity()
    local sid = net.ReadString()
    local time = net.ReadFloat()

    Duckboard.SessionTimes[sid] = time
    hook.Run("Duckboard_Force_Refresh", sid) -- TODO: need?
    
    if not hasOpened then return end
    Duckboard:ValidatePlayerCard(ply)
    Duckboard:RemovePlayerBadge(sid, "connecting")
end)

net.Receive("duckboard_ply_disconnect", function()
    local sid = net.ReadString()

    Duckboard.SessionTimes[sid] = nil
    hook.Run("Duckboard_Force_Refresh", sid)

    if not hasOpened then return end
    if not Duckboard.Config.showDisconnected then
        Duckboard:RemovePlayerInfo(sid)
    else
        Duckboard:RemoveAllBadges(sid)
        Duckboard:GivePlayerBadge(sid, "disconnected")
        Duckboard:SetDisconnected(sid)
    end
    --Duckboard:RemovePlayerInfo(sid)
end)

local function BuildScoreboard()
    Duckboard.Panel = vgui.Create("duckboard_panel")
    Duckboard.Panel:PopulateScoreboard()
end

function Duckboard:CreatePlayerInfo(name, sid)
    self.Panel:CreatePlayerCard(name, sid)
    self:ValidateAllPlayerCards()
end

function Duckboard:RemovePlayerInfo(sid)
    self.Panel:RemovePlayerCard(sid)
    self:ValidateAllPlayerCards()
end

function Duckboard:ValidatePlayerCard(ply)
    self.Panel:ValidatePlayerCard(ply)
end

function Duckboard:ValidateAllPlayerCards()
    self.Panel:PopulateScoreboard()
end

function Duckboard:SetDisconnected(sid)
    self.Panel:SetDisconnected(sid)
end

-- TODO: Networking Badges/Disconnected players
function Duckboard:GivePlayerBadge(sid, badgeid)
    self.Panel:AddBadge(sid, badgeid)
end

function Duckboard:RemovePlayerBadge(sid, badgeid)
    self.Panel:RemoveBadge(sid, badgeid)
end

function Duckboard:RemoveAllBadges(sid)
    for k, v in pairs(self.Config.Badges) do
        self:RemovePlayerBadge(sid, k)
    end
end

hook.Add("Duckboard_Force_Refresh", "Duckboard_Config_Modify", function()
    if not hasOpened then return end
    Duckboard.Panel:RefreshLayout()
end)

function Duckboard:openScoreboard()
    if not IsValid(Duckboard.Panel) then BuildScoreboard() end
    hook.Run("Duckboard_Force_Refresh")
    hasOpened = true
    
    Duckboard.Panel:SetVisible(true)

    if Duckboard.Config.mouseOnOpen then
        Duckboard.Panel:EnableInteraction()
    end

    return true
end
hook.Add("ScoreboardShow", "duckboard_scoreboardshow", Duckboard.openScoreboard)

function Duckboard:closeScoreboard()
    if IsValid(Duckboard.Panel) then
        --Duckboard.Panel:SetVisible(false)
        if IsValid(Duckboard.Panel.settingsButton.popup) then
            Duckboard.Panel.settingsButton.Show = false
            Duckboard.Panel.settingsButton.popup:Remove()
        end
        Duckboard.Panel:Close()
    end
end
hook.Add("ScoreboardHide", "duckboard_scoreboardhide", Duckboard.closeScoreboard)


