local Spell = { }
Spell.LearnTime = 60

Spell.Category = HpwRewrite.CategoryNames.Generic

Spell.ApplyFireDelay = 0.4

Spell.Description = [[
İnfinitium Clara'nın maksimum gücüne
ulaşmadan önceki halidir.
]]

Spell.Year = [[
5.Yıl
]]

Spell.Ders = "KSKS"

Spell.AccuracyDecreaseVal = 5

Spell.ForceDelay = 10

Spell.CanSelfCast = false

Spell.NodeOffset = Vector(-750, -1300, 0)



function Spell:OnFire(wand)

        local ent = ents.Create( "supra_nade_parent" )


        ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 30 ) )

        ent:SetAngles( self.Owner:EyeAngles() )

        ent:SetOwner( self.Owner )

        ent:Spawn()

        ent:Activate()



        local phys = ent:GetPhysicsObject()


    phys:ApplyForceCenter( self.Owner:GetAimVector() * 8500 )

    sound.Play("weapons/flashbang/flashbang_explode2.wav", wand:GetPos(), 55, math.random(240, 255))

end



HpwRewrite:AddSpell("Stardoom", Spell)