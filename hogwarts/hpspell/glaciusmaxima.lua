local Spell = { }
Spell.LearnTime = 90
Spell.Level = 5
Spell.Ders = "KSKS"
Spell.Description = [[
	Uygulandığı zaman kişiye
	bir plazmik buz kütlesi gönderir
	ve kişiyi dondurur.
]]
Spell.FlyEffect = "_glight"
Spell.ImpactEffect = "_ghost_fireblast_frags"
Spell.ApplyDelay = 0.5
Spell.AccuracyDecreaseVal = 0.02
Spell.Category = { HpwRewrite.CategoryNames.Special }
Spell.AnimSpeedCoef = 1.28
Spell.ShouldSay = false
Spell.ForceDelay = 2

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_1, ACT_VM_PRIMARYATTACK_5 }
Spell.SpriteColor = Color(215, 255, 254)
Spell.NodeOffset = Vector(699, -830, 0)

function Spell:OnSpellSpawned(wand, spell)
	wand:PlayCastSound()
end

function Spell:Draw(spell)
	self:DrawGlow(spell)
end

function Spell:OnFire(wand)
	return true
end

function Spell:OnCollide(spell, data)
	local ent = data.HitEntity
	
	if IsValid(ent) then
		ent:TakeDamage(18, self.Owner, HpwRewrite:GetWand(self.Owner))
		DoElementalEffect( { Element = EML_ICE, Target = ent, Duration = 10, Attacker = self.Owner } )
	end
end

HpwRewrite:AddSpell("Glacius Maxima", Spell)