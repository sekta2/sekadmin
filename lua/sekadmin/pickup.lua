hook.Add("PhysgunPickup","sek.pickup.phys",function(ply,ent)
    if (sekadmin.ExistsPermission(ply:GetUserGroup(),"*") or sekadmin.ExistsPermission(ply:GetUserGroup(),"sa.physgunplayers")) and ent:IsPlayer() then
        ent:SetMoveType(MOVETYPE_NONE)
        return true
    end
end)

hook.Add("PhysgunDrop","sek.pickup.phys",function(ply,ent)
    if (sekadmin.ExistsPermission(ply:GetUserGroup(),"*") or sekadmin.ExistsPermission(ply:GetUserGroup(),"sa.physgunplayers")) and ent:IsPlayer() then
        ent:SetMoveType(MOVETYPE_WALK)
    end
end)