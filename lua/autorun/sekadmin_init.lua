
sekadmin = {}

--include part
if SERVER then 
    include("sekadmin/init.lua")
    AddCSLuaFile("sekadmin/cl_init.lua")
    AddCSLuaFile("sekadmin/shared.lua")
else 
    include("sekadmin/cl_init.lua") 
end

local function loadvgui()
    if SERVER then
        AddCSLuaFile("sekadmin/vgui.lua")
        AddCSLuaFile("sekadmin/vgui/spanel.lua")
        AddCSLuaFile("sekadmin/vgui/sbutton.lua")
    else
        include("sekadmin/vgui.lua")
    end
end

loadvgui()