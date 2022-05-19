local Spell = { }
Spell.LearnTime = 360
Spell.Description = [[
   Büyüyü uyguladığınız
   zaman uyguladığınız yere bir
   tuzak kurar ve biri tuzağınıza
   bastığı zaman size bunun bilgisi gelir.
]]
Spell.FlyEffect = "_wraithgun_tracer"
Spell.ImpactEffect = "lbox_open_t1"
Spell.ApplyDelay = 0.4
Spell.AccuracyDecreaseVal = 0.3
Spell.Category = { HpwRewrite.CategoryNames.Special }
Spell.NodeOffset = Vector(-1295, -343, 0)
Spell.Traps = true
Spell.ShouldSay = false
Spell.ForceDelay = 1800

function Spell:OnSpellSpawned(wand, spell)
	wand:PlayCastSound()
end

function Spell:OnFire(wand)
	return true
end

local points = { }

if SERVER then
	Spell.Points = points

	local wait = 0

	hook.Add("Think", "hpwrewrite_trapcurse_handler", function()
		if CurTime() < wait then return end

		for _, data in pairs(points) do
			local pos = data.Pos
			for k, ent in pairs(ents.FindInSphere(pos, 120)) do
				if ent == data.Owner and data.FreeOwner then continue end
				if ent.IsHarryPotterSpell or ent.Traps then continue end
				local phys = ent:GetPhysicsObject()

				if phys:IsValid() and phys:GetVelocity():Length() > 10 then
				data.Owner:ChatPrint("Biri tuzağına yakalandı!")
					local ef = EffectData()
					ef:SetOrigin(pos)
					local owner = data.Owner
					local wand = data.Wand
					
					if not IsValid(owner) then
						owner = game.GetWorld()
						wand = owner
					end
					
					if not IsValid(wand) then wand = owner end 
					
	                
					points[_] = nil
					break
				end
			end
		end

		wait = CurTime() + 0.15
	end)

	hook.Add("PostCleanupMap", "hpwrewrite_trapcurse_handler", function() 
	
		table.Empty(points)
		
	end)
end

function Spell:OnCollide(spell, data)
	local data2 = { }
	data2.Owner = self.Owner
	data2.Wand = HpwRewrite:GetWand(self.Owner)
	data2.Pos = data.HitPos
	data2.Normal = data.HitNormal
	points[#points + 1] = data2

	return false, data2
end

HpwRewrite:AddSpell("Sensio", Spell)




