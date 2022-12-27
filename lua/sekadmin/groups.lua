if SERVER then

    if !sql.TableExists("sekadmin_groups") then
        local tried = sql.Query("CREATE TABLE sekadmin_groups(pos INTEGER PRIMARY KEY AUTOINCREMENT, name varchar(255));")
        if tried then MsgC(Color(55,255,55),"[SUCCESSFULLY] Created groups table!","\n") else MsgC(Color(255,55,55),"[FAILED] Groups table create failed by error: ",sql.LastError(),"\n") end
    end
    if !sql.TableExists("sekadmin_permissions") then
        local tried = sql.Query("CREATE TABLE sekadmin_permissions(groupname varchar(255), permname varchar(300));")
        if tried then MsgC(Color(55,255,55),"[SUCCESSFULLY] Created permissions table!","\n") else MsgC(Color(255,55,55),"[FAILED] Permissions table create failed by error: ",sql.LastError(),"\n") end
    end

    function sekadmin.ExistsGroup(name)
        local result = false
        local exists = sql.Query('SELECT * FROM sekadmin_groups WHERE name = ' .. sql.SQLStr(name) .. '')
        if exists!=nil then 
            result = true 
        end
        return result
    end

    function sekadmin.CreateGroup(pos,name)
        local exists = sql.Query('SELECT * FROM sekadmin_groups WHERE name = ' .. sql.SQLStr(name) .. '') 
        if exists==nil then 
            if pos==nil then
                sql.Query('INSERT INTO sekadmin_groups(name) VALUES(' .. sql.SQLStr(name) .. ');') 
            else
                sql.Query('INSERT INTO sekadmin_groups(pos,name) VALUES(' .. sql.SQLStr(pos) .. ',' .. sql.SQLStr(name) .. ');') 
            end
        end
    end

    function sekadmin.GiveGroup(ply)
        if !IsValid(ply) then return end
        local exists = sql.Query("SELECT * FROM sekadmin_players WHERE steamid64 = " .. sql.SQLStr(ply:SteamID64()))
        if exists!=nil then 
            local group = sql.Query("SELECT groupname FROM sekadmin_players WHERE steamid64 = " .. sql.SQLStr(ply:SteamID64()))[1]["groupname"]
            local exists1 = sql.Query('SELECT * FROM sekadmin_groups WHERE name = ' .. sql.SQLStr(group) .. '') 
            if exists1!=nil then 
                ply:SetUserGroup(group)
            end
        end
    end

    function sekadmin.SetGroup(steamid64,group)
        local exists = sql.Query("SELECT * FROM sekadmin_players WHERE steamid64 = " .. sql.SQLStr(steamid64))
        if exists!=nil then 
            local exists1 = sql.Query('SELECT * FROM sekadmin_groups WHERE name = ' .. sql.SQLStr(group) .. '') 
            if exists1!=nil then 
                sql.Query("UPDATE sekadmin_players SET groupname = " .. sql.SQLStr(group) .. " WHERE steamid64 = " .. sql.SQLStr(steamid64) .. ";")
            end
        end
    end

    function sekadmin.RenameGroup(name,newname)
        if name=="user" then return end
        local exists = sql.Query('SELECT * FROM sekadmin_groups WHERE name = ' .. sql.SQLStr(name) .. '') 
        if exists!=nil then 
            sql.Query('UPDATE sekadmin_groups SET name = ' .. sql.SQLStr(newname) .. ' WHERE name = ' .. sql.SQLStr(name) .. ';') 
        end
    end

    function sekadmin.DeleteGroup(name)
        if name=="user" then return end
        local exists = sql.Query('SELECT * FROM sekadmin_groups WHERE name = ' .. sql.SQLStr(name) .. '') 
        if exists!=nil then 
            sql.Query('DELETE FROM sekadmin_groups WHERE name = ' .. sql.SQLStr(name) .. ';') 
        end
    end

    function sekadmin.ExistsPermission(name,perm)
        local result = false
        local exists = sql.Query('SELECT * FROM sekadmin_permissions WHERE groupname = ' .. sql.SQLStr(name) .. ' AND permname = ' .. sql.SQLStr(perm) .. '')
        if exists!=nil then 
            result = true 
        end
        return result
    end

    function sekadmin.AddPermission(name,perm)
        local exists = sql.Query('SELECT * FROM sekadmin_permissions WHERE groupname = ' .. sql.SQLStr(name) .. ' AND permname = ' .. sql.SQLStr(perm) .. '')
        if exists==nil then 
            sql.Query('INSERT INTO sekadmin_permissions(groupname,permname) VALUES(' .. sql.SQLStr(name) .. ',' .. sql.SQLStr(perm) .. ');') 
        end
    end

    function sekadmin.RemPermission(name,perm)
        local exists = sql.Query('SELECT * FROM sekadmin_permissions WHERE groupname = ' .. sql.SQLStr(name) .. ' AND permname = ' .. sql.SQLStr(perm) .. '')
        if exists!=nil then 
            sql.Query('DELETE FROM sekadmin_permissions WHERE groupname = ' .. sql.SQLStr(name) .. ' AND permname = ' .. sql.SQLStr(perm) .. ';') 
        end
    end

    function sekadmin.ResetDefaultGroups()
        local exists = sekadmin.ExistsGroup("user")
        if !exists then sekadmin.CreateGroup(_,"user") end

        local exists = sekadmin.ExistsGroup("moderator")
        if !exists then sekadmin.CreateGroup(_,"moderator")
            sekadmin.AddPermission("moderator","sa.kick") sekadmin.AddPermission("moderator","sa.noclip")
        end

        local exists = sekadmin.ExistsGroup("admin")
        if !exists then sekadmin.CreateGroup(_,"admin")
            sekadmin.AddPermission("admin","sa.ban") sekadmin.AddPermission("admin","sa.kick")
            sekadmin.AddPermission("admin","sa.noclip")
        end

        local exists = sekadmin.ExistsGroup("root")
        if !exists then sekadmin.CreateGroup(_,"root") sekadmin.AddPermission("root","*") end
    end

    if !sekadmin.ExistsGroup("user") then
        sekadmin.ResetDefaultGroups()
    end

end