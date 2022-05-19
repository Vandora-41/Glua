AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include( "shared.lua" )


function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )	
	self:SetUseType( SIMPLE_USE )
--	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:DropToFloor()



	local phys = self:GetPhysicsObject()
	self.nodupe = true
	self.ShareGravgun = true

	phys:Wake()
end

function ENT:SetItem(itemData)
	self.classname = itemData.classname
	self:SetModel(itemData.model)
end

function ENT:Use(activator, caller)
	if self.classname then
		caller:InvGive(self.classname)
	self:Remove()
end
end