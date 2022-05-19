local Spell = { }
Spell.LearnTime = 30
Spell.Description = [[
Kullanıldığı zaman büyük bir
sis bulutu çıkartır.
]]

Spell.AccuracyDecreaseVal = 0.0017
Spell.ApplyFireDelay = 0.1
Spell.ForceDelay = 20
Spell.Category = HpwRewrite.CategoryNames.Generic
Spell.AnimSpeedCoef = 1.5
Spell.AutoFire = true
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_7 }
Spell.SpriteColor = Color(195, 195, 195)
Spell.DoSparks = true
Spell.NodeOffset = Vector(-951, -940, 0)
Spell.CanSelfCast = false
Spell.ShouldSay = false

PrecacheParticleSystem("duman")

function Spell:OnFire(wand)






	HpwRewrite.MakeEffect("duman", wand:GetSpellSpawnPosition() + self.Owner:GetAimVector() * 100, self.Owner:EyeAngles() + Angle(90, 0, 0))

	--if math.random(0, 1) == 1 then
		
	--end
	local pos = self.Owner:GetShootPos()
		sound.Play("ambient/wind/wind_moan4.wav", pos, 1000)
	timer.Create("sure", 5, 1, function()
sound.Play("ambient/wind/wind_moan4.wav", pos, 1000)
	end)
end

HpwRewrite:AddSpell("Nebulus", Spell)