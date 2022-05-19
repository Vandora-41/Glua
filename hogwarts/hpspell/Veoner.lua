local Spell = { }
Spell.LearnTime = 60

Spell.Category = HpwRewrite.CategoryNames.Generic

Spell.ApplyFireDelay = 0.4

Spell.Description = [[

]]

Spell.Year = [[
5.Yıl
]]

Spell.Ders = "KSKS"

Spell.AccuracyDecreaseVal = 5

Spell.ForceDelay = 6

Spell.CanSelfCast = false

Spell.NodeOffset = Vector(-750, -1300, 0)



function Spell:OnFire(wand)

        local ent = ents.Create( "vapor_nade" )


        ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 30 ) )

        ent:SetAngles( self.Owner:EyeAngles() )

        ent:SetOwner( self.Owner )

        ent:Spawn()

        ent:Activate()



        local phys = ent:GetPhysicsObject()


    phys:ApplyForceCenter( self.Owner:GetAimVector() * 10000 )

    sound.Play("ambient/levels/labs/electric_explosion4.wav", wand:GetPos(), 55, math.random(240, 255))

end



HpwRewrite:AddSpell("Veoaner", Spell)