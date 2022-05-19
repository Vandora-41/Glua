local Spell = { }
Spell.LearnTime = 180
Spell.Level = 1
Spell.Ders = "KSKS"
Spell.Description = [[
	Tehlikeli bir Buz Lanetidir.
]]

Spell.Category = { HpwRewrite.CategoryNames.Special, HpwRewrite.CategoryNames.DestrExp }
Spell.CanSelfCast = false
Spell.AccuracyDecreaseVal = 0.05

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_7 }
Spell.ApplyFireDelay = 0.2
Spell.AnimSpeedCoef = 1.5
Spell.AutoFire = true

Spell.SpriteColor = Color(220, 255, 255)

Spell.ShouldSay = false
Spell.NodeOffset = Vector(940, -845, 0)

function Spell:OnFire(wand)
	local pos = wand:GetSpellSpawnPosition()

	wand:PlayCastSound()

	local a = ents.Create("sfw_cryon_ent")
	a:SetPos(pos)
	a:SetOwner(self.Owner)

	local dir = (self.Owner:GetEyeTrace().HitPos - pos):GetNormal()
	wand:ApplyAccuracyPenalty(dir)

	a:SetAngles(dir:Angle())
	a:Spawn()
	a:Spawn()

	local phys = a:GetPhysicsObject()
	if not phys:IsValid() then SafeRemoveEntity(a) return end

	phys:ApplyForceCenter(dir * phys:GetMass() * 1500)
	phys:ApplyForceOffset(Vector(0, 0, -phys:GetMass() * 0.15), a:GetPos() + a:GetForward() * 20)
	phys:AddAngleVelocity(Vector(0, 5, 0))


end

HpwRewrite:AddSpell("Glarien Pulse", Spell)