local PANEL = {}

function PANEL:Init()

end

function PANEL:Paint(w,h)
    draw.RoundedBox(3,0,0,w,h,Color(35,35,35))
end

vgui.Register("SPanel",PANEL,"EditablePanel")