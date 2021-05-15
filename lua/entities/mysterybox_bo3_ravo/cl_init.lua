include("shared.lua")

function ENT:Draw()
	if not self or not self:IsValid() then return end

	self:DrawModel()

	-- Emit some lights for seeing weapons in the dark (from bottom)
	-- -- -
	local lightBottom = DynamicLight(self:EntIndex())
	if lightBottom then
		lightBottom.pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, -5)

		lightBottom.r 	= 255
		lightBottom.g 	= 255
		lightBottom.b 	= 255
		
		lightBottom.brightness 	= 3
		lightBottom.Decay 		= 10
		lightBottom.Size 		= 50
		lightBottom.DieTime 	= CurTime()
	end
	-- Emit some lights for seeing weapons in the dark (from above)
	-- -- -
	local lightTop = DynamicLight(self:EntIndex())
	if lightTop then
		lightTop.pos = self:LocalToWorld(self:OBBCenter()) + Vector(0, 0, 10)

		lightTop.r	= 255
		lightTop.g 	= 255
		lightTop.b 	= 255
		
		lightTop.brightness = 5.4
		lightTop.Decay 		= 10
		lightTop.Size 		= 60
		lightTop.DieTime 	= CurTime()
	end
end
-- -
-- Font(s)
surface.CreateFont("coolvetica10", {
	font 		= "coolvetica",
	extended 	= false,
	size 		= 30,
	weight 		= 100,
	blursize 	= 1,
	scanlines 	= 2,
	antialias 	= false,
	underline 	= false,
	italic 		= false,
	strikeout 	= false,
	symbol 		= false,
	rotary 		= false,
	shadow 		= true,
	additive 	= false,
	outline 	= false
})

function __Bo3RavoNorwayMysteryBoxDrawText( text, xPos, color )
	local _xPos = ScrW() / 2
	if xPos then _xPos = xPos end

	local _color = Color(255, 255, 255, 255)
	if color then _color = color end

	draw.DrawText(
		text,
		"coolvetica10",
		_xPos,
		ScrH() / 2 + 100,
		_color,
		TEXT_ALIGN_CENTER
	)
end
function _Bo3RavoNorwayMysteryBoxGetTextWidth( text )
	surface.SetFont("coolvetica10")
	surface.SetTextColor(0, 0, 0, 0)
	surface.SetTextPos(0, 0)
	surface.DrawText(text)

	local extra_width, extra_height = surface.GetTextSize(text)

	return extra_width
end

hook.Add("HUDPaint", "bo3Ravo:mysteryboxHUD001", function()
	local playerTraceEntity = LocalPlayer():GetEyeTrace().Entity

	local ent = playerTraceEntity -- Should be the box
	if (
		ent and
		ent:IsValid() and
		ent.GetCanUseBox
	) then
		local canUseBox = ent:GetCanUseBox()

		local maybePlayerCanActivateThisMysterybox = string.Split(LocalPlayer():GetNWString("CanActivateMysteryboxMBD"), ";")
		local PlayerCanActivateThisBox = table.HasValue(maybePlayerCanActivateThisMysterybox, tostring(ent:EntIndex()))

		if (
			PlayerCanActivateThisBox and
			ent and
			ent:IsValid()
		) then
			local _OwnerOfWeapon = ent:GetWeaponEntity()
			if _OwnerOfWeapon and _OwnerOfWeapon:IsValid() then
				_OwnerOfWeapon = _OwnerOfWeapon:GetOwnerPlayer()
			end

			if ent:GetClass() == "mysterybox_bo3_ravo" then
				if (
					canUseBox and
					ent:GetHasValidAngles()
				) then
					local text0, text1, text2 = "Press ", "E ", "for Mystery Box [Cost: "..ent:GetMysteryboxPriceToBuy().."]"
					
					local baseWidthPos = ScrW() / 2
					local width0, width1, width2 = _Bo3RavoNorwayMysteryBoxGetTextWidth(text0), _Bo3RavoNorwayMysteryBoxGetTextWidth(text1), _Bo3RavoNorwayMysteryBoxGetTextWidth(text2)

					-- Draw
					__Bo3RavoNorwayMysteryBoxDrawText(text0, (baseWidthPos - width0))
					__Bo3RavoNorwayMysteryBoxDrawText(text1, (baseWidthPos - width1), Color(255, 226, 96, 250))
					__Bo3RavoNorwayMysteryBoxDrawText(text2, (baseWidthPos + width2 - (width1 + width0 * 2 + 5)))
				elseif (
					ent:GetCanTakeWeapon() and
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
	end
end)
hook.Add("OnPlayerChat", "bo3Ravo:OnPlayerChatMysteryBoxRavoCheatCodes001", function(pl, strText, bTeam, bDead)
	if pl ~= LocalPlayer() or (
		not pl:IsAdmin() and
		not pl:IsSuperAdmin()
	) then return end

	strText = string.lower(strText)
	local allCurrentMysteryboxEntIDs = string.Split(pl:GetNWString("CanActivateMysteryboxMBD"), ";")

	for _,MysteryBoxID in pairs(allCurrentMysteryboxEntIDs) do
		if MysteryBoxID ~= "" then
			local MysteryBox = ents.GetByIndex(tonumber(MysteryBoxID))

			if MysteryBox and MysteryBox:IsValid() then
				-- A Cheat code (open me in german)
				if (
					strText == "offnen sie mich!" and
					MysteryBox:GetDeactivated()
				) then
					-- Activate a deactivated mysterybox
					net.Start("bo3Ravo:cheatCode_MysteryboxRavo001")
						net.WriteTable({
							type = "001",
							mysteryboxEnt = MysteryBox
						})
					net.SendToServer()
				end
			end
		end
	end
end)