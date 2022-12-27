sekadmin.commands = {}

if SERVER then 
    util.AddNetworkString("sek.command") 
    net.Receive("sek.command",function(_,ply)
        local command = net.ReadString()
        local args = net.ReadTable()
        
        local id = sekadmin.ExistsCommand(command)
        if id!=false then
            local permexist = sekadmin.ExistsPermission(ply:GetUserGroup(),sekadmin.commands[id]["permission"])
            local ipermexist = sekadmin.ExistsPermission(ply:GetUserGroup(),"*")
            local func = sekadmin.commands[id]["func"]
            if ipermexist or permexist then
                func(ply,args)
            else
                sekadmin.LogPly(ply,{sekadmin.config["chatcolor"],"You not have permission to this command!"})
            end
        end
    end)

    concommand.Add("sek",function(ply,cmd,_,args)
        local args = sekadmin.ExplodeCommand(args)
        local id = sekadmin.ExistsCommand(args[1])
        if id!=false then
            table.remove(args,1)
            if table.Count(args)==0 and sekadmin.commands[id]["needargs"]==true then
                sekadmin.Log({sekadmin.config["chatcolor"],"sek  ",sekadmin.commands[id]["command"]," - ",sekadmin.commands[id]["description"],". Example: ",sekadmin.commands[id]["example"]})
            else
                local func = sekadmin.commands[id]["func"]
                func(nil,args)
            end
        else
            sekadmin.Log({sekadmin.config["chatcolor"],"Command not found!"})
        end
    end)
end

if CLIENT then
    concommand.Add("sek",function(ply,cmd,_,args)
        local args = sekadmin.ExplodeCommand(args)
        local id = sekadmin.ExistsCommand(args[1])
        if id!=false then
            table.remove(args,1)
            if table.Count(args)==0 and sekadmin.commands[id]["needargs"]==true then
                sekadmin.Log({sekadmin.config["chatcolor"],"!",sekadmin.commands[id]["command"]," - ",sekadmin.commands[id]["description"],". Example: ",sekadmin.commands[id]["example"]})
            else
                local func = sekadmin.commands[id]["func"]
                if IsValid(ply) then
                    if sekadmin.commands[id]["local"]==true then
                        func(ply,args)
                        print(1)
                    else
                        net.Start("sek.command")
                            net.WriteString(sekadmin.commands[id]["command"])
                            if args==nil then args={} end
                            net.WriteTable(args)
                        net.SendToServer()
                    end
                end
            end
        else
            sekadmin.Log({sekadmin.config["chatcolor"],"Command not found!"})
        end
    end)
end

function sekadmin.CreateCommand(perm,comm,category,desc,example,needargs,locals,func)
    table.Add(sekadmin.commands,{{
        ["permission"] = perm, -- Permission of this command
        ["command"] = comm, -- Name command
        ["category"] = category, -- Category of this command
        ["description"] = desc, -- Description of this command
        ["example"] = example, -- Example of using this command
        ["needargs"] = needargs, -- Need to this command args?
        ["local"] = locals, -- Need to this command NETwork executing function?
        ["func"] = func
    }})
end

function sekadmin.ExistsCommand(cmd)
    local result = false
    local id = nil
    for k,v in pairs(sekadmin.commands) do
        if v["command"]==cmd then
            result=true id=k
        end
    end
    return id or result
end


/*
    ---> THERE DEFAULT COMMANDS
*/


sekadmin.CreateCommand("sa.help","help","Util","Shows all commands","sek help",false,true,function(_,args)
    if args[1]==nil then
        for k,v in pairs(sekadmin.commands) do
            sekadmin.Log({sekadmin.config["chatcolor"],"[",v["category"],"] ","!",v["command"]," - ",v["description"],". Example: ",v["example"]})
        end
    else
        local id = sekadmin.ExistsCommand(args[1])
        if id==false then
            sekadmin.Log({sekadmin.config["chatcolor"],"Help - Command not found!"})
        else
            sekadmin.Log({sekadmin.config["chatcolor"],"[",sekadmin.commands[id]["category"],"] ","!",sekadmin.commands[id]["command"]," - ",sekadmin.commands[id]["description"],". Example: ",sekadmin.commands[id]["example"]})
        end
    end
end)

sekadmin.CreateCommand("sa.noclip","noclip","Util","Enable/Disable noclip","sek noclip player1",false,false,function(ply,args)
    if args[1]==nil and ply!=nil then
        if ply:GetMoveType()==MOVETYPE_NOCLIP then
            ply:SetMoveType(MOVETYPE_WALK)
            sekadmin.LogAllImproved({sekadmin.config["chatcolor"],"#A"," Take noclip to the player ","#P","."},ply,ply)
        else
            ply:SetMoveType(MOVETYPE_NOCLIP)
            sekadmin.LogAllImproved({sekadmin.config["chatcolor"],"#A"," Give noclip to the player ","#P","."},ply,ply)
        end
    else
        if args[1]==nil then
            if ply==nil then
                sekadmin.Log({sekadmin.config["chatcolor"],"Argument player is empty!"})
            else
                sekadmin.LogPly(ply,{sekadmin.config["chatcolor"],"Argument player is empty!"})
            end
        else
            local target = sekadmin.FindByName(args[1])
            if target then
                if target:GetMoveType()==MOVETYPE_NOCLIP then
                    target:SetMoveType(MOVETYPE_WALK)
                    sekadmin.LogAllImproved({sekadmin.config["chatcolor"],"#A"," Take noclip to the player ","#P","."},ply,target)
                else
                    target:SetMoveType(MOVETYPE_NOCLIP)
                    sekadmin.LogAllImproved({sekadmin.config["chatcolor"],"#A"," Give noclip to the player ","#P","."},ply,target)
                end
            else
                if ply==nil then
                    sekadmin.Log({sekadmin.config["chatcolor"],"Player not found!"})
                else
                    sekadmin.LogPly(ply,{sekadmin.config["chatcolor"],"Player not found!"})
                end
            end
        end
    end
end)

sekadmin.CreateCommand("sa.teleport","tp","Teleport","Teleport player to admin aim position","sek tp player1",false,false,function(ply,args)
    if args[1]==nil and ply!=nil then
        ply:SetPos(ply:GetEyeTrace().HitPos)
    elseif args[1]!=nil and ply!=nil then
        local target = sekadmin.FindByName(args[1])
        if target then
            target:SetPos(ply:GetEyeTrace().HitPos)
        else
            sekadmin.LogPly(ply,{sekadmin.config["chatcolor"],"Player not found!"})
        end
    end
end)

sekadmin.CreateCommand("sa.adduser","adduser","Users","Sets group to player","sek setgroup player1 groupname",true,false,function(ply,args)
    if args[1]==nil then
        
    elseif args[1]!=nil then
        if args[2]!=nil then
            if sekadmin.ExistsGroup(args[2]) then
                local target = sekadmin.FindByName(args[1])
                if target then
                    sekadmin.SetGroup(target:SteamID64(),args[2])
                    sekadmin.GiveGroup(target)
                    sekadmin.LogAllImproved({sekadmin.config["chatcolor"],"#A"," Set group ",sekadmin.config["argcolor"],args[2],sekadmin.config["chatcolor"]," to the player ","#P","."},ply,target)
                else
                    if ply==nil then
                        sekadmin.Log({sekadmin.config["chatcolor"],"Player not found!"})
                    else
                        sekadmin.LogPly(ply,{sekadmin.config["chatcolor"],"Player not found!"})
                    end
                end
            else
                if ply==nil then
                    sekadmin.Log({sekadmin.config["chatcolor"],"Group is not exist!"})
                else
                    sekadmin.LogPly(ply,{sekadmin.config["chatcolor"],"Group is not exist!"})
                end
            end
        else
            if ply==nil then
                sekadmin.Log({sekadmin.config["chatcolor"],"Group argument is empty!"})
            else
                sekadmin.LogPly(ply,{sekadmin.config["chatcolor"],"Group argument is empty!"})
            end
        end
    end
end)

/*
    ---> THERE CUSTOM COMMANDSsekadmin.SetGroup(steamid64,group)
*/


/* example of command creating
sekadmin.CreateCommand("permission.name, example: sa.ban","name of command, example: ban","help of command, example: Ban the player","example of command using, example: sek ban player1 10m Breaking a lot of rules ",function(args)
    there command function
end)
*/