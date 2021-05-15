
AddCSLuaFile()

-- Create Config. File if it doesn't exsist
if not file.Exists("bo3_mysterybox_ravo.txt", "DATA") then
    file.Write("bo3_mysterybox_ravo.txt", "")
end

-- Get nice weapon names
function bo3RavoGetNiceWeaponNames()

    bo3RavoNiceWeaponNamesGame = {}

    for _,WepData in pairs( list.Get( "Weapon" ) ) do

        if WepData.ClassName and WepData.PrintName and WepData.Category then
            bo3RavoNiceWeaponNamesGame[ WepData.ClassName ] = WepData.PrintName .." (" .. WepData.Category .. ")"
        elseif WepData.ClassName and WepData.PrintName then
            bo3RavoNiceWeaponNamesGame[ WepData.ClassName ] = WepData.PrintName
        elseif WepData.ClassName then
            bo3RavoNiceWeaponNamesGame[ WepData.ClassName ] = WepData.ClassName
        end

    end

    return bo3RavoNiceWeaponNamesGame

end

-- Init
timer.Create( "Bo3RavoMysteryBoxLoadNiceNamesFirstTime001", 0.3, 0, function()

    -- Load
    if list.Get( "Weapon" ) then timer.Remove( "Bo3RavoMysteryBoxLoadNiceNamesFirstTime001" ) bo3RavoGetNiceWeaponNames() end

end )

if CLIENT then
    --- - --- -
    -- Get Custom Weapons Table Data (maybe)
    --
    --- - If the Player has added a config file, only add allowed Weapons from that file
    -- -

    function bo3ravo_GetCustomWepTable()

        local __customWepTable = {}

        local _file = file.Read("bo3_mysterybox_ravo.txt", "DATA")
        if not _file or _file == "" then __customWepTable = {} return end

        __customWepTable = string.Split(_file, "\n")
        if __customWepTable then
            -- Filter out any comments... // or /**/
            local temp__customWepTable = {}
            local justSkipBecauseItIsAComment = false
            local wasEndOfComment = false
            local _reset = function()
                -- Reset
                justSkipBecauseItIsAComment = false
                wasEndOfComment = false
            end

            for Index,String in pairs(__customWepTable) do
                local newNoSpaceString = string.gsub(String, " ", "")

                if (
                    newNoSpaceString == "/*" or (
                        string.match(newNoSpaceString, "/%*") and
                        not string.match(newNoSpaceString, "%*/")
                    )
                ) then
                    justSkipBecauseItIsAComment = true
                    wasEndOfComment = false
                elseif (
                    newNoSpaceString == "*/" and (
                        not string.match(newNoSpaceString, "/%*") and
                        string.match(newNoSpaceString, "%*/")
                    )
                ) then
                    justSkipBecauseItIsAComment = false
                    wasEndOfComment = true
                elseif (
                    string.match(newNoSpaceString, "//") or
                    string.match(newNoSpaceString, "/%*") or
                    string.match(newNoSpaceString, "%*/")
                ) then
                    justSkipBecauseItIsAComment = true
                    wasEndOfComment = true
                end

                if (
                    not justSkipBecauseItIsAComment and
                    not wasEndOfComment and
                    newNoSpaceString ~= ""
                ) then
                    _reset()

                    -- OK, Add =>>
                    table.insert( temp__customWepTable, newNoSpaceString )
                elseif wasEndOfComment then
                    _reset()
                end

                if Index == #__customWepTable then
                    __customWepTable = temp__customWepTable
                end
            end
        else
            __customWepTable = {}
        end

        list.Set( "Bo3RavoMysteryBoxCustomWeapon", "swep_classes", __customWepTable )
        return __customWepTable

    end
    
    bo3ravo_GetCustomWepTable()
    --- -
    -- Build a Control Panel
    hook.Add("PopulateToolMenu", "MenuSetting_bo3ravo_mystery_box_001", function()

        spawnmenu.AddToolMenuOption( "Options", "Mystery Box", "bo3ravo_mystery_box", "BO3 (ravo Norway) (Admin)", "", "", function( cpanel )

            bo3ravoMakeSettingsSWEPPanel( cpanel )

        end )
    end)

end
if SERVER then
    util.AddNetworkString("update:__bo3_ravo_customWeaponsTable")
    util.AddNetworkString("bo3Ravo:setServerConVar")

    hook.Add("PlayerInitialSpawn", "bo3ravo_MysteryBox_PlayerInitialSpawn001", function(pl)
        if pl and pl:IsValid() then
            pl:SendLua( [[bo3RavoGetNiceWeaponNames()]] )
        end
    end)

    --- -- -
    -- This is the table where the final weapons data must end
    -- (remember to add the: "VModel" and "WModel" field (this should be automated; look under "Add Weapons" (Initialize)). Table looks like 'list.Get("Weapon")')
    bo3_ravo_mysterybox_allowedWeapons = {}
    local __bo3_ravo_customWeaponsTable = {}

    local _AddAllowedWeapons = function( sendNotification )
        -- Reset
        bo3_ravo_mysterybox_allowedWeapons = {}
        -----------------------------
        -- Allowed Weapons --
        -------------------------------
        local tempAllowedWeapons = {}
        local hl2StandardWeapons = {
            weapon_pistol       = "models/weapons/w_Pistol.mdl",
            weapon_smg          = "models/weapons/w_smg1.mdl",
            weapon_shotgun      = "models/weapons/w_shotgun.mdl",
            weapon_ar2          = "models/weapons/w_IRifle.mdl",
            weapon_rpg          = "models/weapons/w_rocket_launcher.mdl",
            weapon_crossbow     = "models/weapons/w_crossbow.mdl",
            weapon_frag         = "models/weapons/w_grenade.mdl",
            weapon_357          = "models/weapons/w_357.mdl",
            weapon_crowbar      = "models/weapons/w_crowbar.mdl",
            weapon_slam         = "models/weapons/w_slam.mdl",
            weapon_stunstick    = "models/weapons/w_stunbaton.mdl"
        }
        ------- -- -
        -- For like BuyBox-table with class as key
        local addWeaponTableWithClassAsKey = function(_table)
            for classKey,_ in pairs(_table) do
                table.insert(tempAllowedWeapons, classKey)
            end
        end
        -- For whatever else with class as the value
        local addWeaponTableWithClassAsValue = function(_table)
            for _,classKey in pairs(_table) do
                table.insert(tempAllowedWeapons, classKey)
            end
        end

            ------------------
        -- Add Weapons --
        ----------- -----
        --
        --- - If the Player has added a config file, only add allowed Weapons from that file
        -- -
        if (
            __bo3_ravo_customWeaponsTable and
            #__bo3_ravo_customWeaponsTable > 0
        ) then
            tempAllowedWeapons = __bo3_ravo_customWeaponsTable
        else
            -- Normally (add all Weapons from game)
            -- -
            -- Add all Weapons
            for k,v in pairs(list.Get("Weapon")) do
                local _WepClass = string.lower(v.ClassName)

                local _t = {}
                _t[_WepClass] = v
                -- - -
                if (
                    _WepClass ~= "weapon_physgun" and
                    _WepClass ~= "weapon_physcannon" and
                    _WepClass ~= "gmod_camera" and
                    _WepClass ~= "gmod_tool" and
                    _WepClass ~= "laserpointer" and
                    _WepClass ~= "remotecontroller" and
                    _WepClass ~= "swep_construction_kit" and (
                        not string.match(_WepClass, "_base")
                    )
                ) then
                    -- Add Weapon to table
                    addWeaponTableWithClassAsKey(_t)
                end
            end
        end
        --- -
        -- Get all valid weapons
        local weaponsTableAll = list.Get("Weapon")
        
        local _i = 1
        for _,dataTable in pairs( weaponsTableAll ) do

            -- Insert
            if table.HasValue( tempAllowedWeapons, dataTable.ClassName ) then table.insert( bo3_ravo_mysterybox_allowedWeapons, dataTable ) end

            local tableCount = table.Count( weaponsTableAll )

            if _i == tableCount then

                -- Empty
                if #bo3_ravo_mysterybox_allowedWeapons == 0 then

                    if sendNotification then

                        local send = sendNotification[ "send" ]
                        local pl = sendNotification[ "pl" ]

                        -- Send notification to Player
                        if pl and pl:IsValid() then

                            pl:SendLua( [[notification.AddLegacy( "Mystery Box SWEPs UPDATED! ( Empty )", NOTIFY_GENERIC, 3 )]] )

                        end

                    end

                else

                    -- Now insert all the models to the table...
                    local _newTable = {}

                    local _j = 1
                    for _,weaponsTable in pairs( bo3_ravo_mysterybox_allowedWeapons ) do
                        local _entVModel = nil
                        local _entWModel = nil

                        -- Spawn a temp. entity, get the model and delete
                        -- -
                        local _entClass = string.lower(weaponsTable.ClassName)
                        local tempEnt = ents.Create( weaponsTable.ClassName )

                        local IsHL2Weapon = false

                        -- Set
                        -- Standard HL2-weapons
                        for classKey,Model in pairs( hl2StandardWeapons ) do

                            if string.lower( classKey ) == _entClass then IsHL2Weapon = true _entWModel = Model end

                        end
                        -- -
                        -- FA:S 2 Weapons
                        if string.match(_entClass, "fas2_") then
                            local _t = tempEnt:GetTable()

                            _entVModel = _t.VM
                            _entWModel = _t.WM
                            if _t.WorldModel then _entWModel = _t.WorldModel end -- Very important
                        elseif not IsHL2Weapon then
                            -- Other
                            _entVModel = tempEnt:GetWeaponViewModel()
                            _entWModel = tempEnt:GetWeaponWorldModel()
                        end

                        if tempEnt and tempEnt:IsValid() then tempEnt:Remove() end

                        -- Check if really valid... Or else use a fallback model
                        if not _entVModel or not util.IsValidModel(_entVModel) then _entVModel = "models/maxofs2d/logo_gmod_b.mdl" end
                        if not _entWModel or not util.IsValidModel(_entWModel) then _entWModel = "models/maxofs2d/logo_gmod_b.mdl" end

                        local tempTable = weaponsTable
                        tempTable["VModel"] = _entVModel
                        tempTable["WModel"] = _entWModel

                        table.insert( _newTable, tempTable )

                        ------------
                        -- Done --
                        ----------------
                        if _j == table.Count( bo3_ravo_mysterybox_allowedWeapons ) then

                            --[[ Something can happend here ]]

                            if sendNotification then

                                local send = sendNotification[ "send" ]
                                local pl = sendNotification[ "pl" ]

                                -- Send notification to Player
                                if pl and pl:IsValid() then

                                    pl:SendLua( [[notification.AddLegacy( "Mystery Box SWEPs UPDATED!", NOTIFY_GENERIC, 3 )]] )

                                end

                            end

                        end

                        _j = (_j + 1)
                    end

                end

            end

            _i = (_i + 1)
        end
    end

    net.Receive("update:__bo3_ravo_customWeaponsTable", function( len, pl )

        if not pl:IsAdmin() or not pl:IsSuperAdmin() then return end

        -- Update
        __bo3_ravo_customWeaponsTable = net.ReadTable()

        timer.Simple( 0.15, function() _AddAllowedWeapons( { send = true, pl = pl } ) end )

    end)

    net.Receive("bo3Ravo:setServerConVar", function(len, pl)
        if not pl:IsAdmin() then return end

        local data = net.ReadTable()
        local conVarId = data[ "conVarId" ]
        local value = data[ "value" ]
        
        -- Set server convar
        GetConVar( conVarId ):SetInt( value )
        
    end)

    --- - --- -
    -- Get Custom Weapons Table Data (maybe)
    --
    --- - If the Player has added a config file, only add allowed Weapons from that file
    -- -
    local __customWepTable = string.Split(file.Read("bo3_mysterybox_ravo.txt", "DATA"), "\n")
    if __customWepTable then
        -- Filter out any comments... // or /**/
        local temp__customWepTable = {}
        local justSkipBecauseItIsAComment = false
        local wasEndOfComment = false
        local _reset = function()
            -- Reset
            justSkipBecauseItIsAComment = false
            wasEndOfComment = false
        end

        for Index,String in pairs(__customWepTable) do
            local newNoSpaceString = string.gsub(String, " ", "")

            if (
                newNoSpaceString == "/*" or (
                    string.match(newNoSpaceString, "/%*") and
                    not string.match(newNoSpaceString, "%*/")
                )
            ) then
                justSkipBecauseItIsAComment = true
                wasEndOfComment = false
            elseif (
                newNoSpaceString == "*/" and (
                    not string.match(newNoSpaceString, "/%*") and
                    string.match(newNoSpaceString, "%*/")
                )
            ) then
                justSkipBecauseItIsAComment = false
                wasEndOfComment = true
            elseif (
                string.match(newNoSpaceString, "//") or
                string.match(newNoSpaceString, "/%*") or
                string.match(newNoSpaceString, "%*/")
            ) then
                justSkipBecauseItIsAComment = true
                wasEndOfComment = true
            end

            if (
                not justSkipBecauseItIsAComment and
                not wasEndOfComment and
                newNoSpaceString ~= ""
            ) then
                _reset()

                -- OK, Add =>>
                table.insert(temp__customWepTable, newNoSpaceString)
            elseif wasEndOfComment then
                _reset()
            end

            if Index == #__customWepTable then
                __bo3_ravo_customWeaponsTable = temp__customWepTable

                timer.Simple(0, function()
                    _AddAllowedWeapons()
                end)
            end
        end
    else
        _AddAllowedWeapons()
    end
end