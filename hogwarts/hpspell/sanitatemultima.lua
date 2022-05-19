local Spell = { }
Spell.LearnTime = 210
Spell.Category = HpwRewrite.CategoryNames.Healing
Spell.Description = [[
	Uygulandığında etraftaki
	herkesi 10 saniye boyunca
	iyileştirebilen,
	güçlü bir büyüdür.
]]


Spell.DoSelfCastAnim = false
Spell.ApplyFireDelay = 0.2
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_6 }
Spell.NodeOffset = Vector(-661, -973, 0)
Spell.SpriteColor = Color(255, 0, 255)
Spell.DoSparks = true
Spell.SparksLifeTime = 1.5
Spell.ForceDelay = 25
Spell.ShouldSay = true
Spell.CanSelfCast = false
Spell.ShouldReverseSelfCast = true
PrecacheParticleSystem("saniulti")
function Spell:OnFire(wand)

	local ent = wand:HPWGetAimEntity(350)
	sound.Play("hpwrewrite/wand/spellcast02.wav", wand:GetPos(), 65)


	if IsValid(ent) then
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + 15))
	end
	ParticleEffectAttach( 'saniulti', 1, self.Owner, 1 )
timer.Create("sanu".. self.Owner:GetName(), .1, 0, function()
local pos = self.Owner:GetPos()

	for k, v in pairs(ents.FindInSphere(pos,160)) do

		if v:IsPlayer() or v:IsNPC() then
				v:SetHealth(math.min(v:GetMaxHealth(), v:Health() + 3)) 
	    end	
	end 		
end)
timer.Create("sanuf".. self.Owner:GetName(), 10, 1, function()
timer.Stop("sanu".. self.Owner:GetName())
self.Owner:StopParticles( )
end)
end

HpwRewrite:AddSpell("Sanitatem Ultima", Spell)