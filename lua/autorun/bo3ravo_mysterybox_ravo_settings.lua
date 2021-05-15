
AddCSLuaFile()

if CLIENT then

    local _updateWeaponsServer = function( __table, cpanel, window, widerWindow )

        net.Start( "update:__bo3_ravo_customWeaponsTable" )
            net.WriteTable( __table )
        net.SendToServer()

        notification.AddLegacy( "Updating Mystery Box SWEPs list ...", NOTIFY_GENERIC, 3 )

    end

    -- Being used two places
    function bo3ravoMakeSettingsSWEPPanel( cpanel, window, widerWindow )

        -- SETTINGS --
        local _heightView = 315
        local _heightText = 50
        local _widthAll = 285

        timer.Create( "Bo3RavoMysteryBoxCustomWeaponLoader", 0.3, 0, function()

            local SortedWepAddTable = list.Get( "Weapon" )
            local SortedWepGetTable = list.Get( "Bo3RavoMysteryBoxCustomWeapon" )

            if SortedWepAddTable and SortedWepGetTable and SortedWepGetTable[ "swep_classes" ] then

                timer.Remove( "Bo3RavoMysteryBoxCustomWeaponLoader" )

                SortedWepGetTable = SortedWepGetTable[ "swep_classes" ]

                -- Refresh button
                local icon = vgui.Create( "DImageButton", cpanel )

                icon:SetImage( "icon16/database_refresh.png" )
                icon:SetSize( 16, 16 )
                
                if widerWindow then
                    
                    icon:SetPos( window:GetWide() - 55, 10 )

                else
                    
                    icon:SetPos( _widthAll - 20, 28 )

                end

                icon.Paint = function() end

                local addATitle = function(title, pos)
                    local _DLable = vgui.Create("DLabel", cpanel)

                    _DLable:SetColor(Color(0, 0, 0))

                    if widerWindow then

                        local width = ( window:GetWide() - 40 ) / 2

                        _DLable:SetPos( 3 + pos * width, 3 )
                        _DLable:SetSize( _widthAll, _heightText )

                    else
                        
                        _DLable:SetPos(3, 10 + _heightView * pos )
                        _DLable:SetSize(_widthAll, _heightText)
                    
                    end
                    
                    _DLable:SetFont("DermaLarge")
                    _DLable:SetText(title)

                    return _DLable
                end
                local makeListView = function(primFunctionString, pos, currentWepDList)
                    local _DListView = vgui.Create("DListView", cpanel)

                    if widerWindow then

                        local width = ( window:GetWide() - 40 ) / 2
                        local height = window:GetTall() - 125

                        _DListView:SetPos( width * pos + 5 + pos * 4, 50 )
                        _DListView:SetSize( width, height )

                    else
                        
                        _DListView:SetPos(0, _heightView * pos + _heightText)
                        _DListView:SetSize( _widthAll, _heightView - _heightText + 12 )
                    
                    end

                    _DListView:SetMultiSelect(true)
                    _DListView:AddColumn("Nice Name")
                    _DListView:AddColumn("class_name")
                    --
                    if primFunctionString == "add" then

                        _DListView.OnRowSelected = function(panel, lineIndex, line)

                            if LocalPlayer() and (not LocalPlayer():IsAdmin() or not LocalPlayer():IsSuperAdmin()) then return end
                            timer.Remove( "bo3RavoMysteryBoxSaveSettings" )

                            local _AddToTextFile = function( NewWeaponClass )

                                file.Append( "bo3_mysterybox_ravo.txt", "\n" .. NewWeaponClass )

                            end

                            local WeaponClassSelected = line:GetColumnText(2)
                            local ListHasWeaponClassAlready = table.HasValue( SortedWepGetTable, WeaponClassSelected )

                            if not ListHasWeaponClassAlready then

                                -- Add To .txt file
                                _AddToTextFile( WeaponClassSelected )

                                -- Refresh
                                currentWepDList:AddLine( SortedWepAddTable[ string.lower( WeaponClassSelected ) ][ "PrintName" ], string.lower( WeaponClassSelected ) )
                                SortedWepGetTable = bo3ravo_GetCustomWepTable()

                                timer.Create( "bo3RavoMysteryBoxSaveSettings", 0.3, 1, function()

                                    _updateWeaponsServer( SortedWepGetTable, cpanel, window, widerWindow )

                                end )

                            end

                        end

                    elseif primFunctionString == "remove" then

                        _DListView.OnRowSelected = function(panel, lineIndex, line)

                            if LocalPlayer() and (not LocalPlayer():IsAdmin() or not LocalPlayer():IsSuperAdmin()) then return end
                            timer.Remove( "bo3RavoMysteryBoxSaveSettings" )

                            local WeaponClassSelected = line:GetColumnText(2)

                            local _WriteTextFile = function( NewCustomWeaponsTable )

                                file.Write( "bo3_mysterybox_ravo.txt", table.concat( NewCustomWeaponsTable, "\n" ) )

                            end

                            -- -
                            -- Remove From .txt file
                            local temp__customWepTable = table.Copy( SortedWepGetTable )
                            local indexToRemoveFromTable = table.KeyFromValue( temp__customWepTable, WeaponClassSelected )

                            -- Remove
                            table.remove( temp__customWepTable, indexToRemoveFromTable )

                            -- Save
                            _WriteTextFile( temp__customWepTable )

                            -- Refresh
                            if panel:GetLine( lineIndex ) then panel:RemoveLine( lineIndex ) end
                            SortedWepGetTable = bo3ravo_GetCustomWepTable()

                            timer.Create( "bo3RavoMysteryBoxSaveSettings", 0.3, 1, function()

                                _updateWeaponsServer( SortedWepGetTable, cpanel, window, widerWindow )

                            end )

                            if not SortedWepGetTable or #SortedWepGetTable == 0 then _Write( {} ) end

                        end

                    end

                    return _DListView

                end
                --
                -- --
                -- Get Weapons
                local addedWeaponsLabel = addATitle("Added SWEPs:", 1)
                local addedWeaponsList = makeListView("remove", 1)
                -- Get and Show
                for _,_WepClassName in pairs( SortedWepGetTable ) do
                    if SortedWepAddTable and SortedWepAddTable[ string.lower( _WepClassName ) ] then
                        addedWeaponsList:AddLine( SortedWepAddTable[ string.lower( _WepClassName ) ][ "PrintName" ], string.lower( _WepClassName ) )
                    end
                end
                --- -
                -- Set Weapons
                local allWeaponsLabel = addATitle( "Add SWEPs:", 0 )
                local allWeaponsList = makeListView( "add", 0, addedWeaponsList )

                -- Get All Available Weapons on Server
                for _,dataTable in pairs( SortedWepAddTable ) do
                    if not string.match( string.lower( dataTable.ClassName ), "_base" ) then
                        allWeaponsList:AddLine( dataTable.PrintName, string.lower( dataTable.ClassName ) )
                    end
                end

                -- - -
                -- What Will Override ViewZPos
                addedWeaponsLabel:MoveToFront()
                allWeaponsLabel:MoveToFront()

                icon.DoClick = function()

                    -- Remove old panels
                    icon:Remove()

                    addedWeaponsLabel:Remove()
                    allWeaponsLabel:Remove()

                    addedWeaponsList:Remove()
                    allWeaponsList:Remove()

                    bo3ravo_GetCustomWepTable()
                    bo3ravoMakeSettingsSWEPPanel( cpanel, window, widerWindow )

                end

            end

        end )

    end

    list.Set( "DesktopWindows", "Bo3RavoNorwayMysteryBoxExtraSettingsPanel", {
            
        title		= "Mystery Box [ Admin ] - (Made by: ravo Norway)",
        icon		= "icon64/tool.png",
        width		= 960,
        height		= 700,
        onewindow	= true,
        init		= function( icon, window )

            if not LocalPlayer():IsAdmin() then return end

            window:SetSize( math.min( ScrW() - 16, window:GetWide() ), math.min( ScrH() - 16, window:GetTall() ) )
            window:Center()

            local sheet = window:Add( "DPropertySheet" )
            sheet:Dock( FILL )

            local PanelSelect = sheet:Add( "DPanelSelect" )
            sheet:AddSheet( "SWEP Settings", PanelSelect, "icon16/application_form_edit.png" )

            local controls1 = PanelSelect:Add( "DPanel" )
            controls1:Dock( FILL )
            controls1:DockPadding( 8, 8, 8, 8 )

            -- SWEP settings
            bo3ravoMakeSettingsSWEPPanel( controls1, window, true )

            local controls2 = window:Add( "DPanel" )
            controls2:DockPadding( 8, 8, 8, 8 )

            -- ConVar Settings
            sheet:AddSheet( "ConVar", controls2, "icon16/application_xp_terminal.png" )

            -- Convenience function to quickly add items
            local function addItemBoolean( text, conVarId, paddingTop )

                if not LocalPlayer():IsAdmin() then return end

                local RulePanel = controls2:Add( "DPanel" ) -- Create container for this item
                RulePanel:Dock( TOP ) -- Dock it
                if paddingTop then RulePanel:DockMargin( 0, paddingTop, 0, 0 ) else RulePanel:DockMargin( 0, 2, 0, 0 ) end
            
                local ImageCheckBox = RulePanel:Add( "ImageCheckBox" ) -- Create checkbox with image
                ImageCheckBox:SetMaterial( "icon16/accept.png" ) -- Set its image
                ImageCheckBox:SetWidth( 24 ) -- Make the check box a bit wider than the image so it looks nicer
                ImageCheckBox:Dock( LEFT ) -- Dock it
                ImageCheckBox:SetChecked( GetConVar( conVarId ):GetInt() > 0 )

                local function checkBoxChange()

                    local isChecked = ImageCheckBox:GetChecked()

                    net.Start( "bo3Ravo:setServerConVar" )

                        if isChecked then
                            net.WriteTable( {
                                conVarId = conVarId,
                                value = 1
                            } )
                        else
                            net.WriteTable( {
                                conVarId = conVarId,
                                value = 0
                            } )
                        end

                    net.SendToServer()

                end

                ImageCheckBox.OnReleased = checkBoxChange

                local DLabel = RulePanel:Add( "DLabel" ) -- Create text
                DLabel:SetText( text ) -- Set the text
                DLabel:Dock( FILL ) -- Dock it
                DLabel:DockMargin( 5, 0, 0, 0 ) -- Move the text to the right a little
                DLabel:SetTextColor( Color( 0, 0, 0 ) ) -- Set text color to black
                DLabel:SetMouseInputEnabled( true ) -- We must accept mouse input

                DLabel.DoClick = function()

                    ImageCheckBox:SetChecked( not ImageCheckBox:GetChecked() )
                    checkBoxChange()

                end

                return ImageCheckBox

            end
            local function addItemDynamicInt( text, conVarId, paddingTop, min, max )

                if not LocalPlayer():IsAdmin() then return end

                local RulePanel = controls2:Add( "DPanel" ) -- Create container for this item
                RulePanel:Dock( TOP ) -- Dock it
                if paddingTop then RulePanel:DockMargin( 0, paddingTop, 0, 0 ) else RulePanel:DockMargin( 0, 2, 0, 0 ) end
            
                local DNumSlider = RulePanel:Add( "DNumSlider" ) -- Create checkbox with image
                DNumSlider:SetSize( 200, 10 )
                DNumSlider:Dock( LEFT ) -- Dock it
                DNumSlider:DockMargin( -80, 0, 0, 0 )
                DNumSlider:SetDecimals( 3 )
                DNumSlider:SetConVar( conVarId )
                DNumSlider:SetMin( min )
                DNumSlider:SetMax( max )

                local DLabel = RulePanel:Add( "DLabel" ) -- Create text
                DLabel:SetText( text ) -- Set the text
                DLabel:Dock( FILL ) -- Dock it
                DLabel:DockMargin( 0, 0, 0, 0 ) -- Move the text to the right a little
                DLabel:SetTextColor( Color( 0, 0, 0 ) ) -- Set text color to black
                DLabel:SetMouseInputEnabled( true ) -- We must accept mouse input

                return DNumSlider

            end

            -- Adding items
            -- Boolean values -- Dynamic values
            local MysteryBoxTotalHealth = addItemDynamicInt( "Mystery Box Health for Future Mystery Boxes ( value <= 0, will give infinite health ) ( default: 0 )", "bo3ravo_mysterybox_bo3_ravo_MysteryBoxTotalHealth", nil, 0, 10000 )

            local exchangeWeapons = addItemBoolean( "Exchange Weapon ( default: ON )", "bo3ravo_mysterybox_bo3_ravo_exchangeWeapons", 10 )
            
            local strictExchange = addItemBoolean( "Strict Exchange ( default: OFF ) ( prevents the exchange of: Toolgun, Physgun and Physcannon )", "bo3ravo_mysterybox_bo3_ravo_strictExchange" )
            
            local disableAllParticlesEffects = addItemBoolean( "Disable Particles for Future Mystery Boxes ( default: OFF )", "bo3ravo_mysterybox_bo3_ravo_disableAllParticlesEffects" )
            
            local teddybearGetChance_TotallyCustomValueAllowed = addItemBoolean( "Teddybear Probability - Custom Value Allowed? ( default: OFF )", "bo3ravo_mysterybox_bo3_ravo_teddybearGetChance_TotallyCustomValueAllowed", 10 )
            local teddybearGetChance = addItemDynamicInt( "Teddybear Probability ( value > 0, will give no teddybear. Lower == More Likely ) ( when \"Custom Value Allowed\" is set to 'OFF', it will adjust automatically )", "bo3ravo_mysterybox_bo3_ravo_teddybearGetChance", nil, -150, 1 )

            local hideAllNotificationsFromMysteryBox = addItemBoolean( "Hide Notifications ( default: OFF )", "bo3ravo_mysterybox_bo3_ravo_hideAllNotificationsFromMysteryBox", 10 )

        end
    } )

end
