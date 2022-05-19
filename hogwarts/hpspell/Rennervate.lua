local Spell = { }
Spell.LearnTime = 60
Spell.Level = 1
Spell.Ders = "Buyuculuk"
Spell.ApplyFireDelay = 0.6
Spell.ForceDelay = 5
Spell.Category = HpwRewrite.CategoryNames.Special
Spell.Description = [[
	Temel seviye hiz buyusu
]]

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_5 }
Spell.DoSelfCastAnim = false
Spell.NodeOffset = Vector(245, -714, 0)
Spell.ShouldReverseSelfCast = true

function Spell:OnFire(wand)
local ent = wand:HPWGetAimEntity(700, Vector(-10, -10, -10), Vector(10, 10, 10))

		if IsValid(rag) then
			local bones = rag:GetPhysicsObjectCount()
			if bones < 2 then return end

			for i = 1, bones - 1 do
			constraint.Weld(rag, rag, 0, i, 0)

				local ef = EffectData()
				ef:SetOrigin(rag:GetPhysicsObjectNum(i):GetPos())
				ef:SetScale(1)
				ef:SetMagnitude(1)
				util.Effect("GlassImpact", ef, true, true)
			end
		end
	end)
end

HpwRewrite:AddSpell("Rennervate", Spell)