include("shared.lua")

function drawSpecialPropText(
	_pos,
	_ang,
	_scale,
	_text,
	_textColor,
	flipView
)
	if flipView then
		_ang:RotateAroundAxis(
			Vector(0, 0, 1),
			180
		)
	end

	cam.Start3D2D(_pos, _ang, _scale)
		draw.DrawText(
			_text,
			"Default",
			0,
			0,
			_textColor,
			TEXT_ALIGN_CENTER
		)
	cam.End3D2D()
end

function ENT:Draw()

	self:DrawModel()

	local localMaxs = self:OBBMaxs()
	local addAngles = Angle( 0, 0, 0 )
	local extraPos = Vector( 0, 0, 0 )

	local fallbackModelIsActive = self:GetModel() == "models/maxofs2d/logo_gmod_b.mdl"
	if fallbackModelIsActive then addAngles = Angle( 0, 90, 90 ) extraPos = Vector( 0, 0, 16 ) else addAngles = Angle( 0, 180, 90 ) end

	local newpos, newang = LocalToWorld(

		Vector( 0, 0, 0 ), addAngles,
		self:GetPos() + Vector( 0, 0, localMaxs.z + 5 ) + extraPos, self:GetAngles()

	)

	local pos = newpos
	local ang = newang
	
	--- Get Data
	if not self.GetCurrentWeaponClassSwitch then return end

	local _weaponClass = self:GetCurrentWeaponClassSwitch()
	if not _weaponClass then return end
	_weaponClass = _weaponClass

	if not MysteryBox and ( MysteryBox and not MysteryBox:IsValid() ) and not MysteryBox.GetCanTakeWeapon then return end

	local MysteryBox = self:GetParentBoxEntity()
	local _CanTakeWeapon = MysteryBox:GetCanTakeWeapon()

	if _CanTakeWeapon then
		if not bo3RavoNiceWeaponNamesGame then bo3RavoGetNiceWeaponNames() end

		-- Text
		local textTitle = "Name N/A"

		-- Nice name... Maybe
		if bo3RavoNiceWeaponNamesGame and bo3RavoNiceWeaponNamesGame[ _weaponClass ] then textTitle = bo3RavoNiceWeaponNamesGame[ _weaponClass ] end

		-- -- --- -
		-- Color
		local textColor = self:GetColor()
		textColor = Color( 251, 255, 0, 240) -- Yellow

		local __Text = textTitle

		-- Draw front
		drawSpecialPropText( pos, ang, 0.3, __Text, textColor, false )
		-- Draw back
		drawSpecialPropText( pos, ang, 0.3, __Text, textColor, true )

	end

	-- Emit some lights for seeing weapons in the dark (center)
	-- -- -
	local lightCenter = DynamicLight(self:EntIndex())
	if lightCenter then
		lightCenter.pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 0)

		lightCenter.r 	= 33
		lightCenter.g 	= 217
		lightCenter.b 	= 242
		
		lightCenter.brightness 	= 3
		lightCenter.Decay 		= 0.1
		lightCenter.Size 		= 100
		lightCenter.DieTime 	= CurTime()
	end

end

hook.Add("HUDPaint", "bo3Ravo:mysteryboxSWEPHUD001", function()
	local playerTraceEntity = LocalPlayer():GetEyeTrace().Entity

	local ent = playerTraceEntity -- Should be the swep
	if (
		ent and
		ent:IsValid() and
		ent:GetClass() == "mysterybox_bo3_weapon_ravo"
	) then
		local MysteryBox = ent:GetParentBoxEntity()

		if not MysteryBox.GetCanUseBox then return end
		
		local canUseBox = MysteryBox:GetCanUseBox()

		local maybePlayerCanActivateThisMysterybox = string.Split(LocalPlayer():GetNWString("CanActivateMysteryboxMBD"), ";")
		local PlayerCanActivateThisBox = table.HasValue(maybePlayerCanActivateThisMysterybox, tostring(MysteryBox:EntIndex()))

		if (
			PlayerCanActivateThisBox and
			MysteryBox and
			MysteryBox:IsValid()
		) then
			local _OwnerOfWeapon = MysteryBox:GetWeaponEntity()
			if _OwnerOfWeapon and _OwnerOfWeapon:IsValid() then
				_OwnerOfWeapon = _OwnerOfWeapon:GetOwnerPlayer()
			end

			if (
				MysteryBox:GetCanTakeWeapon() and
				_OwnerOfWeapon == LocalPlayer()
			) then
				local text0, text1, text2 = "Press ", "E ", "for Weapon"
				
				local baseWidthPos = ScrW() / 2
				local width0, width1, width2 = _Bo3RavoNorwayMysteryBoxGetTextWidth(text0), _Bo3RavoNorwayMysteryBoxGetTextWidth(text1), _Bo3RavoNorwayMysteryBoxGetTextWidth(text2)

				-- Draw
				__Bo3RavoNorwayMysteryBoxDrawText(text0, (baseWidthPos - width0))
				__Bo3RavoNorwayMysteryBoxDrawText(text1, (baseWidthPos - width1), Color(255, 226, 96, 250))
				__Bo3RavoNorwayMysteryBoxDrawText(text2, (baseWidthPos + width2 - (width0 + 3)))
			end
		end
	end
end)
