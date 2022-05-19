local Spell = { }
Spell.LearnTime = 30
Spell.Description = [[
Uyguladığı kişiyi
Su küresi içine hapseden
bir lanettir.
]]

Spell.AccuracyDecreaseVal = 0.0017
Spell.ApplyFireDelay = 0.1
Spell.AnimSpeedCoef = 1.5
Spell.AutoFire = true
Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_7 }
Spell.SpriteColor = Color(195, 195, 195)
Spell.DoSparks = true
Spell.NodeOffset = Vector(-951, -940, 0)
Spell.CanSelfCast = false
Spell.ShouldSay = false


function Spell:OnFire(wand)
local ent = wand:HPWGetAimEntity(500)


timer.Create("suici".. self.Owner:GetName(), .1, 0, function()
 local pos = wand:GetSpellSpawnPosition() + self.Owner:GetAimVector() * 500, self.Owner:EyeAngles() + Angle(90, 0, 0)
HpwRewrite.MakeEffect("circle_d", pos)

		if ent:IsPlayer() or ent:IsNPC() then
				ent:SetPos(pos + Vector(0, 0, -30))
				valid = true
			else 	
                timer.Stop("suici".. self.Owner:GetName()) 
		end 		
    end)
timer.Create("bitirici".. self.Owner:GetName(), 10, 1, function()
timer.Stop("suici".. self.Owner:GetName())
end)
		sound.Play("npc/manhack/grind_flesh3.wav", wand:GetPos(), 80)
end



HpwRewrite:AddSpell("Bloar Win", Spell)