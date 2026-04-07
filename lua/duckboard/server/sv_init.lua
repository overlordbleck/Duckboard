Duckboard = Duckboard or {}
Duckboard.SessionTimes = Duckboard.SessionTimes or {}

util.AddNetworkString("duckboard_ply_connect")
util.AddNetworkString("duckboard_ply_diconnect")

local function sendSessionStartData(sid, time)
    net.Start("duckboard_ply_connect")
        net.WriteString(sid)
        net.WriteFloat(time)
    net.Broadcast()
end

local function sendSessionEndData(sid)
    net.Start("duckboard_ply_disconnect")
        net.WriteString(sid)
    net.Broadcast()
end

hook.Add("PlayerInitialSpawn", "duckboard_init_spawn", function(ply)
    local sid = ply:SteamID()
    local time = CurTime()
    Duckboard.SessionTimes[sid] = time

    sendSessionStartData(sid, time)
end)

hook.Add("PlayerDisconnected", "duckboard_disconnect", function(ply)
    local sid = ply:SteamID()
    table.remove(Duckboard.SessionTimes, sid)

    sendSessionEndData(sid)
end)
