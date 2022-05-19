	print ("server side loaded")
local nets = {
"inv_give",
"inv_init",
"inv_use",
"inv_drop",
"inv_remove",
"inv_refresh",



}
for k,v in ipairs(nets) do 
util.AddNetworkString(v)
end
local _P = FindMetaTable("Player")

function _P:InvLog( msg )
	if not TUT_INV.Debugging then return end
	self:ChatPrint(msg)

end

hook.Add("PlayerInitialSpawn","InitInv",function( ply )
	ply:InvInit()
end)

concommand.Add("reloadinv",function(ply)
	if not ply:IsSuperAdmin() then return end
	ply:InvInit()
	-- body
end)

function _P:InvInit()
self.tut_inv = {}
net.Start("inv_init")
net.Send(self)
self:InvLog("Envanter baslatildi")	
end

function _P:InvGive( classname )
	if not TUT_INV.Items[classname] then self:InvLog("Yanlis bir item denendi" .. classname )return end
	table.insert(self.tut_inv, classname)
	net.Start("inv_give")
	net.WriteString(classname)
	net.Send(self)
    self:InvRefresh()
	self:InvLog("Başarıyla şu itemi aldın: " .. classname )
	-- body
end

function _P:InvHasItem(id)
    return self.tut_inv[id]
end
function _P:InvRemoveItem( id )
	self.tut_inv[id] = nil
	net.Start("inv_remove")
	net.WriteInt(id, 32)
	net.Send(self) 
	self:InvRefresh()
end


function _P:InvRefresh()
	net.Start("inv_refresh")
	net.Send(self)
end



net.Receive("inv_use", function(len, ply)
	local id = net.ReadInt(32)
	print(ply:InvHasItem(id))
if ply:InvHasItem(id) then	
	print(id)
		local itemData = TUT_INV.Items[ply.tut_inv[id]]
	local shouldRemove = TUT_INV.UseTypes[itemData.type](itemData, ply)
	if shouldRemove then 
		ply:InvRemoveItem(id)
	end 
end
end)


net.Receive("inv_drop", function(len, ply)
local id = net.ReadInt(32)
if ply:InvHasItem(id) then
	local itemData = TUT_INV.Items[ply.tut_inv[id]]
	local pos = ply:EyePos()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos+(ply:GetForward()*150)
	tracedata.filter = ply
	local tr = util.TraceLine(tracedata)
local itemEnt = ents.Create("inv_item")
itemEnt:SetPos(tr.HitPos)
itemEnt:Spawn()
itemEnt:SetItem(itemData)
ply:InvRemoveItem(id)

	end
end)


concommand.Add("inv_give",function(ply, cmd, args)
	if not ply:IsSuperAdmin() then return end	
	
	local classname = args[1]

	ply:InvGive(classname)
end)