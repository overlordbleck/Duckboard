Duckboard = Duckboard or {}
Duckboard.Config = Duckboard.Config or {}
Duckboard.SessionTimes = Duckboard.SessionTimes or {}
Duckboard.Panel = Duckboard.Panel or {}

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

gameevent.Listen("player_changename")
hook.Add("player_changename", "duckboard_change_name_listen", function()
    hook.Run("Duckboard_Force_Refresh")
end)

net.Receive("duckboard_ply_connect", function()
    local sid = net.ReadString()
    local time = net.ReadFloat()

    print("STARTING " .. sid .. " " .. time)
    Duckboard.SessionTimes[sid] = time
    hook.Run("Duckboard_Force_Refresh")
    PrintTable(Duckboard.SessionTimes)
end)

net.Receive("duckboard_ply_disconnect", function()
    local sid = net.ReadString()

    table.remove(Duckboard.SessionTimes, sid)
    hook.Run("Duckboard_Force_Refresh")
end)

local function BuildScoreboard()
    Duckboard.Panel = vgui.Create("duckboard_panel")
end

function Duckboard:openScoreboard()
    if not IsValid(Duckboard.Panel) then BuildScoreboard() end
    hook.Run("Duckboard_Force_Refresh")
    
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


