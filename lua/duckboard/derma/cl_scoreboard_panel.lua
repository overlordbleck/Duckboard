Duckboard.Config = Duckboard.Config or {}

local PANEL = {}

local BG_COLOR = Color(57, 62, 85, 255)
local LEGEND_COLOR = Color(32, 36, 60, 255)
local TEXT_COLOR = Color(255, 255, 255)
local DIV_COLOR = Color(57,62,85)
local FOOTER_COLOR = Color(36, 41, 67)
local LEGEND_HEIGHT = 30
local heightPadding = 200

local function getUptime()
    local t = CurTime()

    local hours = math.floor(t / 3600)
    local mins = math.floor((t % 3600) / 60)
    local secs = math.floor(t % 60)

    return string.format("%01dh %01dm %01ds", hours, mins, secs)
end

function PANEL:Init()
    self.visible = false
    self:SetTitle("")
    self:SetDraggable(false)
    self:ShowCloseButton(false)
    self:SetSize(768, ScrH() - heightPadding)
    self:Center()
    --self:DockPadding(5, 5, 5, 5)
    self:DockPadding(0, 0, 0, 0)
    self:SetDeleteOnClose(false)

    self.ServerInfo = vgui.Create("duckboard_server_info", self)

    hook.Add("Duckboard_Force_Refresh", "duckboard_refresh_legendinfo", function()
        if IsValid(self.playerLegend) then self.playerLegend:Remove() end
        self.playerLegend = vgui.Create("DPanel", self)
        self.playerLegend:SetTall(LEGEND_HEIGHT)
        self.playerLegend:Dock(TOP)

        function self.playerLegend:Paint(w, h)
            surface.SetDrawColor(LEGEND_COLOR)
            surface.DrawRect(0, 0, w, h)

            surface.SetDrawColor(DIV_COLOR)
            surface.DrawLine(0, 0, w, 0)

            surface.SetDrawColor(DIV_COLOR)
            surface.DrawLine(0, 1, w, 1)
        end

        local plyLabel = vgui.Create("DLabel", self.playerLegend)
        plyLabel:SetWide(235)
        plyLabel:Dock(LEFT)
        plyLabel:DockMargin(25, 0, 0, 0)
        plyLabel:SetText("PLAYER")
        plyLabel:SetTextColor(TEXT_COLOR)
        plyLabel:SetFont("DUCK_FONT_LEGEND")

        local legends = 0
        for _, v in pairs(Duckboard.Config.Legend) do
            if v then
                legends = legends + 1
            end
        end

        self.extrasGrid = vgui.Create("DGrid", self.playerLegend)
        self.extrasGrid:SetWide(legends * 100)
        self.extrasGrid:Dock(RIGHT)
        self.extrasGrid:DockMargin(5, 0, 0, 0)
        self.extrasGrid:SetCols(legends)
        self.extrasGrid:SetColWide(100)
        self.extrasGrid:SetContentAlignment(6)

        if Duckboard.Config.Legend.showBadges then
            local badges = vgui.Create("DLabel")
            badges:SetTall(LEGEND_HEIGHT)
            badges:SetWide(100)
            badges:SetText("BADGES")
            badges:SetTextColor(TEXT_COLOR)
            badges:SetFont("DUCK_FONT_LEGEND")
            badges:SetContentAlignment(5)
            self.extrasGrid:AddItem(badges)
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
            kills:SetTall(LEGEND_HEIGHT)
            kills:SetWide(50)
            kills:SetText("KILLS")
            kills:SetTextColor(TEXT_COLOR)
            kills:SetFont("DUCK_FONT_LEGEND")
            kills:SetContentAlignment(5)
            kdDiv:AddItem(kills)

            local deaths = vgui.Create("DLabel", kdDiv)
            deaths:SetTall(LEGEND_HEIGHT)
            deaths:SetWide(50)
            deaths:SetText("DEATHS")
            deaths:SetTextColor(TEXT_COLOR)
            deaths:SetFont("DUCK_FONT_LEGEND")
            deaths:SetContentAlignment(5)
            kdDiv:AddItem(deaths)
        end

        if Duckboard.Config.Legend.showTotalTime then
            local totalLabel = vgui.Create("DLabel", self.playerLegend)
            totalLabel:SetTall(LEGEND_HEIGHT)
            totalLabel:SetWide(100)
            totalLabel:SetText("TOTAL PLAYTIME")
            totalLabel:SetTextColor(TEXT_COLOR)
            totalLabel:SetFont("DUCK_FONT_LEGEND")
            totalLabel:SetContentAlignment(5)
            self.extrasGrid:AddItem(totalLabel)
        end

        if Duckboard.Config.Legend.showSessionTime then
            local sessionLabel = vgui.Create("DLabel", self.playerLegend)
            sessionLabel:SetTall(LEGEND_HEIGHT)
            sessionLabel:SetWide(100)
            sessionLabel:SetText("SESSION")
            sessionLabel:SetTextColor(TEXT_COLOR)
            sessionLabel:SetFont("DUCK_FONT_LEGEND")
            sessionLabel:SetContentAlignment(5)
            self.extrasGrid:AddItem(sessionLabel)
        end

        if Duckboard.Config.Legend.showRank then
            local rankLabel = vgui.Create("DLabel", self.playerLegend)
            rankLabel:SetTall(LEGEND_HEIGHT)
            rankLabel:SetWide(100)
            rankLabel:SetText("RANK")
            rankLabel:SetTextColor(TEXT_COLOR)
            rankLabel:SetFont("DUCK_FONT_LEGEND")
            rankLabel:SetContentAlignment(5)
            self.extrasGrid:AddItem(rankLabel)
        end

        if Duckboard.Config.Legend.showPing then
            local pingLabel = vgui.Create("DLabel", self.playerLegend)
            pingLabel:SetTall(LEGEND_HEIGHT)
            pingLabel:SetWide(100)
            pingLabel:SetText("PING")
            pingLabel:SetTextColor(TEXT_COLOR)
            pingLabel:SetFont("DUCK_FONT_LEGEND")
            pingLabel:SetContentAlignment(5)
            self.extrasGrid:AddItem(pingLabel)
        end
    end)

    self.playerDiv = vgui.Create("DScrollPanel", self)
    self.playerDiv:Dock(FILL)
    self.playerDiv.Paint = function() end
    self.playerDiv.divs = {}

    self.ender = vgui.Create("DPanel", self)
    self.ender:SetTall(25)
    self.ender:Dock(BOTTOM)
    self.ender:DockPadding(5, 5, 5, 5)

    function self.ender:Paint(w, h)
        draw.RoundedBox(4, 0, 0, w, h, FOOTER_COLOR)
    end

    self.mapDisplay = vgui.Create("DLabel", self.ender)
    self.mapDisplay:SetWide(200)
    self.mapDisplay:Dock(LEFT)
    self.mapDisplay:SetText("Map: " .. game.GetMap())
    self.mapDisplay:SetTextColor(TEXT_COLOR)
    self.mapDisplay:SetFont("DUCK_FONT_NORMAL")

    self.uptime = vgui.Create("DLabel", self.ender)
    self.uptime:SetWide(200)
    self.uptime:Dock(LEFT)
    self.uptime:SetTextColor(TEXT_COLOR)
    self.uptime:SetFont("DUCK_FONT_NORMAL")

    function self.uptime:Think()
        self:SetText("Uptime: " .. getUptime())
    end

    self.settingsButton = vgui.Create("DImageButton", self.ender)
    self.settingsButton:SetImage("icon16/cog_edit.png")
    self.settingsButton:SetWide(self.ender:GetTall() - 10)
    self.settingsButton:Dock(RIGHT)
    self.settingsButton:SetText("")
    self.settingsButton.Show = false
    self.settingsButton.DoClick = function()
        self.settingsButton.Show = not self.settingsButton.Show

        if not self.settingsButton.Show then 
            if IsValid(self.settingsButton.popup) then
                self.settingsButton.popup:Remove()
            end

            return
        end

        local px, py = self:GetPos()
        local sx, sy = self:GetSize()
        self.settingsButton.popup = vgui.Create("duckboard_settings_panel")
        self.settingsButton.popup:SetPos(px + sx, py + sy - 300)
    end
end

-- ---
-- When a player connects:
-- 1. Create a card
-- 2. When player initializes link that card to that player
-- 3. Refresh 
-- ---
function PANEL:CreatePlayerCard(name, sid)
    local pc = vgui.Create("duckboard_player_info")
    pc:SetConnectingPlayer(name, sid)

    self.playerDiv:AddItem(pc)
    self.playerDiv.divs[sid] = pc
end

function PANEL:RemovePlayerCard(sid)
    if IsValid(self.playerDiv.divs[sid]) then
        self.playerDiv.divs[sid]:Remove()
    end
    self.playerDiv.divs[sid] = nil
end

function PANEL:ValidatePlayerCard(ply)
    local name = ply:Name()
    local sid = ply:SteamID()
    if not IsValid(self.playerDiv.divs[sid]) then
        self:CreatePlayerCard(name, sid)
    end
    self.playerDiv.divs[sid]:SetPlayer(ply)
end

function PANEL:PopulateScoreboard()
    for _, ply in pairs(player.GetAll()) do
        self:ValidatePlayerCard(ply)
    end
end

function PANEL:RefreshPlayerCards()
    for k, v in pairs(self.playerDiv.divs) do
        v:Refresh()
    end
end

function PANEL:SetDisconnected(sid)
    self.playerDiv.divs[sid]:SetDisconnected()
end

function PANEL:AddBadge(sid, badgeid)
    self.playerDiv.divs[sid]:AddBadge(badgeid)
end

function PANEL:RemoveBadge(sid, badgeid)
    self.playerDiv.divs[sid]:RemoveBadge(badgeid)
end

function PANEL:Paint(w, h)
    draw.RoundedBox(8, 0, 0, w, h, BG_COLOR)
end

function PANEL:EnableInteraction()
    --self:SetPopupStayAtBack(true)
    self:MakePopup()
    self:SetKeyboardInputEnabled(false)
    self:SetSize(768, ScrH() - heightPadding)
    self:Center()
end

function PANEL:DisableInteraction()
    --self:SetMouseInputEnabled(false)
end

vgui.Register("duckboard_panel", PANEL, "DFrame")
