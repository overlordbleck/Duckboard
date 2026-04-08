Duckboard = Duckboard or {}
Duckboard.Config = Duckboard.Config or {}

local PANEL = {}

function PANEL:Init()
    self.badges = {}
    self:Center()
end

function PANEL:AddBadge(badgeid)
    if IsValid(self.badges[badgeid]) then return end

    local y = self:GetParent():GetTall()
    local m = 5

    self.badges[badgeid] = vgui.Create("DImage", self)
    self.badges[badgeid]:SetImage(Duckboard.Config.Badges[badgeid].icon)
    self.badges[badgeid]:SetWide(y - m*2)
    self.badges[badgeid]:Dock(LEFT)
    self.badges[badgeid]:DockMargin(1, m, 1, m)
    self.badges[badgeid]:InvalidateParent(true)

    self:SizeToChildren(true, false)
    self:Center()
end

function PANEL:RemoveBadge(badgeid)
    if not IsValid(self.badges[badgeid]) then return end

    self.badges[badgeid]:Remove()

    self:SizeToChildren(true, false)
    self:Center()
end

function PANEL:Paint()
end

function PANEL:SetPlayer(ply)
    self.player = ply
end

function PANEL:GetPlayer()
    return self.player or LocalPlayer()
end

vgui.Register("duckboard_badge_panel", PANEL, "DPanel")
