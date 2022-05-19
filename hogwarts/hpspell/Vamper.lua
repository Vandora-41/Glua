local Spell = { }
Spell.LearnTime = 90
Spell.Level = 5
Spell.Ders = "KSKS"
Spell.Description = [[
	Vampel

	Dovus Buyusudur.
	kiside biraktiginiz hasar
	kadar iyilesirsiniz.
]]
Spell.FlyEffect = "hpw_expelliarmus_main"
Spell.ImpactEffect = "hpw_green_impact"
Spell.ApplyDelay = 0.5
Spell.AccuracyDecreaseVal = 0.02
Spell.Category = { HpwRewrite.CategoryNames.Fight, HpwRewrite.CategoryNames.Special }
Spell.AnimSpeedCoef = 1.28
Spell.ShouldSay = false
Spell.ForceDelay = 1.25

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_1, ACT_VM_PRIMARYATTACK_5 }
Spell.SpriteColor = Color(255, 20, 20)
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
	
	if ent:IsPlayer() then
		ent:TakeDamage(10, self.Owner, HpwRewrite:GetWand(self.Owner))
		self.Owner:SetHealth(math.min(self.Owner:GetMaxHealth(), self.Owner:Health() + 10))
	end

end

HpwRewrite:AddSpell("Vampel", Spell)