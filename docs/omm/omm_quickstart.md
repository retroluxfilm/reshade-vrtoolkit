---
---

Quick Start tutorial
=======
This is a quick start tutorial to set up the Open Mod Manager (OMM) and setup your first game. For more information
check out the [official wiki](https://github.com/sedenion/OpenModMan/wiki/)

## 1. Open Mod Manager Preparation

1. Download the latest release of the [Open Mod Manager (OMM)](https://github.com/sedenion/OpenModMan/releases).
   (At best use the 64bit version)
2. Install the Open Mod Manager to your desired install location.
   (Single installation used for all Games `eg. D:\Games\OMM`)
3. Create a folder where all your mods will be placed to used as context root. 
   At best place it where you have plenty of space available. `(eg. D:\Games\OMM_GameMods)`

-----------------------------------------------------------------------------------------------------------

## 2. Game Preparation for Mods (Software Context)

Recommended setup for a game to allow easy mod management.

1. Start up OMM
2. Prepare you Game for mods
    1. `File -> New -> Software Context` (This represents the Game that you want to install mods to.)
    2. Set the path and name it to the game you want to mod. `(eg. D:\Games\OMM_GameMods\Automobilista)`
       
       ![](./setup_software_context.png)
    3. Set the path for the target where the mods should be installed into. 
        Keep the mods and backup folder to their default location.
       
       ![](./setup_target_location.png)
3. Open up the created context by  `File -> Open` or `File -> Recent contexts`

**TIP:**
Set that the just created context will automatically opened when OMM is started.

1. `Edit -> Manager Options...`
2. Add created Context to list. You can add multiple ones that can easily selected in OMM when started.

-----------------------------------------------------------------------------------------------------------

## 3. Add & Install Mods

To be able to add mods you your created game context you have two options:

### A. Network repositories

Uses mod URLs of your communities to be able download mods directly within OMM.

1. Open up the desired game context by  `File -> Open` or `File -> Recent contexts`
2. Open Target Location Properties (Game) by `Edit -> Target Location Properties` and switch to 
   network tab to add/remove URLs.

   ![](target_network_repository.png)
3. Add URL to your community mod repository and use the test button validate it.

   ![](add_network_repository.png)
5. Close Target Location Properties Dialog.
6. Select the Network Tab for your mod library and refresh the repository to fetch the mods.

   ![](target_network_repository_list.png)

7. Select your desired mods and download/update them into your [Local Mods](#local-mods)
   folder `(eg. D:\Games\OMM_GameMods\Automobilista\MainGame\Library)`

### B. Local Mods

All mods needs to be placed into your local mods folder to be able to activate/deactivate them for your game.
When using network repositories they will be downloaded into your local mods automatically for you.

![](target_local_library_list.png)

**OMM or OvGME prepared Mods**

1. Open up the desired game context by  `File -> Open` or `File -> Recent contexts`
2. Copy the mod *.zip to your library folder of your game
   context `(eg. D:\Games\OMM_GameMods\Automobilista\MainGame\Library)`
3. Added mods should now show up under the library tab (will be auto refreshed by OMM)

**Unprepared or Legacy mods**

TODO


-----------------------------------------------------------------------------------------------------------

## 3. Activate & Deactivate Mods
*Note:* On activation of a mod it will create a backup of all replaced files to restore them.

1. Open up the desired game context by  `File -> Open` or `File -> Recent contexts`
2. Single click on the desired mod to see its description.
3. Double click on the desired mod to activate/deactivate it.
   If there are dependencies (different icon) required it will ask to install them along or warn if not present.

-----------------------------------------------------------------------------------------------------------

## Prepare Mods for OMM usage

*(For Experienced Users)*

TODO

- Dependencies
- Folder Structure
- Use of the Package Manager
