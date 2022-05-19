AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include( "shared.lua" )
local tp1 = Vector(-873.23, 610, -12223)
local tp2 = Vector(-897.23, 520, -12223)
local tp3 = Vector(-918.23, 428, -12223)
local tp4 = Vector(-937.23, 333, -12223)
local tp5 = Vector(-958.23, 190, -12223)
local ent
local pos
--Basic code required to create the file--
function ENT:SpawnFunction( ply, tr, class )
	if ( !tr.Hit ) then return end
	 pos = tr.HitPos + tr.HitNormal * 4
	 ent = ents.Create( class )
	ent:SetPos( pos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()
	self:SetModel( self.WorldModel )
	self:SetModelScale( 2 )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetUseType( SIMPLE_USE )
	local phys = self:GetPhysicsObject()
	self.nodupe = true
	self.ShareGravgun = true
	phys:Wake()
	
	timer.Create("bitkispawn", 0.1, .1, function()
	
	local i = math.random( 1, 5 )

if i == 1 then
ent:SetPos(tp1)
end
if i == 2 then
ent:SetPos(tp2)
end
if i == 3 then
ent:SetPos(tp3)
end
if i == 4 then
ent:SetPos(tp4)
end
if i == 5 then
ent:SetPos(tp5)
end
end)	
end

function ENT:Remove()
end

function ENT:Think()
	if self:WaterLevel() > 0 then
		self:Remove()
	end
end

function ENT:Use( activator )

	self:Remove()
end