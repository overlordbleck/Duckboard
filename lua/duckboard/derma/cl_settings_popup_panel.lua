Duckboard = Duckboard or {}
Duckboard.Config = Duckboard.Config or {}
Duckboard.Config.Legend = Duckboard.Config.Legend or {}

local TEXT_COLOR = Color(255, 255, 255)
local BG_COLOR = Color(0, 0, 0, 200)

local PANEL = {}

function PANEL:Init()
    self:SetSize(200, 300)
    self:MoveToFront()

    self.Label = vgui.Create("DLabel", self)
    self.Label:SetTall(20)
    self.Label:Dock(TOP)
    self.Label:DockMargin(5, 5, 5, 5)
    self.Label:SetText("Settings:")
    self.Label:SetTextColor(TEXT_COLOR)

    self.lLabel = vgui.Create("DLabel", self)
    self.lLabel:SetTall(20)
    self.lLabel:Dock(TOP)
    self.lLabel:DockMargin(5, 0, 5, 0)
    self.lLabel:SetText("Legend")
    self.lLabel:SetTextColor(TEXT_COLOR)

    for k, v in pairs(Duckboard.Config.Legend) do
        self.div = vgui.Create("DPanel", self)
        self.div:SetTall(20)
        self.div:Dock(TOP)
        self.div:DockMargin(5, 0, 5, 0)
        self.div.Paint = function() end

        local check = vgui.Create("DCheckBoxLabel", self.div)
        check:Dock(FILL)
        check:SetText(k)
        check:SetTextColor(TEXT_COLOR)
        check:SetChecked(v)

        function check:OnChange(bool)
            Duckboard.Config.Legend[k] = bool
            hook.Run("Duckboard_Force_Refresh")
        end
    end
end

function PANEL:Paint(w, h)
    --surface.SetDrawColor(BG_COLOR)
    --surface.DrawRect(0, 0, w, h)
    draw.RoundedBox(4, 0, 0, w, h, BG_COLOR)
end

vgui.Register("duckboard_settings_panel", PANEL, "DPanel")
