Duckboard = Duckboard or {}
Duckboard.SessionTimes = Duckboard.SessionTimes or {}

util.AddNetworkString("duckboard_ply_connect")
util.AddNetworkString("duckboard_ply_disconnect")


local function sendSessionStartData(ply, sid, time)
    print("TEST")
    net.Start("duckboard_ply_connect")
        net.WriteEntity(ply)
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

    timer.Simple(1, function()
        sendSessionStartData(ply, sid, time)
    end)
end)

hook.Add("PlayerDisconnected", "duckboard_disconnect", function(ply)
    local sid = ply:SteamID()
    Duckboard.SessionTimes[sid] = nil

    sendSessionEndData(sid)
end)
