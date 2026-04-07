local PANEL = {}

local BG_COLOR = Color(36, 41, 67, 255)

function PANEL:Init()
    self:SetTall(150)
    self:Dock(TOP)
    self:DockPadding(5, 5, 5, 5)

    self.header = vgui.Create("DLabel", self)
    self.header:SetTall(50)
    self.header:Dock(TOP)
    self.header:DockMargin(25, 50, 25, 0)
    self.header:SetText("CFC Servers")
    self.header:SetFont("DUCK_FONT_HEADER")

    self.subheader = vgui.Create("DLabel", self)
    self.subheader:SetTall(16)
    self.subheader:Dock(TOP)
    self.subheader:DockMargin(25, 0, 25, 0)
    self.subheader:SetText(GetHostName())
    self.subheader:SetFont("DUCK_FONT_SUBHEADER")
    --self.subheader:SetFont("FONT_HEADER")
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(8, 0, 0, w, h, BG_COLOR, true, true)
end

vgui.Register("duckboard_server_info", PANEL)