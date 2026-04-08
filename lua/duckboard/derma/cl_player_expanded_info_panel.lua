
local BG_COLOR = Color(32, 36, 60, 255)
local DIV_COLOR = Color(57,62,85)

local PANEL = {}

function PANEL:Init()
    self:SetTall(125)
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
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(10, 0, 0, w, h, BG_COLOR, false, false, true, true)
end

function PANEL:SetPlayer(ply)
    self.player = ply
    self.avatar:SetPlayer(ply, 128)
end

function PANEL:GetPlayer()
    return self.player
end

vgui.Register("duckboard_player_control", PANEL, "DPanel")
