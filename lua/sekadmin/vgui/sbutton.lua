local PANEL = {}

function PANEL:Init()
    self:SetText("SButton")
end

function PANEL:SetInvert(set)
    self.inverted = set
end

function PANEL:GetInvert()
    return self.inverted
end

function PANEL:Paint(w,h)
    if self:GetInvert() then
        draw.RoundedBox(3,0,0,w,h,Color(220,220,220))
        draw.SimpleText(self:GetText(),"Default",w/2,h/2,Color(35,35,35))
    else
        draw.RoundedBox(3,0,0,w,h,Color(35,35,35))
        draw.SimpleText(self:GetText(),"Default",w/2,h/2,Color(220,220,220))
    end
end

vgui.Register("SButton",PANEL,"EditablePanel")