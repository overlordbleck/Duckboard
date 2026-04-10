
local BG_COLOR = Color(32, 36, 60, 255)
local DIV_COLOR = Color(57,62,85)

local PANEL = {}
local t = 125

function PANEL:Init()
    self:SetTall(t)
    self:Dock(TOP)

    self.avatarDiv = vgui.Create("DPanel", self)
    self.avatarDiv:Dock(LEFT)
    self.avatarDiv:DockPadding(10, 10, 10, 10)
    self.avatarDiv:SetWide(125)
    self.avatarDiv.Paint = function() end

    self.avatar = vgui.Create("AvatarImage", self.avatarDiv)
    self.avatar:Dock(FILL)
    function self.avatar:PaintOver(w, h)
        surface.SetDrawColor(DIV_COLOR)
        surface.DrawOutlinedRect(0, 0, w, h, 2)
    end

    self.copyPanel = vgui.Create("DPanel", self)
    self.copyPanel:Dock(LEFT)
    self.copyPanel:DockPadding(10, 10, 10, 10)
    self.copyPanel:SetWide(125)
    self.copyPanel.Paint = function() end

    local nButtons = 4
    local bSize = t / 3 - nButtons * 3 - 5

    self.profileButton = vgui.Create("DButton", self.copyPanel)
    self.profileButton:Dock(TOP)
    self.profileButton:DockMargin(0, 0, 0, 3)
    self.profileButton:SetTall(bSize)
    self.profileButton:SetText("Visit Profile")
    self.profileButton.DoClick = function()
        gui.OpenURL("http://steamcommunity.com/profiles/" .. self.steamid64)
    end 

    self.nameCopy = vgui.Create("DButton", self.copyPanel)
    self.nameCopy:Dock(TOP)
    self.nameCopy:DockMargin(0, 0, 0, 3)
    self.nameCopy:SetTall(bSize)
    self.nameCopy:SetText("Copy Name")
    self.nameCopy.DoClick = function()
        SetClipboardText(self.name)
    end 

    self.sidCopy = vgui.Create("DButton", self.copyPanel)
    self.sidCopy:Dock(TOP)
    self.sidCopy:DockMargin(0, 0, 0, 3)
    self.sidCopy:SetTall(bSize)
    self.sidCopy:SetText("Copy SteamID32")
    self.sidCopy.DoClick = function()
        SetClipboardText(self.steamid)
    end 

    self.sid64Copy = vgui.Create("DButton", self.copyPanel)
    self.sid64Copy:Dock(TOP)
    self.sid64Copy:DockMargin(0, 0, 0, 3)
    self.sid64Copy:SetTall(bSize)
    self.sid64Copy:SetText("Copy SteamID64")
    self.sid64Copy.DoClick = function()
        SetClipboardText(self.steamid64)
    end 
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(8, 0, 0, w, h, BG_COLOR, false, false, true, true)
end

-- function PANEL:SetConnectingPlayer(name, sid)
--     self._name = name
--     self._steamid = sid
--     self._steamid64 = util.SteamIDTo64(sid)
--     self:SetAvatar(self._steamid64)
-- end

function PANEL:SetPlayer(ply, name, sid)
    self.player = ply
    self.name = name
    self.steamid = sid
    self.steamid64 = util.SteamIDTo64(sid)
    self:SetAvatar(self.steamid64)
end

function PANEL:SetAvatar(sid)
    self.avatar:SetSteamID(sid, 128)
end

function PANEL:GetPlayer()
    return self.player
end

vgui.Register("duckboard_player_control", PANEL, "DPanel")
