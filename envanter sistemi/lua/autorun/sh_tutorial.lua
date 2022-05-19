print("sh_tutorial loaded")
TUT_INV = TUT_INV or {}
TUT_INV.Debugging = true

TUT_INV.Items = {}
TUT_INV.UseTypes = {
  weapon = function(itemData, ply)
  if ply:HasWeapon(itemData.classname) then return false end
    ply:Give(itemData.classname)
    return true
  end,
  model = function(itemData, ply)
    ply:SetModel(itemData.model)
    return false 
  end


}

function TUT_INV.AddItem(data)
local classname = data.classname
TUT_INV.Items[classname] = data
end

TUT_INV.AddItem({
	name = "Shotgun",
   classname = "weapon_shotgun",
   model = "models/weapons/w_shotgun.mdl",
   type = "weapon",
})
TUT_INV.AddItem({
	name = "Medkit",
   classname = "weapon_medkit",
   model = "models/Items/HealthKit.mdl",
   type = "weapon",
})
TUT_INV.AddItem({
  name = "pmodel",
   classname = "bu_pm",
   model = "models/player/bloodborne_male.mdl",
   type = "model",
})