Duckboard = Duckboard or {}
Duckboard.Config = Duckboard.Config or {}
Duckboard.SessionTimes = Duckboard.SessionTimes or {}

local player = LocalPlayer()
local BG_COLOR = Color(36, 41, 67, 255)
local TEXT_COLOR = Color(255, 255, 255)

local function formatTime(t)
    local hours = math.floor(t / 3600)
    local mins = math.floor((t % 3600) / 60)
    local secs = math.floor(t % 60)

    return string.format("%01dh %01dm %01ds", hours, mins, secs)
end

local PANEL = {}

function PANEL:Init()
    self.connecting = true
    self.disconnected = false

    self:SetTall(25)
    self:Dock(TOP)
    self:DockMargin(0, 2, 0, 0)
    self.Expanded = false

    self.mainDiv = vgui.Create("DPanel", self)
    self.mainDiv:SetTall(25)
    self.mainDiv:Dock(TOP)
    self.mainDiv.Paint = function() end

    local t = self:GetTall()
    local w = self:GetWide()

    self.avatar = vgui.Create("AvatarImage", self.mainDiv)
    self.avatar:SetWide(t)
    self.avatar:Dock(LEFT)
    --self.avatar:SetPlayer(LocalPlayer())

    self.nameDiv = vgui.Create("DPanel", self.mainDiv)
    self.nameDiv:SetWide(235)
    self.nameDiv:Dock(LEFT)
    self.nameDiv:DockMargin(5, 0, 0, 0)
    self.nameDiv.Paint = function() end

    self.plyName = vgui.Create("DLabel", self.nameDiv)
    self.plyName:Dock(FILL)
    self.plyName:SetText("Connecting...")
    self.plyName:SetTextColor(TEXT_COLOR)
    self.plyName:SetFont("DUCK_FONT_NORMAL")

    self.extrasGrid = vgui.Create("DGrid", self.mainDiv)
    

    self:LegendUpdate()

    self.buttonProfile = vgui.Create("DButton", self.mainDiv)
    self.buttonProfile:SetSize(25, 25)
    self.buttonProfile:SetText("")
    self.buttonProfile.Paint = function() end
    self.buttonProfile.DoClick = function()
        gui.OpenURL("http://steamcommunity.com/profiles/" .. self._steamid64)
    end 

    self.button = vgui.Create("DButton", self.mainDiv)
    self.button:SetSize(768, self.mainDiv:GetTall())
    self.button:SetPos(25, 0)
    self.button:SetText("")
    self.button.Paint = function() end
    self.button.DoClick = function()
        self.expanded = not self.expanded
        if self.expanded then
            self:Expand()
        else
            self:Depress()
        end
    end  
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(BG_COLOR)
    surface.DrawRect(0, 0, w, h)
end

function PANEL:Expand()
    if not IsValid(self.controlPanel) then
        self.controlPanel = vgui.Create("duckboard_player_control", self)
        self.controlPanel:SetPlayer(self.player, self.name, self.steamid)
    end

    self.controlPanel:Show()
    self:SetTall(150)
end

function PANEL:Depress()
    if IsValid(self.controlPanel) then
        self.controlPanel:Hide()
    end

    self:SetTall(25)
end

function PANEL:SetConnected()
    self.connected = false
end

function PANEL:SetDisconnected()
    self.disconnected = true
    self.plyName:SetTextColor(Color(255,0,0))
    self.plyName:SetText(self.name .. " (DISCONNECTED)")

    if IsValid(self.pingLabel) then self.pingLabel:SetText("") end
    if IsValid(self.rankLabel) then self.rankLabel:SetText("") end
    if IsValid(self.sessionLabel) then self.sessionLabel:SetText("") end
    if IsValid(self.totalLabel) then self.totalLabel:SetText("") end
    if IsValid(self.deaths) then self.deaths:SetText("") end
    if IsValid(self.kills) then self.kills:SetText("") end
end

function PANEL:SetConnectingPlayer(name, sid)
    self._name = name
    self._steamid = sid
    self._steamid64 = util.SteamIDTo64(sid)

    self:SetName(self._name)
    self:SetAvatar(self._steamid64)
    --self:AddBadge("", "connecting")
end

function PANEL:SetPlayer(ply)
    self.player = ply
    self.name = ply:Name()
    self.steamid = ply:SteamID()
    self.steamid64 = ply:SteamID64()
    self.sessionStart = Duckboard.SessionTimes[self.player:SteamID()] or 0

    self:SetName(self.name)
    self:SetAvatar(self.steamid64)
end

function PANEL:AddBadge(badgeid)
    self.badgesDiv.badgePanel:AddBadge(badgeid)
end

function PANEL:RemoveBadge(badgeid)
    self.badgesDiv.badgePanel:RemoveBadge(badgeid)
end

function PANEL:SetAvatar(sid)
    self.avatar:SetSteamID(sid, 64)
end

function PANEL:SetName(name)
    self.plyName:SetText(name)
end

function PANEL:GetPlayerSessionTime()
    return self.sessionStart
end

function PANEL:GetPlayer()
    return self.player or LocalPlayer()
end

function PANEL:LegendUpdate()
    local legends = 0
    for _, v in pairs(Duckboard.Config.Legend) do
        if v then
            legends = legends + 1
        end
    end

    self.extrasGrid:SetWide(legends * 100)
    self.extrasGrid:Dock(RIGHT)
    self.extrasGrid:DockMargin(0, 0, 0, 0)
    self.extrasGrid:SetCols(legends)
    self.extrasGrid:SetColWide(100)
    self.extrasGrid:SetContentAlignment(6)

    local t = self:GetTall()
    
    if IsValid(self.badgesDiv) then self.badgesDiv:Remove() end
    if Duckboard.Config.Legend.showBadges then
        self.badgesDiv = vgui.Create("DPanel")
        self.badgesDiv:SetTall(t)
        self.badgesDiv:SetWide(100)
        self.badgesDiv:SetContentAlignment(5)
        self.badgesDiv.Paint = function() end
        self.extrasGrid:AddItem(self.badgesDiv)

        self.badgesDiv.badgePanel = vgui.Create("duckboard_badge_panel", self.badgesDiv)
        self.badgesDiv.badgePanel:SetTall(t)
        self.badgesDiv.badgePanel:AddBadge("admin")
        self.badgesDiv.badgePanel:AddBadge("pvp")
    end

    if IsValid(self.kdDiv) then self.kdDiv:Remove() end
    if Duckboard.Config.Legend.showKillDeaths then
        self.kdDiv = vgui.Create("DGrid")
        self.kdDiv:SetCols(2)
        self.kdDiv:SetColWide(50)
        self.kdDiv:SetTall(t)
        self.kdDiv:SetWide(100)
        self.kdDiv.Paint = function() end
        self.extrasGrid:AddItem(self.kdDiv)

        self.kills = vgui.Create("DLabel", self.kdDiv)
        self.kills:SetTall(t)
        self.kills:SetWide(50)
        self.kills:SetText("")
        self.kills:SetTextColor(TEXT_COLOR)
        self.kills:SetFont("DUCK_FONT_NORMAL")
        self.kills:SetContentAlignment(5)
        self.kills.Think = function()
            local p = self:GetPlayer()
            if not IsValid(p) then return end
            self.kills:SetText(p:Frags())
        end
        self.kdDiv:AddItem(self.kills)

        self.deaths = vgui.Create("DLabel", self.kdDiv)
        self.deaths:SetTall(t)
        self.deaths:SetWide(50)
        self.deaths:SetText("")
        self.deaths:SetTextColor(TEXT_COLOR)
        self.deaths:SetFont("DUCK_FONT_NORMAL")
        self.deaths:SetContentAlignment(5)
        self.deaths.Think = function()
            local p = self:GetPlayer()
            if not IsValid(p) then return end
            self.deaths:SetText(p:Deaths())
        end
        self.kdDiv:AddItem(self.deaths)
    end

    if IsValid(self.totalLabel) then self.totalLabel:Remove() end
    if Duckboard.Config.Legend.showTotalTime then
        self.totalLabel = vgui.Create("DLabel")
        self.totalLabel:SetTall(t)
        self.totalLabel:SetWide(100)
        self.totalLabel:SetText("100h")
        self.totalLabel:SetTextColor(TEXT_COLOR)
        self.totalLabel:SetFont("DUCK_FONT_NORMAL")
        self.totalLabel:SetContentAlignment(5)

        self.extrasGrid:AddItem(self.totalLabel)
    end

    if IsValid(self.sessionLabel) then self.sessionLabel:Remove() end
    if Duckboard.Config.Legend.showSessionTime then
        self.sessionLabel = vgui.Create("DLabel")
        self.sessionLabel:SetTall(t)
        self.sessionLabel:SetWide(100)
        self.sessionLabel:SetText("SESSION")
        self.sessionLabel:SetTextColor(TEXT_COLOR)
        self.sessionLabel:SetFont("DUCK_FONT_NORMAL")
        self.sessionLabel:SetContentAlignment(5)
        self.sessionLabel.Think = function()
            local tStart = self:GetPlayerSessionTime()
            local tCur = CurTime()
            self.sessionLabel:SetText(formatTime(tCur - tStart))
        end

        self.extrasGrid:AddItem(self.sessionLabel)
    end

    if IsValid(self.rankLabel) then self.rankLabel:Remove() end
    if Duckboard.Config.Legend.showRank then
        self.rankLabel = vgui.Create("DLabel")
        self.rankLabel:SetTall(t)
        self.rankLabel:SetWide(100)
        self.rankLabel:SetText("Owner")
        self.rankLabel:SetTextColor(Color(255, 0, 0))
        self.rankLabel:SetFont("DUCK_FONT_NORMAL")
        self.rankLabel:SetContentAlignment(5)
        self.extrasGrid:AddItem(self.rankLabel)
    end

    if IsValid(self.pingLabel) then self.pingLabel:Remove() end
    if Duckboard.Config.Legend.showPing then
        self.pingLabel = vgui.Create("DLabel")
        self.pingLabel:SetTall(t)
        self.pingLabel:SetWide(100)
        self.pingLabel:SetText("")
        self.pingLabel:SetTextColor(Color(0, 255, 0))
        self.pingLabel:SetFont("DUCK_FONT_NORMAL")
        self.pingLabel:SetContentAlignment(5)
        self.pingLabel.Think = function()
            local p = self:GetPlayer()
            if not IsValid(p) then return end
            self.pingLabel:SetText(p:Ping())
        end

        self.extrasGrid:AddItem(self.pingLabel)
    end
end

vgui.Register("duckboard_player_info", PANEL, "DPanel")
