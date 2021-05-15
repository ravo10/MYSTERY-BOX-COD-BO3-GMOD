# All Previous Changelogs:

# STABLE ( NEW )

### 1.0 ( 15.05.21 )
* Improved the logic for when a Player is taking a weapon from the box
* Fixed a bug where when a SWEP was removed from the list, it would not get saved locally for viewing
* Improved performance of editing SWEP list in*game
* Fixed the fallback name of a SWEP to its class
* Added new fallback model, if the world model is not valid
* Fixed angle settings for SWEP in Mystery Box
* Added new notification when picking up a SWEP
* Added so the if the SWEP is pressed "E" on, it will get equiped ( not only the Mystery Box )
* Added so the current sound playing from the Mystery Box will stop when the Mystery box is removed
* Fixed some pickup logic with the physgun
* Fixed some collision bugs with the SWEP from the Mystery Box
* Adjusted and fine tuned the cycle of SWEPs for the Mystery Box
* Fixed a bug where you would not receive ammo properly
* Added so if a Player takes a SWEP, the ammo for that SWEP will get removed ( for balance reasons )
* Removed so the SWEP model will no longer get smaller ( more like stock Mystery Box )

# BETA ( NEW )

### ( 13.05.21 )
* Added 'AddCSLuaFile()' to all autorun files

### ( 13.05.21 )
* Tried to improve performance for particles from Mystery Box ( less of them )
* Added a Context Menu Panel ( hold 'C' ), where you can access all settings for SWEPs and ConVars easy
* Fixed a few minor bugs
* Added destruction client models for Mystery Box if health is activated and it is below 0
* Added flags for ConVars so they will be saved after leaving the server

# STABLE ( OLD )

### ( 10.08.19 )
Gjenopprett til denne versjonen
* Fixed the bug where invalid weapon class names in the text file would crash the menu. Thanks to "LORD THOMPSON" and "𝓦𝒶𝓇𝓇𝒾𝑜𝓇" for reporting ;)

### ( 10.08.19 )
Gjenopprett til denne versjonen
* Tried to add a loading function to fix a potential bug for some (unknown)...

### ( 19.07.19 )
* Fixed critical unknown bug for the teddybear... (thank you "Lolbit" for reporting)

### ( 5.07.19 )
* Fixed the missing textures... Thanks to "Classy Bulborb" for giving me a clue where the "bug" (wrong path) was.

### ( 11.05.19 )
Big Change
* Added a control panel! You can now add weapons from there; easy and simple
* Added some smooth lighting on the rope

### ( 08.05.19 )
* Forgot to add the option to set custom teddy bear value; use ConVar bo3ravo_mysterybox_bo3_ravo_teddybearGetChance_CustomAllowed to do that

### ( 06.05.19 )
* Added a missing security check for a timer related to the new trigger....