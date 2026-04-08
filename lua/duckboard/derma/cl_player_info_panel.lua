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
    self.plyName:SetText("Disconnected...")
    self.plyName:SetTextColor(TEXT_COLOR)
    self.plyName:SetFont("DUCK_FONT_NORMAL")

    local legends = 0
    for _, v in pairs(Duckboard.Config.Legend) do
        if v then
            legends = legends + 1
        end
    end

    self.extrasGrid = vgui.Create("DGrid", self.mainDiv)
    self.extrasGrid:SetWide(legends * 100)
    self.extrasGrid:Dock(RIGHT)
    self.extrasGrid:DockMargin(0, 0, 0, 0)
    self.extrasGrid:SetCols(legends)
    self.extrasGrid:SetColWide(100)
    self.extrasGrid:SetContentAlignment(6)

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

    if Duckboard.Config.Legend.showKillDeaths then
        local kdDiv = vgui.Create("DGrid")
        kdDiv:SetCols(2)
        kdDiv:SetColWide(50)
        kdDiv:SetTall(t)
        kdDiv:SetWide(100)
        kdDiv.Paint = function() end
        self.extrasGrid:AddItem(kdDiv)

        local kills = vgui.Create("DLabel", kdDiv)
        kills:SetTall(t)
        kills:SetWide(50)
        kills:SetText("10")
        kills:SetTextColor(TEXT_COLOR)
        kills:SetFont("DUCK_FONT_NORMAL")
        kills:SetContentAlignment(5)
        kills.Think = function()
            kills:SetText(self:GetPlayer():Frags())
        end
        kdDiv:AddItem(kills)

        local deaths = vgui.Create("DLabel", kdDiv)
        deaths:SetTall(t)
        deaths:SetWide(50)
        deaths:SetText("0")
        deaths:SetTextColor(TEXT_COLOR)
        deaths:SetFont("DUCK_FONT_NORMAL")
        deaths:SetContentAlignment(5)
        deaths.Think = function()
            deaths:SetText(self:GetPlayer():Deaths())
        end
        kdDiv:AddItem(deaths)
    end

    if Duckboard.Config.Legend.showTotalTime then
        local totalLabel = vgui.Create("DLabel")
        totalLabel:SetTall(t)
        totalLabel:SetWide(100)
        totalLabel:SetText("100h")
        totalLabel:SetTextColor(TEXT_COLOR)
        totalLabel:SetFont("DUCK_FONT_NORMAL")
        totalLabel:SetContentAlignment(5)

        self.extrasGrid:AddItem(totalLabel)
    end

    if Duckboard.Config.Legend.showSessionTime then
        local sessionLabel = vgui.Create("DLabel")
        sessionLabel:SetTall(t)
        sessionLabel:SetWide(100)
        sessionLabel:SetText("SESSION")
        sessionLabel:SetTextColor(TEXT_COLOR)
        sessionLabel:SetFont("DUCK_FONT_NORMAL")
        sessionLabel:SetContentAlignment(5)
        sessionLabel.Think = function()
            local tStart = self:GetPlayerSessionTime()
            local tCur = CurTime()
            sessionLabel:SetText(formatTime(tCur - tStart))
        end

        self.extrasGrid:AddItem(sessionLabel)
    end

    if Duckboard.Config.Legend.showRank then
        local rankLabel = vgui.Create("DLabel")
        rankLabel:SetTall(t)
        rankLabel:SetWide(100)
        rankLabel:SetText("Owner")
        rankLabel:SetTextColor(Color(255, 0, 0))
        rankLabel:SetFont("DUCK_FONT_NORMAL")
        rankLabel:SetContentAlignment(5)
        self.extrasGrid:AddItem(rankLabel)
    end

    if Duckboard.Config.Legend.showPing then
        local pingLabel = vgui.Create("DLabel")
        pingLabel:SetTall(t)
        pingLabel:SetWide(100)
        pingLabel:SetText("999")
        pingLabel:SetTextColor(Color(0, 255, 0))
        pingLabel:SetFont("DUCK_FONT_NORMAL")
        pingLabel:SetContentAlignment(5)
        pingLabel.Think = function()
            pingLabel:SetText(self:GetPlayer():Ping())
        end

        self.extrasGrid:AddItem(pingLabel)
    end

    self.buttonProfile = vgui.Create("DButton", self.mainDiv)
    self.buttonProfile:SetSize(25, 25)
    self.buttonProfile:SetText("")
    self.buttonProfile.Paint = function() end
    self.buttonProfile.DoClick = function()
        gui.OpenURL("http://steamcommunity.com/profiles/" .. self:GetPlayer():SteamID64())
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
        self.controlPanel:SetPlayer(self:GetPlayer())
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

function PANEL:SetPlayer(ply)
    self.player = ply
    self.sessionStart = Duckboard.SessionTimes[self.player:SteamID()] or 0
    self:SetAvatar(ply)
    self:SetName(ply)
end

function PANEL:SetAvatar(ply)
    self.avatar:SetPlayer(ply)
end

function PANEL:SetName(ply)
    self.plyName:SetText(ply:GetName())
end

function PANEL:GetPlayerSessionTime()
    return self.sessionStart
end

function PANEL:GetPlayer()
    return self.player or LocalPlayer()
end

vgui.Register("duckboard_player_info", PANEL, "DPanel")