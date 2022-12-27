
sekadmin = {}

--include part
if SERVER then 
    include("sekadmin/init.lua")
    AddCSLuaFile("sekadmin/cl_init.lua")
    AddCSLuaFile("sekadmin/shared.lua")
else 
    include("sekadmin/cl_init.lua") 
end