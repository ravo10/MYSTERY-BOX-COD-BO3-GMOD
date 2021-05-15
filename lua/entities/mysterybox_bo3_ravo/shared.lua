util.PrecacheModel("models/mysterybox_bo3_ravo/mysterybox_bo3_ravo.mdl")

-- Particles
game.AddParticles("particles/mysterybox_bo3_ravo.pcf")

PrecacheParticleSystem("blaa_take")
PrecacheParticleSystem("blaa_take2")
PrecacheParticleSystem("lyn_lys")
PrecacheParticleSystem("lyn_lys2")
PrecacheParticleSystem("lyn_lys3")
PrecacheParticleSystem("lyn_ned")

ENT.Type                    = "anim"
ENT.Base                    = "base_anim"
ENT.PrintName               = "Mystery Box (BO3)"
ENT.Author                  = "ravo Norway"
ENT.Category                = "ravo Norway"
ENT.Purpose                 = "Can spawn random weapons as in COD BO3 Zombies. (and maybe a Teddy bear?)"
ENT.Instructions            = "Place it where you want and press \"E\". Does have console settings; bo3ravo_mysterybox_**."
ENT.Spawnable               = true
ENT.AdminSpawnable          = true
ENT.AutomaticFrameAdvance   = true

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "RemoveIdleTimerID")

	self:NetworkVar("Entity", 0, "WeaponEntity")
	self:NetworkVar("Entity", 1, "VirtualOwner")

	self:NetworkVar("Bool", 0, "CanUseBox")
	self:NetworkVar("Bool", 1, "CanTakeWeapon")
	self:NetworkVar("Bool", 2, "Deactivated")
	self:NetworkVar("Bool", 3, "HasValidAngles")

	self:NetworkVar("Float", 0, "MysteryboxHealth")
    self:NetworkVar("Float", 1, "MysteryboxPriceToBuy")

    self:NetworkVar("Int", 0, "AmountOfUses")

    if SERVER then
        --- Set First Time
        self:SetRemoveIdleTimerID("bo3Ravo:removeIdleTimerID001"..self:EntIndex())

        self:SetWeaponEntity(nil)
        self:SetVirtualOwner(nil)

        self:SetCanUseBox(true)
        self:SetCanTakeWeapon(false)
        self:SetDeactivated(false)

        local currHealthConVar = GetConVar("bo3ravo_mysterybox_bo3_ravo_MysteryBoxTotalHealth"):GetInt()
        if currHealthConVar > 0 then
            self:SetMysteryboxHealth( currHealthConVar )
        else
            self:SetMysteryboxHealth( -1 )
        end

        self:SetMysteryboxPriceToBuy(950) -- Can be used if you want to add a price for a gamemode etc.
        self:SetAmountOfUses(0)
    end
end

hook.Add( "PhysgunPickup", "bo3Ravo:PhysgunPickupMysteryBoxRavo001", function(pl, ent)

    if ent:GetClass() == "mysterybox_bo3_ravo" then

        local canUseBox = ent:GetCanUseBox()

        if not pl:IsAdmin() and not pl:IsSuperAdmin() then return false end

        if not ent:GetCanUseBox() then return false end

    end

end )
