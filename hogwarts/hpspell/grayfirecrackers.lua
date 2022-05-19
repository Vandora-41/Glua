local Spell = { }
Spell.LearnTime = 30
Spell.Description = [[
Asadan Kıvılcım çıkartan
bir büyü
]]

Spell.AccuracyDecreaseVal = 0.0017
Spell.ApplyFireDelay = 0.1
Spell.ForceDelay = 5
Spell.AnimSpeedCoef = 1.5
Spell.AutoFire = true
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_7 }
Spell.SpriteColor = Color(195, 195, 195)
Spell.DoSparks = true
Spell.NodeOffset = Vector(-951, -940, 0)
Spell.CanSelfCast = false
Spell.ShouldSay = false

PrecacheParticleSystem("fstar_hit_lgtning")

function Spell:OnFire(wand)
	HpwRewrite.MakeEffect("fstar_hit_lgtning", wand:GetSpellSpawnPosition() + self.Owner:GetAimVector() * 100, self.Owner:EyeAngles() + Angle(90, 0, 0))

	--if math.random(0, 1) == 1 then
		sound.Play("npc/manhack/grind_flesh3.wav", wand:GetPos(), 80)
	--end
end

HpwRewrite:AddSpell("Gray Firecrackers", Spell)