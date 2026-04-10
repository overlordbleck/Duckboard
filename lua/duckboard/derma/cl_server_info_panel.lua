local PANEL = {}

local BG_COLOR = Color(36, 41, 67, 255)

function PANEL:Init()
    self:SetTall(150)
    self:Dock(TOP)
    self:DockPadding(5, 5, 5, 5)

    self.head = vgui.Create("DPanel", self)
    self.head:Dock(LEFT)
    self.head:SetWide(400)
    self.head.Paint = function() end

    self.header = vgui.Create("DLabel", self.head)
    self.header:SetTall(50)
    self.header:Dock(TOP)
    self.header:DockMargin(25, 50, 25, 0)
    self.header:SetText("CFC Servers")
    self.header:SetFont("DUCK_FONT_HEADER")

    self.subheader = vgui.Create("DLabel", self.head)
    self.subheader:SetTall(16)
    self.subheader:Dock(TOP)
    self.subheader:DockMargin(25, 0, 25, 0)
    self.subheader:SetText(GetHostName())
    self.subheader:SetFont("DUCK_FONT_SUBHEADER")
    --self.subheader:SetFont("FONT_HEADER")

    self.getInvolved = vgui.Create("DPanel", self)
    self.getInvolved:SetTall(30)
    self.getInvolved:Dock(TOP)
    self.getInvolved.Paint = function() end

    self._GI = vgui.Create("DPanel", self.getInvolved)
    --self._GI.Paint = function() end

    self.discord = vgui.Create("DImageButton", self._GI)
    self.discord:SetSize(30,30)
    self.discord:Dock(LEFT)
    self.discord:DockMargin(2, 0, 0, 0)
    self.discord:SetImage("icon16/cog_edit.png")

    self.workshop = vgui.Create("DImageButton", self._GI)
    self.workshop:SetSize(30,30)
    self.workshop:Dock(LEFT)
    self.workshop:DockMargin(2, 0, 0, 0)
    self.workshop:SetImage("icon16/cog_edit.png")

    self.support = vgui.Create("DImageButton", self._GI)
    self.support:SetSize(30,30)
    self.support:Dock(LEFT)
    self.support:DockMargin(2, 0, 0, 0)
    self.support:SetImage("icon16/cog_edit.png")

    self.feedback = vgui.Create("DImageButton", self._GI)
    self.feedback:SetSize(30,30)
    self.feedback:Dock(LEFT)
    self.feedback:DockMargin(2, 0, 0, 0)
    self.feedback:SetImage("icon16/cog_edit.png")

    self._GI:InvalidateLayout(true)
    self._GI:SizeToChildren(true, true)
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(8, 0, 0, w, h, BG_COLOR, true, true)
end

vgui.Register("duckboard_server_info", PANEL)