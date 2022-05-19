surface.CreateFont( "inv_24" , {
    font = "Roboto",
    extended = false,
    size = 24,
    weight = 500,
})

concommand.Add("inv_model",function ( ply )
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) then return end
	print(wep:GetWeaponWorldModel())
end)

net.Receive("inv_init", function()
	LocalPlayer().tut_inv = {}
	-- body
end)


net.Receive("inv_give", function()
   local classname = net.ReadString()
   table.insert(LocalPlayer().tut_inv, classname)

end)


net.Receive("inv_remove", function()
   local id = net.ReadInt(32)
   print(id)
   LocalPlayer().tut_inv[id] = nil
 
end)

net.Receive("inv_refresh",function()
    if IsValid(menu)then
    TUT_INV.Open()
    end
end)



function TUT_INV.Open()
	local ply = LocalPlayer()
	if not ply.tut_inv then return end
    local plyinv = ply.tut_inv
	local scrw, scrh = ScrW() ,ScrH()
    if IsValid(menu)then
        menu:Remove()
    end
	 menu = vgui.Create("DFrame")
	local inv = menu
	inv:SetSize(scrw * .5, scrh * .6)
	inv:Center()
	inv:SetTitle("")
	inv:MakePopup()
    inv.Paint = function(me,w,h )
    	surface.SetDrawColor(0,0,0,200)
    	surface.DrawRect(0,0,w,h)
    end
    local scroll = inv:Add("DScrollPanel")
    scroll:Dock(FILL)
    scroll.panels = {}
    local yPad = scrh * .01
    PrintTable(plyinv)
    for k,classname in pairs(plyinv) do 
    	local itemData = TUT_INV.Items[classname]
    	local itemPanel=scroll:Add("DPanel")
    	itemPanel:Dock(TOP)
    	itemPanel:DockMargin(0, yPad, 0, 0)
        itemPanel.Paint = function(me,w,h)
           surface.SetDrawColor(0,0,0,200)
           surface.DrawRect(0,0,w,h)
           draw.SimpleText(itemData.name,"inv_24",w * .1, h * .15, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        end
    

        local icon = vgui.Create("DModelPanel", itemPanel)
        icon:Dock(LEFT)
        icon:SetModel(itemData.model)
        icon.Entity:SetPos(icon.Entity:GetPos()- Vector(0,0,4))
        icon:SetFOV(50)
        local num = .7
        local min, max = icon.Entity:GetRenderBounds()
        icon:SetCamPos(min:Distance(max)* Vector(num, num, num))
        icon:SetLookAt((max + min)/ 2)
      function icon:LayoutEntity( Entity) return end
           local oldPaint = icon.Paint 
            icon.Paint = function(me,w,h)
            surface.SetDrawColor(0,0,0,100)
            surface.DrawRect(0,0,w,h)
            oldPaint(me,w,h)
            end
        local useButton = itemPanel:Add("DButton")
        useButton:Dock(RIGHT)
        useButton:SetText("")
        useButton.Paint = function(me,w,h)
        surface.SetDrawColor(0,0,0,200)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Use","inv_24",w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )   
        end
                local dropButton = itemPanel:Add("DButton")
        dropButton:Dock(RIGHT)
        dropButton:SetText("")
        dropButton.Paint = function(me,w,h)
        surface.SetDrawColor(0,0,0,200)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText("Drop","inv_24",w * .5, h * .5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )   
        end
    useButton.DoClick = function()
     net.Start("inv_use")
     net.WriteInt(k, 32)
     net.SendToServer()
    end
    dropButton.DoClick = function()
    net.Start("inv_drop")
     net.WriteInt(k, 32)
     net.SendToServer()
    end
    	scroll.panels[itemPanel] = true
    end
    scroll.OnSizeChanged = function (me,w,h)
    for k,v in pairs(me.panels) do
    	k:SetTall(h * .1)
    end
    end--functionun endi
end

hook.Add( "OnPlayerChat", "InvOpen", function(ply, strText, bTeam, bDead )
    if ( ply != LocalPlayer()) then return end

    strText = string.lower(strText)
    if (strText == "/inv") then

    TUT_INV.Open()

end
end)
