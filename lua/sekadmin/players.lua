if SERVER then

    if !sql.TableExists("sekadmin_players") then
        local tried = sql.Query('CREATE TABLE sekadmin_players(name varchar(255), steamid varchar(255), steamid64 varchar(255), groupname varchar(255) DEFAULT "user", firstjoin INTEGER, lastjoin INTEGER);')
        print(tried)
        if tried then MsgC(Color(55,255,55),"[SUCCESSFULLY] Created players table!","\n") else MsgC(Color(255,55,55),"[FAILED] Players table create failed by error: ",sql.LastError(),"\n") end
    end

    hook.Add("PlayerInitialSpawn","sek.initply",function(ply,_)
        local steamid = ply:SteamID()
        local steamid64 = ply:SteamID64()
        local name = ply:Name()


        local exists = sql.Query("SELECT * FROM sekadmin_players WHERE steamid64 = " .. sql.SQLStr(steamid64))
        if exists==nil then
            local firstjoin = os.time()
            local lastjoin = os.time()
            sql.Query("INSERT INTO sekadmin_players(name,steamid,steamid64,firstjoin,lastjoin) VALUES(" .. sql.SQLStr(name) .. "," .. sql.SQLStr(steamid) .. "," .. sql.SQLStr(steamid64) .. "," .. sql.SQLStr(firstjoin) .. "," .. sql.SQLStr(lastjoin) .. ")")
        else
            sekadmin.GiveGroup(ply)
        end
    end)

end