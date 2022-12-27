function sekadmin.FindByName(nick)
    local players = {}
    for k,v in pairs(player.GetAll()) do
        if string.find(string.upper(v:Name()),string.upper(nick))!=nil then
            table.Add(players,{v})
        end
    end
    return players[1]
end

function sekadmin.ChatCheck(tbl,admin,ply,self)
    local newtbl = {}
    for k,v in pairs(tbl) do
        if type(v)=="string" then
            if string.find(v,"#A") then
                if IsValid(admin) then
                    if admin:IsPlayer() then
                        if admin==self then
                            table.Add(newtbl,{sekadmin.config["youcolor"],"You",sekadmin.config["chatcolor"]})
                        else
                            print(admin)
                            table.Add(newtbl,{sekadmin.config["chatcolor"],admin:Name(),"(",admin:SteamID(),")"})
                        end
                    else
                        table.Add(newtbl,{sekadmin.config["chatcolor"],"(CONSOLE)"})
                    end
                else
                    table.Add(newtbl,{sekadmin.config["chatcolor"],"(CONSOLE)"})
                end
            elseif string.find(v,"#P") then
                if ply==self then
                    table.Add(newtbl,{sekadmin.config["youcolor"],"You",sekadmin.config["chatcolor"]})
                else
                    table.Add(newtbl,{sekadmin.config["chatcolor"],ply:Name(),"(",ply:SteamID(),")"})
                end
            else
                table.Add(newtbl,{v})
            end
        else
            table.Add(newtbl,{v})
        end
    end
    return newtbl
end

function sekadmin.ExplodeCommand(str) -- thanks KlΞn_list 🎀 ~ >,.,<#7589 for help
    local len = #str
    if len > 100 then return end
    local args = {}
    local mult = false
    local word = ""
    for i = 1, len do
        local c = str:sub(i,i)
        if c == '"' then mult = not mult continue end
        if c == ' ' and not mult then args[#args+1] = word word = "" continue end
        word = word .. c 
    end
    args[#args+1] = word
    return args
end