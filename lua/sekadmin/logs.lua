if SERVER then
    util.AddNetworkString("sek.logall")
    util.AddNetworkString("sek.logimpall")
end

function sekadmin.Log(tbl)
    if SERVER then
        table.Add(tbl,{"\n"})
        MsgC(unpack(tbl))
    else
        chat.AddText(unpack(tbl))
    end
end
if SERVER then
    function sekadmin.LogPly(ply,tbl)
        net.Start("sek.logall")
            net.WriteTable(tbl)
        net.Send(ply)
    end

    function sekadmin.LogAll(tbl)
        net.Start("sek.logall")
            net.WriteTable(tbl)
        net.Broadcast()

        table.Add(tbl,{"\n"})
        MsgC(tbl)
    end

    function sekadmin.LogAllImproved(tbl,admin,target)
        net.Start("sek.logimpall")
            net.WriteTable(tbl)
            net.WriteEntity(admin)
            net.WriteEntity(target)
        net.Broadcast()

        tbl = sekadmin.ChatCheck(tbl,admin,target,nil)
        table.Add(tbl,{"\n"})
        MsgC(unpack(tbl))
    end
end

if CLIENT then
    net.Receive("sek.logall",function()
        local tbl = net.ReadTable()
        chat.AddText(unpack(tbl))
    end)

    net.Receive("sek.logimpall",function()
        local tbl = net.ReadTable()
        local admin = net.ReadEntity()
        local ply = net.ReadEntity()
        tbl = sekadmin.ChatCheck(tbl,admin,ply,LocalPlayer())
        chat.AddText(unpack(tbl))
    end)
end