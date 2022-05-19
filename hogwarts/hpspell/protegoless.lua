
local Spell = { }
Spell.LearnTime = 720
Spell.ApplyFireDelay = 0.45
Spell.Category = "Koruyucu Büyüler"
Spell.AccuracyDecreaseVal = 0.2
Spell.Description = [[
	Uygulandığında etrafta
    sihirli ve görünmez bir
	bariyer oluşturur.
	
	Büyülü kalkan sadece
	30 saniyeliğine durur.
]]

Spell.Ders = "Öğretilmez"


Spell.level = 1
Spell.Kullanici = 0
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_6 }
Spell.NodeOffset = Vector(-487, 314, 0)
Spell.SpriteColor = Color(0, 255, 0)
Spell.DoSparks = true
Spell.Related = 'Protego Custos'
Spell.ShouldReverseSelfCast = true
Spell.CanSelfCast = false
Spell.ForceDelay = 90

function Spell:OnFire(wand)
	local ent = wand:HPWGetAimEntity(1)
	local salvi = self.Owner
	salvi.salviohexia = true
	sound.Play("hl1/ambience/port_suckin1.wav", wand:GetPos(), 60, 180)
local silah = salvi:GetActiveWeapon()


		local pos = self.Owner:GetShootPos()
		local a = ents.Create("prop_physics")
		a:SetCustomCollisionCheck(false)

		--SafeRemoveEntity(self.Shield)

		a:SetModel("models/hunter/misc/shell2x2a.mdl")
		a:SetPos(pos + Vector(0, 0, -60))
		a:SetModelScale(a:GetModelScale() * 5, 0)
		a:EnableCustomCollisions( true )
		a.PROTEGO_SHIELD = false
		a:SetOwner(self.Owner)
		--a:SetMaterial("models/props_combine/stasisfield_beam")
		a:SetMaterial("models/props_combine/portalball001_sheet")
		--a:SetMaterial("models/effects/comball_sphere")
		--a:SetMaterial("models/effects/comball_tape")

		a:SetCollisionBounds(Vector (-260, 250, 64), Vector (-260, 650, 64))

		a:Spawn()
		a:Activate() 
		a:GetPhysicsObject():EnableMotion(false)

		for k, ply in pairs(ents.FindInSphere(pos, 260)) do 
			ply:SetNWBool("heilen", true)
			ply:SetNWBool("nichttoeten", true)
		end

		timer.Create("heal_students", .1, 0, function()
			for k, ply in pairs(ents.FindInSphere(pos, 258)) do
				if ply:IsValid() and (ply:GetNWBool("heilen", false) == true ) then
					if ply:Health() > ply:GetMaxHealth() then return end 
					ply:SetHealth(math.min(ply:GetMaxHealth(), ply:Health() + 1))
                 	silah:SetNoDraw( true )
		ply:SetMaterial("particle/warp1_warp")
		ply:SetRenderMode( RENDERMODE_TRANSALPHA )
				end
			end
		end)



	self.Shield = a
	
	  local ply = self.Owner;
		if SERVER then

		end
		
	local oyuncu = self.Owner
		timer.Create("korumakapa", 30, 1, function()
				for k, kkapa in pairs(ents.FindInSphere(pos,340)) do
					if kkapa:GetClass() == "prop_physics" && kkapa:GetModel() == "models/hunter/misc/shell2x2a.mdl" then
						if kkapa:GetOwner() == self.Owner then kkapa:Remove() end
						timer.Stop("heal_students")
						timer.Stop("kill_enemies")

						for k, ply in pairs(ents.FindInSphere(pos,260)) do
							ply:SetNWBool("heilen", false)
		  				    ply:SetMaterial(" ")
                            ply:SetNoDraw( false )
						end
					end
				end
	    end )
end


HpwRewrite:AddSpell("Protego less", Spell)