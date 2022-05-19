local Spell = { }
Spell.LearnTime = 60

Spell.Category = { HpwRewrite.CategoryNames.DestrExp }

Spell.ApplyFireDelay = 0.4

Spell.Description = [[
Kullanıldığı zaman kişiyi takip eden bir zehir lanetidir.
]]

Spell.Year = [[
5.Yıl
]]

Spell.Ders = "KSKS"

Spell.AccuracyDecreaseVal = 5

Spell.ForceDelay = 4

Spell.CanSelfCast = false

Spell.NodeOffset = Vector(-750, -1300, 0)



function Spell:OnFire(wand)

        local ent = ents.Create( "sfw_fathom_child" )


        ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 30 ) )

        ent:SetAngles( self.Owner:EyeAngles() )

        ent:SetOwner( self.Owner )

        ent:Spawn()

        ent:Activate()



        local phys = ent:GetPhysicsObject()


    phys:ApplyForceCenter( self.Owner:GetAimVector() * 10000 )

    sound.Play("weapons/flashbang/flashbang_explode2.wav", wand:GetPos(), 55, math.random(240, 255))

end



HpwRewrite:AddSpell("zehir", Spell)