
AddCSLuaFile()
AddCSLuaFile( "autorun/cl_mas_ninjaskunai_options.lua" )
AddCSLuaFile( "autorun/sh_mas_ninjaskunai_fonts.lua" )
include( "autorun/cl_mas_ninjaskunai_options.lua" )
include( "autorun/sh_mas_ninjaskunai_fonts.lua" )

if (CLIENT) then

	SWEP.PrintName			= "Normal Kunai"
	SWEP.Author				= "Vandora"
	SWEP.Category 			= "Kunailer"
	SWEP.Instructions		= [[
	LMB: Attack
	RMB: Ability 1
	"F" Key: Ability 2
	"C" Key: Ability 3
	"T" Key: Ultimate Ability
	Mouse3: Ability Selection
	
	]]
	
end // end If Client

SWEP.ViewModel			=	Model( "models/weapons/maranzosabilitysweps/c_mas_ninjakunai.mdl" )
SWEP.UseHands			=	true
SWEP.WorldModel			=	Model( "models/weapons/maranzosabilitysweps/w_mas_ninjakunai.mdl" )
SWEP.HoldType			=	"knife"
SWEP.ViewModelFOV 		= 	54
SWEP.Spawnable 			= 	GetConVar( "sk_mas_ninjaskunai_enabled" ):GetBool()
SWEP.AdminOnly 			= 	GetConVar( "sk_mas_ninjaskunai_adminonly" ):GetBool()

SWEP.Weight				= 	5
SWEP.AutoSwitchTo		= 	true
SWEP.AutoSwitchFrom		= 	false
SWEP.ShouldDropOnDie	=	false

SWEP.Slot				= 	1 -- Secondary weapon
SWEP.SlotPos			= 	0 -- Takes up the beginning slot
SWEP.DrawAmmo			= 	false -- Do not show ammo on HUD
SWEP.DrawCrosshair		= 	true

SWEP.Primary.ClipSize		= 	-1 -- Infinite Ammo
SWEP.Primary.DefaultClip	= 	-1 -- Starts Infinite
SWEP.Primary.Automatic		= 	true -- is automatic
SWEP.Primary.Ammo			= 	"none" -- "none" bc no ammo needed
SWEP.Primary.Spread			= 	0 -- "none" bc no ammo needed
SWEP.Primary.Damage			= 	25
SWEP.Primary.DamageUppercut	= 	40

SWEP.Secondary.ClipSize		= 	-1 -- Infinite again
SWEP.Secondary.DefaultClip	= 	-1
SWEP.Secondary.Automatic	= 	false -- is not automatic
SWEP.Secondary.Ammo			= 	"none" -- No ammo needed
SWEP.Secondary.MaxDistance	= 	6000

SWEP.SwingDelay1			=	0.24
SWEP.SwingDelay2			=	1
SWEP.ModDelay				=	1
SWEP.ModDmg					=	1
SWEP.Hit					= 	false
SWEP.HitTime				= 	CurTime()
SWEP.HitDistance		 	= 	50

// Abilities

ASWEP_Ability_AutoAttack		= 1
ASWEP_Ability_ThrowKunai		= 2
ASWEP_Ability_NinjaDash			= 3
ASWEP_Ability_Concealment		= 4
ASWEP_Ability_Substitution		= 5
ASWEP_Ability_Select			= 6
ASWEP_Ability_Holster			= 7

SWEP.AbilityTable = {
	["Equipped"] = {
		[ASWEP_Ability_AutoAttack]		= {
			["Category"] = "AutoAttack",
			["Name"] = "Kunai Slash",
			["Description"] = "Slash your target with your kunai." },
		[ASWEP_Ability_ThrowKunai]		= { ["Category"] = "Ability 1", ["Name"] = "Throw Kunai", ["Description"] = "Throw your kunai at your target dealing 35 damage." },
		[ASWEP_Ability_NinjaDash]		= { ["Category"] = "Ability 2", ["Name"] = "Ninja Dash", ["Description"] = "Dash in the direction you're aiming!" },
		[ASWEP_Ability_Concealment]		= {	["Category"] = "Ability 3", ["Name"] = "Concealment", ["Description"] = "Crouch down and conceal yourself for a time. Standing, taking non-fall damage, or approaching someone disables this." },
		[ASWEP_Ability_Substitution]	= {	["Category"] = "Ultimate", ["Name"] = "Substitution", ["Description"] = "Awaken your latent power to create and control an illusion of yourself. Return to your casting location after taking damage." },
	},
}

-------------------------------------------------------------------

local ability_icons = {
	[ASWEP_Ability_AutoAttack] 		= { def = Material( 'hud/maranzo_abilityswep/icon_aa_kunaislash.png' ), cast = Material( 'hud/maranzo_abilityswep/icon_aa_kunaislash.png' ) },
	[ASWEP_Ability_ThrowKunai] 		= { def = Material( 'hud/maranzo_abilityswep/icon_kunaithrow.png' ), 	cast = Material( 'hud/maranzo_abilityswep/icon_kunaithrow_cast.png' ) },
	[ASWEP_Ability_NinjaDash] 		= { def = Material( 'hud/maranzo_abilityswep/icon_dash.png' ), 			cast = Material( 'hud/maranzo_abilityswep/icon_dash_cast.png' ) },
	[ASWEP_Ability_Concealment]		= { def = Material( 'hud/maranzo_abilityswep/icon_concealment.png' ), 	cast = Material( 'hud/maranzo_abilityswep/icon_concealment_cast.png' ) },
	[ASWEP_Ability_Substitution] 	= { def = Material( 'hud/maranzo_abilityswep/icon_substitution.png' ), 	cast = Material( 'hud/maranzo_abilityswep/icon_substitution_cast.png' ) },
}

local function DrawCenteredRect( x, y, w, h )
	surface.DrawTexturedRect( x - w / 2, y - h / 2, w, h )
end

	
if (CLIENT) then
	killicon.Add( "weapon_kunainormal", "icons/weapon_ninjaskunai_killicon", color_white )
	local WepSelectIcon = Material( "icons/weapon_ninjaskunai_weaponselect.png" )
	local Size = 128
	
	function SWEP:DrawWeaponSelection( x, y, w, h, a )
		surface.SetDrawColor( 255, 255, 255, a )
		surface.SetMaterial( WepSelectIcon )
	
		surface.DrawTexturedRect( x + ( ( w - Size ) / 2 ), y + 2, Size, Size )
	
		-- Draw weapon info box
		self:PrintWeaponInfo( x + w + 20, y + h * 0.95, a )
	end
end

-------------------------------------------------------------------
-- Precache Misc Sounds

local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "npc/roller/blade_cut.wav" )
local HitSoundSquish = Sound( "npc/roller/blade_cut.wav" )
local HitSoundHard = Sound( "npc/roller/blade_out.wav" )

--------------------------------------------------------------------
-- Define Local Functions

// Keys down for SinglePlayer
local keysDown = {}

// Effect F'n for think
local function playEffect( origin, entity, flags, effectstr, iterations, scale, magnitude, r1, r2, rz )
	
	if !iterations then iterations = 1 end
	if !scale then scale = 1 end
	if !magnitude then magnitude = 1 end
	if !r1 then r1 = 0 r2 = 0 end
	if !r2 then r2 = r1 end
		local TF_ed = EffectData()
		TF_ed:SetOrigin( origin )
		TF_ed:SetEntity( entity )
		TF_ed:SetFlags( flags )
		TF_ed:SetScale( scale )
		TF_ed:SetMagnitude( magnitude )
	for i=1, iterations do
		local randVec = !rz and Vector( math.random( -r1, r2 ), math.random( -r1, r2 ), 0 ) or Vector( math.random( -r1, r2 ), math.random( -r1, r2 ), math.random( -r1, r2 ) )
		TF_ed:SetOrigin( origin + randVec )
		util.Effect( effectstr, TF_ed, true, true )
	end
	
end

--------------------------------------------------------------------
-- Define SWEP Functions

local MASS = {}
function SWEP:Initialize( bool )
	self.Spawnable			= 	GetConVar( "sk_mas_ninjaskunai_enabled" ):GetBool()
	self.AdminOnly			= 	GetConVar( "sk_mas_ninjaskunai_adminonly" ):GetBool()
	
	if Maranzos_AbilitySWEPs then 
		Maranzos_AbilitySWEPs.BMS_InfUlt= tobool( GetConVarNumber( "sk_mas_ninjaskunai_infinitecharge" ) )
		Maranzos_AbilitySWEPs.BMS_NoCD	= tobool( GetConVarNumber( "sk_mas_ninjaskunai_nocooldown" ) )
		
		table.Merge( MASS, Maranzos_AbilitySWEPs ) -- Merge that shit rather than reference it
	end
	
	MASS.IsCasting					=	false
	MASS.Ability 					=	{}
	MASS.Ability.AA 					= 	{}	-- Auto Attack
	MASS.Ability.ThrowKn 			= 	{}	-- Throw Kunai
	MASS.Ability.NinjaDash 			= 	{}	-- Ninja Dash
	MASS.Ability.Conceal 			= 	{}	-- Concealment
	MASS.Ability.Substitution 		= 	{}	-- Ultimate: Substitution
	
	-- Ultimate: Substitution
	MASS.Ability.Substitution.MarkedPos		=	vector_origin
	MASS.Ability.Substitution.MarkedAngles	=	vector_origin
	MASS.Ability.Substitution.MaxCharge		=	100
	MASS.Ability.Substitution.SoundCast		= 	Sound( "npc/antlion/idle1.wav" )
	MASS.Ability.Substitution.SoundHit		= 	Sound( "physics/cardboard/cardboard_box_impact_bullet4.wav" )
	MASS.Ability.Substitution.SoundEnd		= 	Sound( "npc/antlion_guard/far_foot_heavy1.wav" )
	
	-- Throw Kunai
	MASS.Ability.ThrowKn.Cooldown		=	1	-- seconds
	MASS.Ability.ThrowKn.Damage			=	35
	MASS.Ability.ThrowKn.SoundCast		=	Sound( "npc/manhack/mh_blade_snick1.wav" )
	MASS.Ability.ThrowKn.SoundHit		=	Sound( "phx/eggcrack.wav" )
	MASS.Ability.ThrowKn.SoundMiss		=	Sound( "phx/hmetal1.wav" )
	
	-- Ninja Dash
	MASS.Ability.NinjaDash.Cooldown		=	10	-- seconds
	MASS.Ability.NinjaDash.DashDistance	=	600
	MASS.Ability.NinjaDash.DashSpeed		=	1800
	MASS.Ability.NinjaDash.Duration		=	1	-- seconds
	MASS.Ability.NinjaDash.SoundCast		= 	Sound( "Sand.BulletImpact" )
	MASS.Ability.NinjaDash.Legs			=	ConVarExists( "cl_legs" )
	if CLIENT and MASS.Ability.NinjaDash.Legs then
		MASS.Ability.NinjaDash.LegsNum	=	GetConVarNumber( "cl_legs" )
	end
	
	-- Concealment
	MASS.Ability.Conceal.Cooldown		=	14	-- seconds
	MASS.Ability.Conceal.Duration		=	10
	MASS.Ability.Conceal.SoundCast		=	Sound( "ambient/energy/spark2.wav" ) -- Activate Sound
	--MASS.Ability.Conceal.SoundCast		=	Sound( "buttons/spark2.wav" ) -- Activate Sound
	MASS.Ability.Conceal.SoundHit		=	Sound( "npc/barnacle/neck_snap2.wav" ) -- Hit Sound
	MASS.Ability.Conceal.SoundEnd		=	Sound( "ambient/energy/spark4.wav" ) -- Activate Sound
	--MASS.Ability.Conceal.SoundEnd		=	Sound( "buttons/spark1.wav" ) -- Activate Sound
	
	if Maranzos_AbilitySWEPs.BMS_NoCD then
		self.SwingDelay1					=	0.24
		self.SwingDelay2					=	0.24
		MASS.Ability.Substitution.Cooldown		=	1
		MASS.Ability.ThrowKn.Cooldown		=	1
		MASS.Ability.NinjaDash.Cooldown		=	1
		MASS.Ability.Conceal.Cooldown		=	1
		MASS.Ability.NinjaDash.CooldownMiss	=	1
		MASS.Ability.Conceal.CooldownMiss	=	1
	end
	
	
	local ply = self.Owner
	
	if (CLIENT) then
		self.DrawCrosshair		= 	GetConVar( "cl_mas_crosshairon" ):GetBool()
		self.KB = Maranzos_AbilitySWEPs.keyconfigs
		
		// Define a table of instructions
		self.Instr = {}
		self.Instr["H1"] = self.KB[ 1 ] .. " : "
		self.Instr["H2"] = self.KB[ 2 ] .. " : "
		self.Instr["H3"] = self.KB[ 3 ] .. " : "
		self.Instr["H4"] = self.KB[ 4 ] .. " : "
		self.Instr["H5"] = self.KB[ 5 ] .. " : "
		self.Instr["H6"] = self.KB[ 6 ] .. " : "
		self.Instr["1"] = "Attack"
		self.Instr["2"] = "Throw Kunai"
		self.Instr["3"] = "Ninja Dash"
		self.Instr["4"] = "Concealment"
		self.Instr["5"] = "Ultimate: Substitution"
		self.Instr["6"] = "Ability Selection"
		self.Instr["7"] = "\n".. "Press your Reload key to holster your weapon!"
		self.Instr["8"] = "\n".. "Check the Options menu to Rebind Abilities and Enable Menu & Flashlight use."
	
		// Run when key pressed
		if !game.SinglePlayer() then
			hook.Add( "PlayerButtonDown", "MASS.Keybind.NinjasKunai" .. ply:EntIndex(), function( ply, btn )
				local Wep = ply:GetActiveWeapon()
				
				if ( ply:IsValid() and ply:Alive() and Wep:IsValid() and Wep:GetClass() == "weapon_kunainormal" ) then
					
					if self.KB and self.KB["Btn"][btn] and IsFirstTimePredicted() then 
						-- AutoAttack & Ability #1:Throw Kunai are bound to +attack & +attack2 by default & won't trigger anything here.
						if !vgui.CursorVisible() then
							
							if self.KB["Btn"][btn] == ASWEP_Ability_NinjaDash then 
							// Abil 2: Ninja Dash
								local CD = MASS.Ability.NinjaDash.Cooldown
								if ( self:GetA2_Active() or self:GetIsCasting() or self:GetA2_CD() != 0 ) then 
									return 
								end
								local ability = ASWEP_Ability_NinjaDash
								self:SetIsCasting( true )
								
								net.Start( "Maranzo_AbilitySWEP_ninjaskunai_Castt" )
								net.WriteInt( ability, 4 )
								net.SendToServer()
								
							elseif self.KB["Btn"][btn] == ASWEP_Ability_Concealment then 
							// Abil 3: Concealment
								local CD = MASS.Ability.Conceal.Cooldown
								if ( !( self:GetA3_Active() or self:GetA3_CD() == CD + 2 ) and ( self:GetIsCasting() or self:GetA3_CD() != 0 ) ) then 
									return 
								end
								local ability = ASWEP_Ability_Concealment
								self:SetIsCasting( true )
								
								net.Start( "Maranzo_AbilitySWEP_ninjaskunai_Castt" )
								net.WriteInt( ability, 4 )
								net.SendToServer()
								
							elseif self.KB["Btn"][btn] == ASWEP_Ability_Substitution then 
							// Ultimate: Substitution
								if ( self:GetIsCasting() or self:GetAU_Active() ) then 
									return -- do nothing
								end
								
								self:SetIsCasting( true )
								local ability = ASWEP_Ability_Substitution
								
								net.Start( "Maranzo_AbilitySWEP_ninjaskunai_Castt" )
								net.WriteInt( ability, 4 )
								net.SendToServer()
								
							end // end Key Check
						end // end if cursor visible
						
						if self.KB["Btn"][btn] == ASWEP_Ability_Select then
						// Ability Selection
							self:DrawAbilitySelection()
							
						end // end Key check, cursor visible OK
						
					end // end Btn Pushed Check
				end // end if ply & alive & weapon
			end) // end Hook
		else // if game is SinglePlayer
			-- do nothing
		end // end if SinglePlayer
	
		// Run when key pressed
		hook.Add( "PlayerBindPress", "MASS.Keybind.NinjasKunai" .. ply:EntIndex(), function( ply, bind, down )
			local Wep = ply:GetActiveWeapon()
			if ( ply and ply:IsValid() and ply:Alive() and MASconvar_preventbinds:GetBool() and Wep:IsValid() and ply:GetActiveWeapon():GetClass() == "weapon_kunainormal" ) then
				if ( string.find( bind, "impulse 100" ) or string.find( bind, "+menu" ) or string.find( bind, "+menu_context" ) ) then 
					return true
				end // end string find 
			end // end if Valid
		end) // end Hook
		
	end // end If Client
	
	if !bool then
		self:SetHoldType( "knife" )
		if (SERVER) then
			self:SetCharge( 0 )
		end
	end

end  // end Fn Initialize

// On Lua Edited
function SWEP:OnReloaded()
	
	
	if Maranzos_AbilitySWEPs then 
		Maranzos_AbilitySWEPs.BMS_InfUlt= tobool( GetConVarNumber( "sk_mas_ninjaskunai_infinitecharge" ) )
		Maranzos_AbilitySWEPs.BMS_NoCD	= tobool( GetConVarNumber( "sk_mas_ninjaskunai_nocooldown" ) )
		
		table.Merge( MASS, Maranzos_AbilitySWEPs ) -- Merge that shit rather than reference it
	end
	
	MASS.IsCasting					=	false
	MASS.Ability 					=	{}
	MASS.Ability.AA 					= 	{}	-- Auto Attack
	MASS.Ability.ThrowKn 			= 	{}	-- Throw Kunai
	MASS.Ability.NinjaDash 			= 	{}	-- Ninja Dash
	MASS.Ability.Conceal 			= 	{}	-- Concealment
	MASS.Ability.Substitution 		= 	{}	-- Ultimate: Substitution
	
	-- Ultimate: Substitution
	MASS.Ability.Substitution.MarkedPos		=	vector_origin
	MASS.Ability.Substitution.MarkedAngles	=	vector_origin
	MASS.Ability.Substitution.MaxCharge		=	100
	MASS.Ability.Substitution.SoundCast		= 	Sound( "npc/antlion/idle1.wav" )
	MASS.Ability.Substitution.SoundHit		= 	Sound( "physics/cardboard/cardboard_box_impact_bullet4.wav" )
	MASS.Ability.Substitution.SoundEnd		= 	Sound( "npc/antlion_guard/far_foot_heavy1.wav" )
	
	-- Throw Kunai
	MASS.Ability.ThrowKn.Cooldown		=	1	-- seconds
	MASS.Ability.ThrowKn.Damage			=	35
	MASS.Ability.ThrowKn.SoundCast		=	Sound( "npc/manhack/mh_blade_snick1.wav" )
	MASS.Ability.ThrowKn.SoundHit		=	Sound( "phx/eggcrack.wav" )
	MASS.Ability.ThrowKn.SoundMiss		=	Sound( "phx/hmetal1.wav" )
	
	-- Ninja Dash
	MASS.Ability.NinjaDash.Cooldown		=	10	-- seconds
	MASS.Ability.NinjaDash.DashDistance	=	600
	MASS.Ability.NinjaDash.DashSpeed		=	1800
	MASS.Ability.NinjaDash.Duration		=	1	-- seconds
	MASS.Ability.NinjaDash.SoundCast		= 	Sound( "Sand.BulletImpact" )
	MASS.Ability.NinjaDash.Legs			=	ConVarExists( "cl_legs" )
	if CLIENT and MASS.Ability.NinjaDash.Legs then
		MASS.Ability.NinjaDash.LegsNum	=	GetConVarNumber( "cl_legs" )
	end
	
	-- Concealment
	MASS.Ability.Conceal.Cooldown		=	14	-- seconds
	MASS.Ability.Conceal.Duration		=	10
	MASS.Ability.Conceal.SoundCast		=	Sound( "ambient/energy/spark2.wav" ) -- Activate Sound
	--MASS.Ability.Conceal.SoundCast		=	Sound( "buttons/spark2.wav" ) -- Activate Sound
	MASS.Ability.Conceal.SoundHit		=	Sound( "npc/barnacle/neck_snap2.wav" ) -- Hit Sound
	MASS.Ability.Conceal.SoundEnd		=	Sound( "ambient/energy/spark4.wav" ) -- Activate Sound
	--MASS.Ability.Conceal.SoundEnd		=	Sound( "buttons/spark1.wav" ) -- Activate Sound
	
	if Maranzos_AbilitySWEPs.BMS_NoCD then
		self.SwingDelay1					=	0.24
		self.SwingDelay2					=	0.24
		MASS.Ability.Substitution.Cooldown		=	1
		MASS.Ability.ThrowKn.Cooldown		=	1
		MASS.Ability.NinjaDash.Cooldown		=	1
		MASS.Ability.Conceal.Cooldown		=	1
		MASS.Ability.NinjaDash.CooldownMiss	=	1
		MASS.Ability.Conceal.CooldownMiss	=	1
	end
	
end

function SWEP:DrawAbilitySelection()
	
	if ( MASS.Editor != nil ) then
		MASS.Editor:Remove()
		MASS.Editor = nil
	elseif !vgui.CursorVisible() then
		local x = ScrW()
		local y = ScrH()
		local BGColor = Color( 0, 130, 200, 200 )
		local FGColor = Color(50, 50, 50, 150)
		local BorderColor = Color( 0, 100, 165, 255 )
		local TColor1 = Color(255, 255, 255, 255)
		local TColor2 = Color(255, 180, 20, 255)
		local TColor3 = Color(255, 240, 220, 255)
		local TColorBG = Color(60, 60, 60, 255)
		local OvlColor = Color(255, 255, 0, 100)
		MASS.Editor = vgui.Create( "DFrame" ) //Create a Frame to contain everything.
		MASS.Editor:SetTitle( "" )
		MASS.Editor:SetSize( x, y )
		MASS.Editor:Center()
		MASS.Editor:SetVisible( true )
		MASS.Editor:ShowCloseButton( false )
		function MASS.Editor:Paint()
			surface.SetDrawColor( BGColor )
			surface.DrawRect( 0, 0, x, y )
			surface.SetDrawColor( BorderColor )
			for i=1, 6 do
				surface.DrawOutlinedRect( 0+i, 0+i, x - i*2, y - i*2 )
			end
			local Tx = x/2
			local Ty = y/20
			draw.SimpleText("Ability Selection", "MaranzoAbil_UltimateFont", Tx + 2, Ty + 2, TColorBG, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText("Ability Selection", "MaranzoAbil_UltimateFont", Tx, Ty, TColor1, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
			
		local DButton = vgui.Create( "DButton", MASS.Editor )
		local size = 64
		local border = 12
		DButton:SetSize( size, size )
		DButton:SetPos( x - size - border, y - size - border )
		DButton:SetText( "Close" )
		DButton:SetTextColor( TColor1 )
		DButton:SetFontInternal( "MaranzoAbil_DefaultFont" )
		DButton:SetExpensiveShadow( 1, TColorBG )
		DButton.DoClick = function()
			MASS.Editor:Remove()
			MASS.Editor = nil
		end
		local Dw, Dh
		function DButton:Paint( w, h)
			Dw = w
			Dh = h
			draw.RoundedBox( 8, 0, 0, Dw, Dh, BorderColor )
			draw.RoundedBox( 8, 0, 0, Dw - 4, Dh - 4, FGColor )
		end
		
		
		MASS.Editor.Scroll = vgui.Create( "DScrollPanel", MASS.Editor ) //Create the Scroll panel
		MASS.Editor.Scroll:SetSize( x - 24, y - y/5 )
		MASS.Editor.Scroll:SetPos( 12, y/20 )
		
		MASS.Editor.List = vgui.Create( "DIconLayout", MASS.Editor.Scroll )
		MASS.Editor.List:SetSize( x - 30, y - y/5 )
		MASS.Editor.List:SetPos( 0, 0 )
		MASS.Editor.List:SetSpaceX( 5 )
		MASS.Editor.List:SetSpaceY( 10 )
		
		// Create list
		for k, v in ipairs( self.AbilityTable["Equipped"] ) do -- ipairs is a temp fix until I add additional abilities
			local ListItem = MASS.Editor.List:Add( "DPanel" ) //Add DPanel to the DIconLayout
			ListItem:SetSize( MASS.Editor.List:GetWide(), y/7 ) //Set the size of it
			function ListItem:Paint( w, h )
				local drawColor = Color( 255, 255, 255, 255 )
				local ability = k
				local material = ability_icons[ ability ] and ability_icons[ ability ].def or ability_icons[ ASWEP_Ability_AutoAttack ].def
				local size = 64
				local Tx = w/50
				local Ty = 2
				surface.SetMaterial( material )
				surface.SetDrawColor( drawColor )
				DrawCenteredRect( size/2 + Tx, h/2, size, size )
				draw.SimpleText( v["Category"], "MaranzoAbil_DefaultFont", Tx +2, 2 +2, TColorBG, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
				draw.SimpleText( v["Category"], "MaranzoAbil_DefaultFont", Tx, 2, TColor2, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
				draw.SimpleText( v["Name"], "MaranzoAbil_DefaultFont", Tx +2, h - 28 +2, TColorBG, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
				draw.SimpleText( v["Name"], "MaranzoAbil_DefaultFont", Tx, h - 28, TColor1, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT )
			end // end ListItem Paint
			
			local DLabel = vgui.Create( "DLabel", ListItem )
			local w = ListItem:GetWide()
			local h = ListItem:GetTall()
			local Tx, Sx
			if x > 1200 then
				if x > 1350 then Tx = w/7 Sx = w - Tx * 2.5
				else Tx = w/6 Sx = w - Tx * 2 end
			else Tx = w/4 Sx = w - Tx end
			
			local Ty = 12
			DLabel:SetSize( Sx, h - 14 )
			DLabel:SetPos( Tx, Ty )
			DLabel:SetText( v["Description"] )
			DLabel:SetContentAlignment( 4 )
			DLabel:SetTextColor( TColor3 )
			DLabel:SetTextInset( 0, 0 )
			DLabel:SetFontInternal( "MaranzoAbil_DefaultFont" )
			DLabel:SetWrap( true )
			DLabel:SetExpensiveShadow( 1, TColorBG )
			
		end // end For Loop List Creation
		
	end
	
end

function SWEP:DrawHUD()
	
	// Setup Var's used across the board
	local Charge = self:GetCharge()
	local ability
	local ACTIVE
	local CD
	
	if !MASconvar_drawhud:GetBool() then return end
	// Ability Icon Draw
	local drawColor = ( prohibited ) and Color( 100, 100, 100, 255 ) or Color( 255, 255, 255, 255 ) -- shortened If statement	
	local size = ( menushown && ability == menu_ability ) and 128 or 64 // 128 | 64
	local ultsize = ( menushown && ability == menu_ability ) and 128 or 128 // 128 | 128
	
	-- positioning
	local x = ScrW()/2 -- Ult (Center)
	local y = ScrH() - 70
	local dif = 110
	local x0 = x - dif * 1.7 -- AA
	local x1 = x - dif
	local x2 = x + dif
	local x3 = x + dif * 1.7
	local TxtY = y + size * 0.65
	local Txt2Y = y + size * 0.65 + 2
	local TColor = Color(255, 255, 255, 255)
	local T2Color = Color(20, 20, 20, 255)
	
	// Auto-Attack
	ability = ASWEP_Ability_AutoAttack
	ACTIVE = self:GetAA_Active()
	CD = self:GetAA_CD()
	drawColor = ( CD > 0 ) and Color( 100, 100, 100, 255 ) or Color( 255, 255, 255, 255 ) -- shortened If statement
	surface.SetMaterial( ability_icons[ ability ].def )
	surface.SetDrawColor( drawColor )
	DrawCenteredRect( x0, y, size, size )
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x0 + 1, Txt2Y, T2Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x0, TxtY, TColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	// Ability 1
	ability = ASWEP_Ability_ThrowKunai
	ACTIVE = self:GetA1_Active()
	CD = self:GetA1_CD()
	if !ACTIVE then // Not Active
		surface.SetMaterial( ability_icons[ ability ].def )
		
		if CD > 0 then
			drawColor = Color( 100, 100, 100, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x1, y, size, size )
			draw.SimpleText( CD, "MaranzoAbil_DefaultFont", x1, y, TColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			drawColor = Color( 255, 255, 255, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x1, y, size, size )
		end
		
	else // Active
		drawColor = Color( 255, 255, 255, 255 ) -- shortened If statement
		surface.SetMaterial( ability_icons[ ability ].cast )
		surface.SetDrawColor( drawColor )
		DrawCenteredRect( x1, y, size, size )
	end // end if Active
	
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x1 + 1, Txt2Y, T2Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x1, TxtY, TColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	
	// Ability 2
	ability = ASWEP_Ability_NinjaDash
	ACTIVE = self:GetA2_Active()
	CD = self:GetA2_CD()
	if !ACTIVE then // Not Active
		surface.SetMaterial( ability_icons[ ability ].def )
		
		if CD > 0 then
			drawColor = Color( 100, 100, 100, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x2, y, size, size )
			draw.SimpleText( CD, "MaranzoAbil_DefaultFont", x2, y, TColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			drawColor = Color( 255, 255, 255, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x2, y, size, size )
		end
		
	else // Active
		drawColor = Color( 255, 255, 255, 255 )
		surface.SetMaterial( ability_icons[ ability ].cast )
		surface.SetDrawColor( drawColor )
		DrawCenteredRect( x2, y, size, size )
	end // end if Active
	
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x2 + 1, Txt2Y, T2Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x2, TxtY, TColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	
	// Ability 3
	ability = ASWEP_Ability_Concealment
	ACTIVE = self:GetA3_Active()
	CD = self:GetA3_CD()
	if !ACTIVE then // Not Active
		surface.SetMaterial( ability_icons[ ability ].def )
		
		if CD > 0 then
			drawColor = Color( 100, 100, 100, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x3, y, size, size )
			draw.SimpleText( CD, "MaranzoAbil_DefaultFont", x3, y, TColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			drawColor = Color( 255, 255, 255, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x3, y, size, size )
		end
		
	else // Active
		drawColor = Color( 255, 255, 255, 255 )
		surface.SetMaterial( ability_icons[ ability ].cast )
		surface.SetDrawColor( drawColor )
		DrawCenteredRect( x3, y, size, size )
	end // end if Active
	
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x3 + 1, Txt2Y, T2Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x3, TxtY, TColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	// Ultimate
	ability = ASWEP_Ability_Substitution
	ACTIVE = self:GetAU_Active()
	if !ACTIVE then // Not Active
		surface.SetMaterial( ability_icons[ ability ].def )
		
		if Charge < 100 then
			drawColor = Color( 100, 100, 100, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x, y - 32, size * 1.7, size * 1.7 )
		else
			drawColor = Color( 255, 255, 255, 255 )
			surface.SetDrawColor( drawColor )
			DrawCenteredRect( x, y - 32, ultsize, ultsize )
		end
		
	else // Active
		drawColor = Color( 255, 255, 255, 255 )
		surface.SetMaterial( ability_icons[ ability ].cast )
		surface.SetDrawColor( drawColor )
		DrawCenteredRect( x, y - 32, ultsize, ultsize )
	end // end if Active
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x + 1, Txt2Y, T2Color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText( self.KB[ ability ], "MaranzoAbil_DefaultFont", x, TxtY, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
	
----------------------------
	// Variables
	-- local ChargeColor = Color(40,200,255,180) - Nice Blue
	local ChargeColor = Color(255,255,255,255)
	local FullChargeColor = Color(255,200,40,180)
	local x = ScrW() * 0.5
	local y = ScrH() - 120
	
	// Charge HUD Draw
	if Charge >= MASS.Ability.Substitution.MaxCharge then
		-- do nothing
	elseif !ACTIVE then // not max charge & not active
		-- Draw Charge %
		local ChargeText = Charge.."%"
		draw.SimpleText(ChargeText, "MaranzoAbil_UltimateFont", x + 12, ScrH() - 98, Color( 20, 20, 20, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText(ChargeText, "MaranzoAbil_UltimateFont" , x + 10, ScrH() - 100, ChargeColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	return true
  end

// Specifically draw crosshair
function SWEP:DoDrawCrosshair( x, y )	
	-- little box
    surface.SetDrawColor(0, 0, 0, 125)
    surface.DrawRect(x - 3, y - 3, 6, 6)
    
    surface.SetDrawColor(255, 255, 255, 150)
    surface.DrawRect( x - 2, y - 2, 4, 4)
	return true
end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Float", 2, "AA_CD" )
	self:NetworkVar( "Float", 3, "A1_CD" )
	self:NetworkVar( "Float", 4, "A2_CD" )
	self:NetworkVar( "Float", 5, "A3_CD" )
	
	self:NetworkVar( "Int", 0, "Charge" )
	
	self:NetworkVar( "String", 0, "Ability" )
	
	self:NetworkVar( "Bool", 0, "AA_Active" )
	self:NetworkVar( "Bool", 1, "A1_Active" )
	self:NetworkVar( "Bool", 2, "A2_Active" )
	self:NetworkVar( "Bool", 3, "A3_Active" )
	self:NetworkVar( "Bool", 4, "AU_Active" )
	self:NetworkVar( "Bool", 5, "IsCasting" )
	self:NetworkVar( "Bool", 6, "CastOnCrouch" )

end

function SWEP:UpdateNextIdle( ply )
	
	local ply = ply or self.Owner
	local vm = ply:GetViewModel()
	self:SetNextIdle( CurTime() + vm:SequenceDuration() / vm:GetPlaybackRate() )

end

local reloadToggle = false
local reloadTime = CurTime()
function SWEP:Reload()
	
	local curtime = CurTime()
	if curtime < reloadTime then return end
	reloadTime = curtime + 0.5
	-- Visual FX
	local anim					=	reloadToggle and "kunai_draw" or "kunai_holster"
	local vm 					= 	self.Owner:GetViewModel()
	local speed 				= 	GetConVarNumber( "sv_defaultdeployspeed" ) or 1
	local Duration				= 	vm:SequenceDuration() / speed
	local CD					=	reloadToggle and Duration or 1000000000
	local HoldType				=	reloadToggle and "knife" or "normal"
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	self:SetHoldType( HoldType )
	self:SetNextPrimaryFire( curtime + CD )
	self:SetNextSecondaryFire( curtime + CD )
	self:SetNextIdle( curtime + CD )
	
	reloadToggle = !reloadToggle
	self:SetIsCasting( reloadToggle )
	
	return false
end

// Primary Attack
local hideCheckDel = CurTime()
function SWEP:PrimaryAttack( right )
	
	local ply = self.Owner
	local vm = self.Owner:GetViewModel()
	
	self:SetHoldType( "knife" )
	self:SetAA_Active( true )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:SetNextMeleeAttack( CurTime() + 0.1 * self.ModDelay )
	
	local anim = "kunai_left"
	if ( vm:GetSequenceName( vm:GetSequence() ) == anim ) then anim = "kunai_right" end -- alternate swings
	local CD = self.SwingDelay1 * self.ModDelay
	self:SetAA_CD( CD )
	timer.Simple( CD, function()
		if self:IsValid() and !self:GetAA_Active() then self:SetAA_CD( 0 ) end
	end)
	self:SetNextPrimaryFire( CurTime() + CD )
	self:SetNextSecondaryFire( CurTime() + CD )
	
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	self:EmitSound( SwingSound )
	
	self:UpdateNextIdle()

end

// Secondary Attack
function SWEP:SecondaryAttack()
	
	-- Checks
	local A1_CD = self:GetA1_CD()
	local AA_CD = self:GetAA_CD()
	if ( A1_CD != 0 or AA_CD != 0 ) then return end
	
	-- Variables
	local ply = self.Owner
	local vm = self.Owner:GetViewModel()
	local anim = "kunai_throw"
	local CD = MASS.Ability.ThrowKn.Cooldown
	
	-- Set A1 CD
	self:SetA1_Active( true )
	self:SetA1_CD( CD )
	local itCD = CD
	timer.Create( "MASS.Ability.ThrowKunai.CD" .. ply:EntIndex(), 1, itCD, function()
		if self:IsValid() then
			CD = CD - 1
			if CD < 0 then CD = 0 end
			self:SetA1_CD( CD )
		else
			timer.Remove( "MASS.Ability.ThrowKunai.CD" .. ply:EntIndex() )
		end
	end)
	self:SetNextSecondaryFire( CurTime() + CD )
	
	-- Set AA CD
	self:SetAA_Active( true )
	CD = self.SwingDelay2 * self.ModDelay
	self:SetAA_CD( CD )
	timer.Create( "MASS.Ability.ThrowKunai.Cast" .. ply:EntIndex(), 1, CD, function()
		if self:IsValid() then self:SetAA_Active( false ) self:SetAA_CD( 0 ) end
	end)
	self:SetNextPrimaryFire( CurTime() + CD )
	
	-- Prep Ability
	self:SetHoldType( "melee" ) -- raise 3rd person arm
	local GoThrowKnife = 0.5 * self.ModDelay
	self:SetNextMeleeAttack( CurTime() + GoThrowKnife )
	if SERVER and self:GetA3_Active() then self:ConcealmentUnHide( ply, self ) end -- unhide if concealed
	
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	
	self:UpdateNextIdle()
	
end // end Secondary Attack

// Set Tracer Origin
function SWEP:GetTracerOrigin()
	local origin = self.Owner:GetShootPos() - Vector( 0, 0, 2 )
	return origin
end

function SWEP:DealDamage( ability )
	
	if !IsFirstTimePredicted() then return end
	
	local vm = self.Owner:GetViewModel()
	local anim = vm:GetSequenceName( vm:GetSequence() )
	local ply = self.Owner
	
	self.Owner:LagCompensation( true )
	
	
	if (!ability) then
	
		local trace = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		} )
	
		if ( !IsValid( trace.Entity ) ) then
			trace = util.TraceHull( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
				filter = self.Owner,
				mins = Vector( -10, -10, -8 ),
				maxs = Vector( 10, 10, 8 ),
				mask = MASK_SHOT_HULL
			} )
		end // end Hull Trace

		-- Because SWEP:Think is ran shared in SP
		if ( SERVER and trace.Hit ) then
			local randSound = math.random( 1, 20 )
			local randPitch = math.random( 80, 130 )
			if randSound > 5 then randSound = HitSound elseif
			randSound == 5 then randSound = HitSoundSquish else
				randSound = HitSoundHard
				randPitch = math.random( 80, 120 )
			end
			self.Owner:EmitSound( randSound, 75, randPitch )
		end
		
		self.Hit = false


		if ( SERVER && IsValid( trace.Entity ) ) then
		
			local phys = trace.Entity:GetPhysicsObject()
			if ( IsValid( phys ) ) then
				phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass(), trace.HitPos )
			end
			
			if ( SERVER && IsValid( trace.Entity ) && ( trace.Entity:IsNPC() || trace.Entity:IsPlayer() || trace.Entity:Health() > 0 ) ) then
				
				if ( ( trace.Entity:IsNPC() || trace.Entity:IsPlayer() ) && !trace.Entity:IsLagCompensated() ) then
					trace.Entity:SetLagCompensated( true )
				end
				
				local dmginfo = DamageInfo()
				local attacker = self.Owner
				if ( !IsValid( attacker ) ) then attacker = self end
		
				dmginfo:SetAttacker( attacker )
				dmginfo:SetInflictor( self )
				dmginfo:SetDamage( self.Primary.Damage * self.ModDmg )
		
				if ( anim == "kunai_left" ) then
					dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 + self.Owner:GetForward() * 9998 )
				elseif ( anim == "kunai_right" ) then
					dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
				end
		
				trace.Entity:TakeDamageInfo( dmginfo )
				
				self.Hit = true
				local charge = self:GetCharge() + 3
				self:SetCharge( charge )
				self.HitTime = CurTime()
		
			end // end if Entity is Player or NPC or Health > 0
		end // end if Server & Entity
		
		self.Owner:LagCompensation( false )
	
	elseif ability == ASWEP_Ability_ThrowKunai then // end if Auto Attack
	
		trace = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.Secondary.MaxDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
		
		if SERVER and IsValid( trace.Entity ) && ( trace.Entity:IsNPC() || trace.Entity:IsPlayer() ) && !trace.Entity:IsLagCompensated() then
			trace.Entity:SetLagCompensated( true )
		end
		
		local Bullet = {}
			Bullet.Attacker = 	self.Owner
			Bullet.Num		=	1
			Bullet.Src		=	ply:GetShootPos()
			Bullet.Dir		=	ply:GetAimVector()
			Bullet.Distance	=	self.Secondary.MaxDistance
			Bullet.HullSize =	10
			Bullet.Spread	=	Vector( self.Primary.Spread, self.Primary.Spread, 0 )
			Bullet.Tracer	=	1 -- Tracer every bullet
			Bullet.TracerName	= "AirboatGunHeavyTracer"
			Bullet.Force	=	1
			Bullet.Damage	=	self.Primary.Damage
			Bullet.AmmoType	=	"" -- No ammo type
			Bullet.Callback = function( attacker, tr, dmginfo )
	
		self.Hit = false
		dmginfo:SetInflictor( self )
		
		-- Do Ability
		self:ThrowKunai( tr.Entity )
		/*ParticleEffect( "ice_impact_heavy", tr.Entity:GetPos(), self:GetAngles() )*/
		dmginfo:SetDamage( MASS.Ability.ThrowKn.Damage * self.ModDmg )
		
		if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
			
			local randPitch = math.random( 70, 130 )
			tr.Entity:EmitSound( HitSound, 90, randPitch )
			
			if ( !IsValid( attacker ) ) then attacker = self end
			dmginfo:SetDamageType( DMG_GENERIC )
			dmginfo:SetDamageForce( self.Owner:GetForward() * 10500 )
			
			-- Set a static amount of damage
			tr.Entity:TakeDamageInfo( dmginfo )
			
			-- Set Charge & Hit
			self.Hit = true
			local charge = self:GetCharge() + dmginfo:GetDamage()/10 
			self:SetCharge( charge )
			self.HitTime = CurTime()
			
			-- Nullify bullet damage
			dmginfo:SetDamage( 0 )
			dmginfo:SetDamageType( DMG_FALL )
			dmginfo:SetInflictor( tr.Entity )
			dmginfo:SetAttacker( tr.Entity )
			
	
		end // end if Server & Entity
		
		end // end callback function
		
		self.Owner:FireBullets( Bullet )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
		
		if CLIENT then
			ply:EmitSound( SwingSound )
			 
			-- Hide World Model Client-side
			function self:DrawWorldModel() return false end
			timer.Simple( self.SwingDelay1 * self.ModDelay, function() 
				if ply:IsValid() and self:IsValid() then 
					function self:DrawWorldModel() self:DrawModel() end
				end 
			end)
			
		else -- if Server
			local randPitch = math.random( 110, 140 )
			ply:EmitSound( MASS.Ability.ThrowKn.SoundCast, 70, randPitch )
			
			self.Owner:DrawWorldModel( false )
			timer.Simple( self.SwingDelay1 * self.ModDelay, function() 
				if ply:IsValid() and self:IsValid() then 
					ply:DrawWorldModel( true ) 
					self:SetHoldType( "knife" )
				end 
			end)
		end
	
		self.Owner:LagCompensation( false )
		
	end // end Ability 1: Throw Kunai

end // end DealDamage Function

//// Throw Kunai ////
function SWEP:ThrowKunai( target )
	
	local ply	=	self.Owner
	local CD	=	self:GetA1_CD()
	
	if SERVER then
		if ply:IsValid() and ply:Alive() and CD > 0 then
			// Ply Effect
			
			if target:IsValid() and ( target:IsNPC() or target:IsPlayer() ) then
				
				//Effect
				local Origin = target:GetPos() + Vector(0,0,1)
				playEffect( Origin, target, 1, "bloodspray", 1, 5, 1 )
				local randPitch = math.random( 80, 100 )
				target:EmitSound( MASS.Ability.ThrowKn.SoundHit, 75, randPitch )
				target:EmitSound( MASS.Ability.ThrowKn.SoundCast, 70, 120 )
			
			end // end if target
		end // end if ply
	end // end If Server
	
end // end Throw Kunai Ability

//// Ninja Dash ////
function SWEP:NinjaDash( ply, self, Wep )
	
	local ply	=	ply or self.Owner
	local Wep 	=	Wep or ply:GetActiveWeapon()
	local CD	=	self:GetA2_CD()
	
	if ply:IsValid() and ply:Alive() and CD > 0 and self:GetA2_Active() then
	local Wep = ply:GetActiveWeapon()
		
		if Wep and Wep:GetClass() == "weapon_kunainormal" then
	
			-- Set Networked Values
			local speed = MASS.Ability.NinjaDash.DashSpeed
			local maxDist = MASS.Ability.NinjaDash.DashDistance
			local legs = MASS.Ability.NinjaDash.Legs
			if legs then 
				ply:ConCommand( "cl_legs 0" )
			end
			
			local hullTrace = util.TraceHull({
				start = ply:EyePos(),
				endpos = ply:EyePos() + ply:EyeAngles():Forward() * maxDist,
				filter = ply,
				mins = Vector(-16, -16, 0),
				maxs = Vector(16, 16, 9)
			})
			
			local groundTrace = util.TraceEntity({
				start = hullTrace.HitPos + Vector(0, 0, 1),
				endpos = hullTrace.HitPos - ( ply:EyePos() - ply:GetPos() ),
				filter = ply
			}, ply)
		
			local endPos = groundTrace.HitPos
			local startPos = ply:GetPos()
			local dashDist = (endPos - ply:EyePos()):Length()
			local moveTime = dashDist / speed -- Move Time
			local dashDir = ( endPos - ply:GetPos() ):GetNormalized() -- Direction
			local startTime = CurTime() -- Start Time
			
			local randPitch = math.random( 90, 110 )
			ply:EmitSound( MASS.Ability.NinjaDash.SoundCast, 70, randPitch )
		
			local CD = 1 -- in seconds
		
			hook.Add( "Move", "MASS.Ability.NinjaDash.Cast" .. ply:EntIndex(), function( ent, data )
				if ent != ply then return end
				if ply:IsValid() and Wep:IsValid() and self:GetA2_Active() then
					// Weapon Check
					if ( Wep:GetClass() != "weapon_kunainormal" ) then
						self:SetA2_Active( false )
						return
					end
					// Try to convince the player to crouch
						data:SetButtons( bit.bor( data:GetButtons(), IN_DUCK ) )
					
					// Define Variables
						local timeElapsed = CurTime() - startTime
						local NewDir = dashDir * math.min( ( math.min( timeElapsed, moveTime ) * speed ), dashDist )
						local NewPos = startPos + NewDir
					
					// Set Origin based on Time
						data:SetOrigin( NewPos )
						data:SetVelocity( vector_origin )
					
					// Finish Movement
						if ( timeElapsed >= moveTime ) then
							self:SetIsCasting( false )
							self:SetA2_Active( false )
							data:SetVelocity( NewDir * 0.5 )
							data:SetOrigin( endPos )
							hook.Remove( "Move", "MASS.Ability.NinjaDash.Cast" .. ply:EntIndex() )
						end;
					
			
					return true -- Dont Move the normal way!
				else // not valid or inactive
					hook.Remove( "Move", "MASS.Ability.NinjaDash.Cast" .. ply:EntIndex() )
				end
			end) // end Move Hook
			
			-- Negate fall damage	
			hook.Add("EntityTakeDamage", "MASS.Ability.NinjasKunai.OnTakeFallDamage" .. ply:EntIndex(), function( ent, DmgInfo )
			
				if ent == ply then
					if Wep:IsValid() then 
						if DmgInfo:IsFallDamage() then 
							DmgInfo:SetDamage( 0 ) 
							timer.Remove( "MASS.Ability.NinjasKunai.OnTakeFallDamage" .. ply:EntIndex() )
							hook.Remove( "EntityTakeDamage", "MASS.Ability.NinjasKunai.OnTakeFallDamage" .. ply:EntIndex() )
						end
					else 
						timer.Remove( "MASS.Ability.NinjasKunai.OnTakeFallDamage" .. ply:EntIndex() )
						hook.Remove( "EntityTakeDamage", "MASS.Ability.NinjasKunai.OnTakeFallDamage" .. ply:EntIndex() )
						return
					end
				end
			end)
			
			-- Remove fall damage negation 
			timer.Create( "MASS.Ability.NinjasKunai.OnTakeFallDamage" .. ply:EntIndex(), 3, 1, function()
				hook.Remove( "EntityTakeDamage", "MASS.Ability.NinjasKunai.OnTakeFallDamage" .. ply:EntIndex() )
				hook.Remove( "GetFallDamage", "MASS.Ability.NinjaDash.FallDamage" .. ply:EntIndex() )
			end )
			
			-- Countdown CD
			local CD = MASS.Ability.NinjaDash.Cooldown
			self:SetA2_CD( CD )
			local itCD = CD
			timer.Create( "MASS.Ability.NinjaDash.CD" .. ply:EntIndex() , 1, itCD, function()
				if Wep:IsValid() then
					CD = CD - 1
					self:SetA2_CD( CD )
				else
					timer.Remove( "MASS.Ability.NinjaDash.CD" .. ply:EntIndex() )
				end
			end)
		end // if Wep is Valid & Kunai
	end // end if ply
end // end Ninja Dash Ability

//// Concealment Ability ////
function SWEP:Concealment( ply, self, Wep )
	-- variable check
	local ply	=	ply or self.Owner
	local Wep	=	Wep or ply:GetWeapon( "weapon_kunainormal" )
	
	if SERVER and ply:IsValid() and ply:Alive() and Wep:IsValid() then 
		local CD	=	self:GetA3_CD()
		if CD == MASS.Ability.Conceal.Cooldown + 2 then
			self:SetIsCasting( false )
			self:SetCastOnCrouch( false )
			self:SetA3_CD( MASS.Ability.Conceal.Cooldown )
			ply:EmitSound( MASS.Ability.Conceal.SoundCast, 70, 100 )
			ply:SetNoDraw( true )
			ply:SetRenderMode(RENDERMODE_TRANSALPHA)
			ply:SetColor( Color(0, 0, 0, 0 ) )
			function self:DrawWorldModel() return false end
			ply:DrawWorldModel( false )
			ply:SetNoTarget( true )
			
			hook.Add("EntityTakeDamage", "MASS.Ability.Concealment.Hidden" .. ply:EntIndex(), function( ent, DmgInfo )
			
				if ent == ply then
					if Wep:IsValid() then 
						if DmgInfo:IsFallDamage() then DmgInfo:ScaleDamage( 0.5 ) return end
						if self:GetA3_Active() == true then
							self:ConcealmentUnHide( ply, self, Wep )
							hook.Remove( "EntityTakeDamage", "MASS.Ability.Concealment.Hidden" .. ply:EntIndex() )
						else
							hook.Remove( "EntityTakeDamage", "MASS.Ability.Concealment.Hidden" .. ply:EntIndex() )
						end
					else -- !Wep 
						// Return to normal
						ply:EmitSound( MASS.Ability.Conceal.SoundEnd, 70, 100 )
						ply:SetNoDraw( false )
						ply:DrawShadow()
						ply:SetRenderMode(RENDERMODE_NORMAL)
						ply:SetColor( Color( 255, 255, 255, 255 ) )
						function self:DrawWorldModel() return self:DrawModel() end
						ply:DrawWorldModel( true )
						ply:SetNoTarget( false )
						hook.Remove( "EntityTakeDamage", "MASS.Ability.Concealment.Hidden" .. ply:EntIndex() )
						return
					end
				end // end ent == ply
			end)
			
			local uhDur = MASS.Ability.Conceal.Duration -- time in seconds
			local uhDel = 0.2 -- Delay desired
			local uhIt = uhDur / uhDel -- number of iterations desired
			timer.Create( "MASS.Ability.Concealment.UnHide" .. ply:EntIndex(), uhDel, uhIt, function()
				uhIt = uhIt - 1
				if ply:IsValid() and ply:Alive() then
					if Wep:IsValid() then
						if self:GetA3_Active() then
							
							// Check for people around you!
							local canCast = true
							local targets = ents.FindInSphere( ply:GetPos(), 150 )
							for k, v in ipairs( targets ) do
								if ( ( v:IsPlayer() and !ply ) or v:IsNPC() ) then
									canCast = false
									self:ConcealmentUnHide( ply, self, Wep )
									timer.Remove( "MASS.Ability.Concealment.UnHide" .. ply:EntIndex() )
									break
								end
							end
							
							// Check if timer done
							if uhIt == 0 then
								self:ConcealmentUnHide( ply, self, Wep )
							end
						else // !A3Active, remove
							timer.Remove( "MASS.Ability.Concealment.UnHide" .. ply:EntIndex() )
						end // end A3 not Active
							
					else // else !Wep
						// Return to normal
						ply:EmitSound( MASS.Ability.Conceal.SoundEnd, 70, 100 )
						ply:SetNoDraw( false )
						ply:SetRenderMode(RENDERMODE_NORMAL)
						ply:SetColor( Color( 255, 255, 255, 255 ) )
						function self:DrawWorldModel() return self:DrawModel() end
						ply:DrawWorldModel( true )
						ply:SetNoTarget( false )
						timer.Remove( "MASS.Ability.Concealment.UnHide" .. ply:EntIndex() )
						hook.Remove( "EntityTakeDamage", "MASS.Ability.Concealment.Hidden" .. ply:EntIndex() )
					end
				end // end if Ply check
				
			end ) // end Timer
			ply:ChatPrint( "[MASS] Ninja's Kunai: You are now concealed." )
		end // end if CD = CD + 2 
	end // end If Server and Checks
	
end // end Concealment Ability

function SWEP:ConcealmentUnHide( ply, self, Wep )
	-- variable check
	local ply	=	ply or self.Owner
	local Wep	=	Wep or ply:GetWeapon( "weapon_kunainormal" )
	
	if SERVER and ply:IsValid() and ply:Alive() then 
		if Wep:IsValid() and self:GetA3_Active() then
			self:SetA3_Active( false )
			function self:DrawWorldModel() return self:DrawModel() end
		
			-- Countdown CD
			local CD = MASS.Ability.Conceal.Cooldown
			self:SetA3_CD( CD )
			local itCD = CD
			timer.Create( "MASS.Ability.Concealment.CD" .. ply:EntIndex() , 1, itCD, function()
				if Wep:IsValid() then
					CD = CD - 1
					if CD < 1 then CD = 0 end
					self:SetA3_CD( CD )
				else
					timer.Remove( "MASS.Ability.Concealment.CD" .. ply:EntIndex() )
				end
			end)
		end
		
		// Return to normal
		ply:EmitSound( MASS.Ability.Conceal.SoundEnd, 70, 100 )
		ply:SetNoDraw( false )
		ply:ChatPrint( "[MASS] Ninja's Kunai: You are no longer concealed." )
		ply:SetRenderMode(RENDERMODE_NORMAL)
		ply:SetColor( Color( 255, 255, 255, 255 ) )
		function self:DrawWorldModel() return self:DrawModel() end
		ply:DrawWorldModel( true )
		ply:SetNoTarget( false )
		hook.Remove( "EntityTakeDamage", "MASS.Ability.Concealment.Hidden" .. ply:EntIndex() )
	end // end SERVER & Checks
	
end


///// ULTIMATE ABILITY /////
function SWEP:Substitution( ply )
	
	local ply = ply or self.Owner
	
	local Charge = self:GetCharge()
	
	if Charge >= 100 then -- ULTIMATE Ability
		if !self:GetIsCasting() and ply:IsValid() and ply:Alive() then
			// Prevent other abilities
			self:SetAU_Active( true )
			self:SetIsCasting( true )
			
			// Define variables
			local timeset	 			= 	0
			local vel 					= 	ply:GetVelocity()
			local vm 					= 	ply:GetViewModel()
			local anim					=	"kunai_ultimate"
			local speed 				= 	GetConVarNumber( "sv_defaultdeployspeed" ) or 1
			local Duration 				= 	vm:SequenceDuration() / speed
			local Wep					=	ply:GetActiveWeapon()
			--local Origin 				= 	ply:GetPos() + Vector( 0, 0, 1 )
			--local Origin2 				= 	ply:GetShootPos()
			
			// ViewModel + Prevent Attacks
			vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
			self:UpdateNextIdle( ply )
			Wep:SetNextPrimaryFire( CurTime() + Duration )
			Wep:SetNextSecondaryFire( CurTime() + Duration )
			
			// Initial Action & FX
			self:SetCharge( 0 )
			MASS.Ability.Substitution.MarkedPos = ply:GetPos()
			MASS.Ability.Substitution.MarkedAngles = ply:EyeAngles()
			ply:EmitSound( MASS.Ability.Substitution.SoundCast )
			
			-- Fn for Returning to Pos
			local function Substitute( victim, death )
				hook.Add( "Tick", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex(), function()
					if victim:IsValid() and victim:Alive() then
						
						-- FX
						local Origin 		= 	victim:GetPos() + Vector( 0, 0, 10 )
						playEffect( Origin, victim, 3, "WheelDust", 5, 4, 10 )
						victim:EmitSound( MASS.Ability.Substitution.SoundHit, 80, 100 )
						
						-- Ability
						hook.Remove( "Tick", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex() )
						victim:SetPos( MASS.Ability.Substitution.MarkedPos )
						victim:SetEyeAngles( MASS.Ability.Substitution.MarkedAngles )
						victim:SetVelocity( -victim:GetVelocity() ) -- negate velocity
						MASS.Ability.Substitution.MarkedPos 		= 	vector_origin
						MASS.Ability.Substitution.MarkedAngles 	= 	vector_origin
						if Wep:IsValid() then
							victim:EmitSound( MASS.Ability.Substitution.SoundEnd, 60, 100 )
							self:SetAU_Active( false )
						end
						
					else // ply valid & alive
						hook.Remove( "Tick", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex() )
					end
				end )
			end
			
			-- Negate any damage	
			hook.Add("EntityTakeDamage", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex(), function( ent, DmgInfo )
				if ent == ply then
					if Wep:IsValid() then 
						if DmgInfo:GetDamage() > 0 then
							DmgInfo:SetDamage( 0 )
							if self:GetA2_Active() then
								self:SetA2_Active( false )
								self:SetIsCasting( false )
								hook.Remove( "Move", "MASS.Ability.NinjaDash.Cast" .. ply:EntIndex() )
							end
							hook.Remove( "EntityTakeDamage", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex() )
							hook.Remove( "PlayerDeath", "MASS.Ability.Substitution.OnDeath" .. ply:EntIndex() )
							Substitute( ply )
							return true
						end
					else  -- !Wep
						hook.Remove( "EntityTakeDamage", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex() )
						hook.Remove( "PlayerDeath", "MASS.Ability.Substitution.OnDeath" .. ply:EntIndex() )
						return
					end
				end // end if Ent == Ply
			end) // end Hook: Entity Take Damage -- Subst
			
			-- Warn of Death
			hook.Add( "PlayerDeath", "MASS.Ability.Substitution.OnDeath" .. ply:EntIndex(), function( ent, infl, atk )
				if ent == ply and ent != atk then
					ply:ChatPrint( " " )
					ply:ChatPrint( "[MASS] Ninja's Kunai: That special attack managed to hit you through your substitution. Avoid getting hit by any more of those." )
					local time = 3
					timer.Simple( time, function()
						if ply:IsValid() and timer.Exists( "MASS.Ability.Substitution.Death" .. ply:EntIndex() ) then
							ply:ChatPrint( " " )
							ply:ChatPrint( "[MASS] Ninja's Kunai: If you get another Ninja's Kunai in 30 seconds you will receive an 80% recharge." )
						end
					end)
					local iterations = 0
					local maxIt = 30 + time
					timer.Create( "MASS.Ability.Substitution.Death" .. ply:EntIndex(), 1, maxIt, function()
						iterations = iterations + 1
						if ply:IsValid() and ply:Alive() then -- if Ply
							local SWEP = ply:GetWeapon( "weapon_kunainormal" )
							if SWEP:IsValid() then
								SWEP:GetTable():SetCharge( 80 )
								timer.Remove( "MASS.Ability.Substitution.Death" .. ply:EntIndex() )
								hook.Remove(  "PlayerDeath", "MASS.Ability.Substitution.OnDeath" .. ply:EntIndex() )
								ply:ChatPrint( " " )
								ply:ChatPrint( "[MASS] Ninja's Kunai: You received an 80% recharge." )
							elseif iterations >= maxIt then -- no SWEP & iteration up
								timer.Remove( "MASS.Ability.Substitution.Death" .. ply:EntIndex() )
								hook.Remove(  "PlayerDeath", "MASS.Ability.Substitution.OnDeath" .. ply:EntIndex() )
							end
						elseif iterations >= maxIt then -- no Ply & iteration up
							timer.Remove( "MASS.Ability.Substitution.Death" .. ply:EntIndex() )
							hook.Remove(  "PlayerDeath", "MASS.Ability.Substitution.OnDeath" .. ply:EntIndex() )
						end
					end ) // end Death & Regain timer
				end // end if Ent == Ply
			end ) // end Death Hook
			
			-- Remove damage & kill negation
			
			
			// Ability Cast
			timer.Simple( Duration, function() 
				if Wep:IsValid() then
					-- Deactivate cast lock, not ability
					self:SetIsCasting( false )
				end
			end ) // end Deactivation
			
			
		end // end if Is Casting
	else // end if charge 100%
		if Maranzos_AbilitySWEPs.BMS_InfUlt then
			self:SetCharge( 100 )
		end
	end
	return true
end

// Dropped Weapon
function SWEP:OnDrop()

	self:Remove() -- You can't drop a soul

end

// Holster
function SWEP:Holster()
	local ply = self.Owner
	-- Prevent abilities from working if weapon switched to prevent abuse
	if SERVER and ( self:GetA2_Active() or self:GetA3_Active() or self:GetAU_Active() ) then
		self.Owner:ChatPrint( "[MASS] Ninja's Kunai: Ability Canceled - Weapon not active")
	end
	reloadToggle = false
	self:SetCastOnCrouch( false )
	self:SetA2_Active( false )
	if self:GetA2_CD() > MASS.Ability.NinjaDash.Cooldown then self:SetA2_CD( 0 ) end
	if self:GetA3_Active() and self:GetA3_CD() <= MASS.Ability.Conceal.Cooldown then self:ConcealmentUnHide( ply, self ) else -- UnHide if Hidden
		self:SetA3_Active( false )
		if self:GetA3_CD() > MASS.Ability.Conceal.Cooldown then self:SetA3_CD( 0 ) end
	end
	self:SetAU_Active( false )
	hook.Remove( "EntityTakeDamage", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex() )
	hook.Remove( "PlayerDeath", "MASS.Ability.Substitution.OnTakeDamage" .. ply:EntIndex() )
	self:SetIsCasting( false )
	return true
	
end

// Weapon Info
function SWEP:PrintWeaponInfo(x, y, alpha)

	if (self.DrawWeaponInfoBox == false) then return end

	if (self.InfoMarkup == nil) then
		local str
		local title_color = "<color = 255, 200, 0, 255>"
		local hl_color = "<color = 247, 168, 32, 200>"
		local text_color = "<color = 255, 255, 255, 200>"
		
		str = "<font=DermaDefaultBold>"
		if (self.Author != "") then str = str .. title_color .. "Author:</color>\t" .. text_color .. self.Author .. "</color>\n" end
		if (self.Contact != "") then str = str .. title_color .. "Contact:</color>\t" .. text_color .. self.Contact .. "</color>\n\n" end
		if (self.Purpose != "") then str = str .. title_color .. "Purpose:</color>\n" .. text_color .. self.Purpose .. "</color>\n\n" end

		-- Set the instructions
		if (self.Instructions != "") then str = str .. title_color .. "Instructions:</color>\n"
			local myInstr = self.Instr
			for i = 1, table.Count(myInstr) do
				local HL = myInstr["H"..i]
				local TL = myInstr[""..i]
				if ( HL != nil ) then
					str = str .. hl_color .. HL .. text_color .. TL .. "\n"
					table.remove( myInstr, i )
					table.remove( myInstr, tostring(i) )
				elseif TL != nil then -- If No Headline, then Check Text Line
					str = str .. text_color .. TL .. "\n"
				end
			end
		end // end of Instructions
		str = str .. "</font>"
		
		self.InfoMarkup = markup.Parse(str, 250)
	end
	
	local outerColor 	= 	Color( 0, 100, 165, 255 )
	local innerColor 	= 	Color( 0, 130, 200, 255 )
	
	surface.SetDrawColor(outerColor)
	surface.SetTexture(self.SpeechBubbleLid)
	surface.DrawTexturedRect(x, y - 69.5, 128, 64) 
	draw.RoundedBox(8, x - 5, y - 6, 260, self.InfoMarkup:GetHeight() + 18, outerColor)
	draw.RoundedBox(8, x - 2, y - 3, 254, self.InfoMarkup:GetHeight() + 12, innerColor)
	
	self.InfoMarkup:Draw(x + 5, y + 5, nil, nil, alpha)
end

// Deployed Weapon
function SWEP:Deploy()
	
	local speed = GetConVarNumber( "sv_defaultdeployspeed" ) or 1
	local vm = self.Owner:GetViewModel()
	vm:SetPlaybackRate( speed )
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "kunai_draw" ) )
	local dur = vm:SequenceDuration() / speed
	self:SetNextPrimaryFire( CurTime() + dur )
	self:SetNextSecondaryFire( CurTime() + dur )
	self:UpdateNextIdle()

	if ( SERVER ) then
		-- do nothing
	else // Client
		self.DrawCrosshair		= 	GetConVar( "cl_mas_crosshairon" ):GetBool()
	end
	
	return true

end // end Fn Deploy

// Weapons Think Too
function SWEP:Think()
	
	local ply = self.Owner
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	
	// Singleplayer Button Check
	if CLIENT and game.SinglePlayer() then
		
		if !vgui.CursorVisible() and !vgui.GetKeyboardFocus() and self.KB then
		
			local Wep = ply:GetActiveWeapon()
			if !( ply:IsValid() and ply:Alive() and Wep:IsValid() and Wep:GetClass() == "weapon_kunainormal" ) then return end
			
			for btn, ability in pairs( self.KB["Btn"] ) do
				if ability != 1 and ability != 2 then
					if ( input.IsButtonDown( btn ) ) and !table.HasValue( keysDown, btn ) then
						table.insert( keysDown, btn )
						
						if ( ply:IsValid() and ply:Alive() and Wep:IsValid() and Wep:GetClass() == "weapon_kunainormal" ) then
							-- AutoAttack & Ability #1:Throw Kunai are bound to +attack & +attack2 by default & won't trigger anything here.
							
							if ability == ASWEP_Ability_NinjaDash then 
							// Abil 2: Ninja Dash
								local CD = MASS.Ability.NinjaDash.Cooldown
								if ( self:GetA2_Active() or self:GetIsCasting() or self:GetA2_CD() != 0 ) then 
									return 
								end
								self:SetIsCasting( true )
								
								net.Start( "Maranzo_AbilitySWEP_ninjaskunai_Castt" )
								net.WriteInt( ability, 4 )
								net.SendToServer()
								
							elseif ability == ASWEP_Ability_Concealment then 
							// Abil 3: Concealment
								local CD = MASS.Ability.Conceal.Cooldown
								if ( !( self:GetA3_Active() or self:GetA3_CD() == CD + 2 ) and ( self:GetIsCasting() or self:GetA3_CD() != 0 ) ) then 
									return 
								end
								self:SetIsCasting( true )
								
								net.Start( "Maranzo_AbilitySWEP_ninjaskunai_Castt" )
								net.WriteInt( ability, 4 )
								net.SendToServer()
								
							elseif ability == ASWEP_Ability_Substitution then 
							// Ultimate: Substitution
								if ( self:GetIsCasting() or self:GetAU_Active() ) then 
									return -- do nothing
								end
								
								self:SetIsCasting( true )
								
								net.Start( "Maranzo_AbilitySWEP_ninjaskunai_Castt" )
								net.WriteInt( ability, 4 )
								net.SendToServer()
								
							end // end Key Check
							
							if ability == ASWEP_Ability_Select then
							// Ability Selection
								self:DrawAbilitySelection()
								
							end // end Key check, cursor visible OK <-- Not set currently for SP
							
						end // end if ply & alive & weapon
						
					elseif !( input.IsButtonDown( btn ) ) and table.HasValue( keysDown, btn ) then
						table.RemoveByValue( keysDown, btn )
					end // end Btn Release
				end // end Exclude AA & A1
			end // end For Btn check
		end // end  if !Mouse Visible
	end // end SinglePlayer
	
	if ( idletime > 0 && curtime > idletime ) then
		
		--vm:SendViewModelMatchingSequence( vm:LookupSequence( "kunai_idle0" .. math.random( 1, 2 ) ) )
		vm:SendViewModelMatchingSequence( vm:SelectWeightedSequence( ACT_VM_IDLE ) )
		self:UpdateNextIdle()
	
	end

	local meleetime = self:GetNextMeleeAttack()
	if ( meleetime > 0 && curtime > meleetime ) then

		self:SetNextMeleeAttack( 0 )
		self:SetAA_Active( false )
		
		-- If Ability 1: Throw Kunai
		if ( self:GetA1_Active() ) then 
			
			-- Do Throw Kunai
			self:DealDamage( ASWEP_Ability_ThrowKunai )
			self:SetA1_Active( false )
			
		else // end if an ability
			self:DealDamage()
		end // end regular attack

	end // end Melee Time
	
	// Ability 3: Concealment Checks
	if SERVER then
		local A3Active = self:GetA3_Active()
		if A3Active then
			local isCasting = self:GetIsCasting()
			local CastOnCrouch = self:GetCastOnCrouch()
			if CastOnCrouch and isCasting then
				if ply:Crouching() then
					local canCast = true
					local targets = ents.FindInSphere( ply:GetPos(), 150 )
					for k, v in ipairs( targets ) do
						if ( ( v:IsPlayer() and !ply ) or v:IsNPC() ) then
							canCast = false
							ply:ChatPrint( "[MASS] Ninja's Kunai: You are too close to someone." )
							self:SetCastOnCrouch( false )
							self:SetIsCasting( false )
							self:SetA3_Active( false )
							self:SetA3_CD( 0 )
							break
						end
					end
					if canCast then
						self:SetCastOnCrouch( false )
						self:SetIsCasting( false )
						local Wep = ply:GetActiveWeapon()
						self:Concealment( ply, self, Wep )
					end
				end
			// !CastOnCrouch, check if standing or ply casts an ability
			elseif !ply:Crouching() then
				// Deactivate & Cooldown
				self:ConcealmentUnHide( ply, self, Wep )
			end
		end // end A3Active
	end
	
end // end SWEP think


----------------------------------------------------------------------
---- Net Usage

if (SERVER) then
	
	util.AddNetworkString( "Maranzo_AbilitySWEP_ninjaskunai_Castt" )
	util.AddNetworkString( "Maranzo_AbilitySWEP_ninjaskunai_CastCancell" )

	// Run the real ability server-side
	net.Receive( "Maranzo_AbilitySWEP_ninjaskunai_Castt", function( len, ply )
		
		if ( IsValid( ply ) and ply:Alive() and ply:GetActiveWeapon():GetClass() == "weapon_kunainormal" ) then
			local ability = net.ReadInt( 4 )
			local Wep = ply:GetActiveWeapon()
			local SWEP = Wep:GetTable()
				
			if ability == ASWEP_Ability_NinjaDash then 
				if ( !SWEP:GetA2_Active() and !SWEP:GetIsCasting() and SWEP:GetA2_CD() == 0 ) then 
					local CD = MASS.Ability.NinjaDash.Cooldown
					SWEP:SetA2_Active( true )
					SWEP:SetA2_CD( CD + 2 ) -- +2 to alert the think
					SWEP:SetIsCasting( true )
					SWEP:NinjaDash( ply, SWEP, Wep )
					
				end // end Ninja Dash
				
			elseif ability == ASWEP_Ability_Concealment then 
				local CD = MASS.Ability.Conceal.Cooldown
				if ( !SWEP:GetA3_Active() ) then
					if ( !SWEP:GetIsCasting() and SWEP:GetA3_CD() == 0 ) then
						-- Prevent more Abilities
						SWEP:SetA3_Active( true )
						SWEP:SetIsCasting( true )
						SWEP:SetCastOnCrouch( true )
						
						-- Cooldown Active
						SWEP:SetA3_CD( CD + 2 )
						// Do not Timer Cooldown until it has been cast via Think
						
					end // end if !Casting and CD == 0
					
				elseif SWEP:GetA3_CD() == CD + 2 then // if it IS active & CD + 2
					SWEP:SetA3_Active( false )
					SWEP:SetIsCasting( false )
					SWEP:SetCastOnCrouch( false )
					SWEP:SetA3_CD( 0 )
				end // end Concealment
				
			elseif ability == ASWEP_Ability_Substitution then 
				
				if ( !SWEP:GetAU_Active() and !SWEP:GetIsCasting() ) then
					SWEP:Substitution( ply )
				end
				
			end
			
		end // end If Ply & Weapon
		
	end ) // end Net Receive
	
end

if (CLIENT) then

	net.Receive( "Maranzo_AbilitySWEP_ninjaskunai_Castt", function( len, ply )
		
		local ply = LocalPlayer()
		local Wep = ply:GetActiveWeapon()
		local SWEP = Wep:GetTable()
		
		if ( IsValid( ply ) and ply:Alive() and ply:GetActiveWeapon():GetClass() == "weapon_kunainormal" ) then
			local ability = net.ReadInt( 4 )
			
			if ability == ASWEP_Ability_NinjaDash then 
				
				chat.AddText( "No Legs!" )
				local started = net.ReadBool()
				local legs = "cl_legs "
				local legsNum = started and 0 or MASS.Ability.NinjaDash.LegsNum
				ply:ConCommand( legs .. legsNum )
				
			elseif ability == ASWEP_Ability_Concealment then 
				-- Do nothing right now
				
			elseif ability == ASWEP_Ability_Substitution then 
				-- Do nothing
				
			end
			
		end // end If Ply & Weapon
		
	end ) // end Net Receive
	
	
	
end