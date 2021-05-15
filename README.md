![MysteryBox](https://repository-images.githubusercontent.com/367639952/2592d100-b597-11eb-8f96-511484cece38)
# Unoffical COD Zombie Mystery Box for Garry's Mod!

### *Replica from Call of Duty: Black Ops 3* ( *Only tested in **Garry's Mod 32-bit** ( default )* )

**Originally made for the [My Base Defence Gamemode](https://steamcommunity.com/sharedfiles/filedetails/?id=1647345157)**

**Fully working!**
You can configure your weapons, or ignore it and have all of the weapons you have added in-game as a possible outcome; you will also be able to get the dredde teddy bear after a few uses (default setting).

NEW: **Access the Context Menu Settings Panel**
Use the Context Menu ( Hold 'C' ) → *Mystery Box [ADMIN]* to access the SWEP Settings Panel and ConVar Settings Panel.

```
+--------------------------------------------------------
**Print name:** Mystery Box (BO3)
**Category:** ravo Norway
+--------------------------------------------
```
*Actually my first self-made model!*

***Bewear; because of a high particle count, spawning allot of mystery boxes can crash the game from client side. If you need many, try disabling the particles with one of the ConVar options.***

### Configuration:
***ConVars ( SERVER PROTECTED CONSOLE VARIABLES ( SAVED ) ):***
```lua
bo3ravo_mysterybox_bo3_ravo_exchangeWeapons
bo3ravo_mysterybox_bo3_ravo_strictExchange
bo3ravo_mysterybox_bo3_ravo_teddybearGetChance *(higher than 0 == no teddy bear)*
bo3ravo_mysterybox_bo3_ravo_teddybearGetChance_TotallyCustomValueAllowed *(needs to be set to allow totally custom "teddy bear get chance")*
bo3ravo_mysterybox_bo3_ravo_MysteryBoxTotalHealth
bo3ravo_mysterybox_bo3_ravo_hideAllNotificationsFromMysteryBox
bo3ravo_mysterybox_bo3_ravo_disableAllParticlesEffects
```

**(Optional)** To configure spesific weapons only:
**Use the control panel under the "Options" tab to the right. Open it up by holding "Q" ( or using the Panel in the Context Menu ) (the default Garry's Mod menu).**

Or, go into *...\Program Files (x86)\Steam\steamapps\common\GarrysMod\garrysmod\data*
and edit/create a new file called ***bo3_mysterybox_ravo.txt***.
Copy the default layout provided underneath in (if you want). You will then write the weapon classes; one per new line. That's it! Everything else is automated. *Another example is in the album*.

**Using the control panel to remove classes, will delete all comments in the .txt-file**.

*I.e. ignoring configuration, will include all weapons; if this isn't clear. (some comments asking about it)*
### Comment system ( FOR ADVANCED USERS ):
```lua
------------------------
/*comment_here*/
//comment_here
```
```lua
////////////////////////////////////////////////////////////////////////////////////
/*
Made by: ravo Norway

You should not have comments within comments...
Just keep it simple, so you don't not break the not-so-solid-algorithm.

**This file will load on server start; so you need to restart the server if you want
to update the allowed weapon classes.
**If you don't have any weapon classes in here, then every weapon on the server
will get added. (Just know that if you are playing singleplayer, then you are both the client and the server)
**Only valid weapons for the server will get added. E.g. if you don't have it installed, it will be ignored.
/*
///////////////////////////////////////////////////////////////////////////////
/*
-----------------------
-- Weapon Classes -- -
-----------------------
*/
//
/////////////////////////////////////////
// Half-Life 2
////////////////////////////////////////
/*weapon_pistol
weapon_smg
weapon_shotgun
weapon_ar2
weapon_rpg
weapon_crossbow
weapon_frag
weapon_357
weapon_crowbar
weapon_slam
weapon_stunstick*/
//
/////////////////////////////////////////
// Custom Weapons (self-made)
////////////////////////////////////////

//
/////////////////////////////////////////
// Other Weapons
////////////////////////////////////////

//
////////////////////////////////////////
```

*To get all the weapon classes available in-game (including addons), you can create a **.lua** file in a temp. autorun folder with this simple code:*
```lua
-- Will return all weapons installed on server (local and global servers)
-- in a .lua file that is ran server side. It is printed out in console.

PrintTable( list.Get( "Weapon" ) )
```

**Weapons in picture(s):**
* Half-Life 2
* [TFA - CoD Zombies Wonder Weapon SWEPs](https://steamcommunity.com/sharedfiles/filedetails/?id=1420540808)

### **License:**
This addon is created by [ravo (Norway)](https://steamcommunity.com/sharedfiles/filedetails/?id=1647345157) or the uploader of this [Addon](https://steamcommunity.com/sharedfiles/filedetails/?id=1732498816) on Steam Workshop.

*The sounds used for the Mystery Box belongs to the rightful owner(s) within the COD Zombie Series.
*The wood texture is from: [valeria_aksakova](https://www.freepik.com/valeria-aksakova).

[PayPal - ravonorway](https://paypal.me/ravonorway)

***Made in Norway. - by ravo Norway 🏔***
