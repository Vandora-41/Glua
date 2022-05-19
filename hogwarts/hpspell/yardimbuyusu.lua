local Spell = { }
Spell.LearnTime = 60
Spell.Description = [[
Bu büyüyü uyguladığınız zaman
Asanızı doğrulttuğunuz yere
Mavi bir ışık gönderir ve 
bir saniye sonra patlar.
Yardım çağırmak için kullanılır.
]]
PrecacheParticleSystem( 'hpw_oimpact1' )
Spell.ApplyDelay = 0.4
Spell.FlyEffect = "hpw_stupefy_main"
Spell.ImpactEffect = "hpw_oimpact1"
Spell.ForceDelay = 25
Spell.Category = HpwRewrite.CategoryNames.Generic
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_5 }
Spell.SpriteColor = Color(0, 80, 255)
Spell.CanSelfCast = false

Spell.NodeOffset = Vector(-846, -1094, 0)
Spell.LeaveParticles = true

function Spell:Draw(spell)
	self:DrawGlow(spell, nil, 128)
end


function Spell:OnFire(wand)
	return true
end



function Spell:OnSpellSpawned(wand, spell)
	wand:PlayCastSound()
	
	timer.Simple(0.8, function()
		if IsValid(spell) then 
			HpwRewrite.BlastDamage(self.Owner, spell:GetPos(), 200, 30)
			
			HpwRewrite.MakeEffect(self.ImpactEffect, spell:GetPos())

			sound.Play("hpwrewrite/spells/periculum.wav", spell:GetPos(), 100, 100)
			
			SafeRemoveEntity(spell)
		end
	end)
end

function Spell:OnCollide(spell, data)
	HpwRewrite.BlastDamage(self.Owner, data.HitPos, 200, 30)

	sound.Play("hpwrewrite/spells/periculum.wav", data.HitPos, 100, 100)
end



HpwRewrite:AddSpell("Yardim Büyüsü", Spell)