Duckboard = Duckboard or {}
Duckboard.Config = Duckboard.Config or {}
Duckboard.Config.Legend = Duckboard.Config.Legend or {}

Duckboard.Config.mouseOnOpen = true -- Enables interaction upon opening the scoreboard 
Duckboard.Config.nameRanks = true
Duckboard.Config.showPerformanceGraph = false
Duckboard.Config.showTotalTimeFormatted = false
Duckboard.Config.showRecentlyDisconnected = true
Duckboard.Config.showConnecting = true
Duckboard.Config.showDisconnected = true
Duckboard.Config.collapseInfoUponOpening = true

Duckboard.Config.Legend.showKillDeaths = true
Duckboard.Config.Legend.showBadges = true
Duckboard.Config.Legend.showSessionTime = false
Duckboard.Config.Legend.showTotalTime = true
Duckboard.Config.Legend.showRank = true
Duckboard.Config.Legend.showPing = true

Duckboard.Config.Badges = {
    admin = {
        icon = "icon16/shield.png",
        hoverText = "Admin"
    },
    afk = {
        icon = "icon16/clock_red.png",
        hoverText = "AFK"
    },
    pvp = {
        icon = "icon16/bomb.png",
        hoverText = "PvPing"
    },
    connecting = {
        icon = "icon16/transmit_go.png",
        hoverText = "Connecting"
    },
    disconnected = {
        icon = "icon16/transmit_delete.png",
        hoverText = "Connecting"
    }

}
