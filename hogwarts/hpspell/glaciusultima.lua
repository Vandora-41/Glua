local Spell = { }
Spell.LearnTime = 210
Spell.Category = { HpwRewrite.CategoryNames.Special}
Spell.Description = [[
	Uygulandığı zaman
	etrafındaki kişileri
	dondurur.
]]
PrecacheParticleSystem( 'hpw_spells001.pcf' )

Spell.DoSelfCastAnim = false
Spell.ApplyFireDelay = 0.2
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_6 }
Spell.NodeOffset = Vector(-661, -973, 0)
Spell.SpriteColor = Color(215, 255, 254)
Spell.DoSparks = true
Spell.SparksLifeTime = 1.5
Spell.ShouldSay = true
Spell.CanSelfCast = false
Spell.ShouldReverseSelfCast = true
Spell.SanitatemCD = 3

function Spell:OnFire(wand)
	local pos = self.Owner:GetShootPos()

	local ent = wand:HPWGetAimEntity(350)
	sound.Play("hpwrewrite/wand/spellcast02.wav", wand:GetPos(), 65)

	local count = 0

	if IsValid(ent) then
		ParticleEffectAttach( 'hpw_dremboom_impact002', 1, ent, 1 )
	end

	--for i = 1, 4 do
	--end

	for k, v in pairs(ents.FindInSphere(self.Owner:GetPos(), 300)) do
		local valid = false

		if v:IsPlayer() or v:IsNPC() then
			if v != self.Owner then 
				v:SetHealth(math.min(v:GetMaxHealth(), v:Health() - 20)) 
				DoElementalEffect( { Element = EML_ICE, Target = v, Duration = 10, Attacker = self.Owner } )
				
				valid = true
			end
		end
end
end
HpwRewrite:AddSpell("Glacius Ultima", Spell)