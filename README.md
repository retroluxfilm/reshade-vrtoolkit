![VrToolkit](https://github.com/retroluxfilm/reshade-vrtoolkit/blob/gh-pages/assets/vrtoolkit_header.png)

The VRToolkit is a modular shader created for [ReShade](https://github.com/crosire/reshade) 
to increase the fidelity in VR to get most out of your HMD by increasing sharpness while keeping the performance impact minimal.

### Main Features

- Sharpening Modes for enhanced clarity while only processing the pixels that are in the sweep spot of your HMD
- Color Correction Modes to be able to adjust your HMD colors & contrast to your liking
- Dithering to reduce banding effects of gradients and sharpening artifacts
- All modules are done in a single pass post shader to improve performance then having them all separate

*Note: Only works on games run through SteamVR. (OpenVR API)*

-----------------------------
 How to install
-----------------------------

**Complete Package** *(Recommended)*

1. Download the [Latest Release](https://github.com/retroluxfilm/reshade-vrtoolkit/releases) `VRToolkitReshadeUniversal_*.zip`
2. Check the [Game List](https://github.com/retroluxfilm/reshade-vrtoolkit#game-list) 
   below for the game you want to use it on.    
3. Extract the contents of the release zip into the required game folder. 
   If the game is not listed below its usually next where the game executable is located.
4. Rename the `ReShade64.dll` or `ReShade32.dll` depending on the required DLL. 
   Usually modern games use the 64 bit version and renamed to dxgi.dll.
5. Start up the game and [Confiure your HMD settings](https://github.com/retroluxfilm/reshade-vrtoolkit#configure-your-hmd-and-preset) 


## Configure your HMD and preset

1. Open `SteamVR Dashboard` and open the ReShade Settings (circle Reshade icon in the bottom of the dashboard)
2. Un-tick `"Performance Mode"` checkbox to see the settings of the VRToolkit
3. Use your VR pointer to Adjust the `"Circle Radius"` matching your HMD field of view sweet spot and to your personal view range.
   - Keep the radius as small as possible, but as well not to small to not loose sharpness.
4. **Optional:** Change sharpening mode and color correction mode + settings to your liking.
   Hover over the `(?) Usage Help (?)` for selectable modes.
5. Re-enable `"Performance Mode"` when done 

**Recommended HMD Settings**

|  VR Headset (HMD)          | Circle Radius |
| -------------------------- | ------------- |
| Valve Index                |  0.25 to 0.35 |
| HP G1 & G2                 |  0.41 to 0.46 |

-----------------------------
Hotkeys:
-----------------------------

- *CTRL+PRINT* => Creates a screenshot in the `.\ReShade\Screenshots` folder
- *CTRL+END* => Toggle all Reshade effect on/off *(Does not work in VR view yet)*
- *CTRL+POS1/HOME* => Enter Reshade config menu *(not visible in VR, only in the steamVR desktop window)*.
   Use the SteamVR Dashboard instead.

-----------------------------
Game List
-----------------------------

### Working

#### Dedicated Presets:
These are special presets tailored for the specific games work with additional VR Mods that would otherwise collide with the default procedure.
Additionally they contain color correction and adjustments especially created for the game.

- [Automobilista](https://www.racedepartment.com/downloads/retrolux-reshade-automobilista.30742/)
- [GTR2](https://www.racedepartment.com/downloads/retrolux-reshade-gtr2.42342/)
- [Richard Burns Rally](https://www.racedepartment.com/threads/reshade-preset-for-rbr.166023/) *(VR not working yet)*

---

| Game                                | DLL         | Rename To      | Drop Folder                                      |
| ----------------------------------- | -----------:| --------------:|------------------------------------------------- |
| American Truck Simulator            |          64 |  dinput8.dll   | Root Folder \bin\win_x64                         |
| Automobilista 2                     |          64 |  opengl32.dll  | Root Folder (next to AMS2.exe)                   |
| Asseto Corsa Competizione           |          64 |  dxgi.dll      | Root Folder \AC2\Binaries\Win64                  |
| Beat Saber                          |          64 |  dxgi.dll      | Root Folder (next to Beat Saber.exe)             |
| DCS World                           |          64 |  dxgi.dll      | Root Folder \bin                                 |
| Dirt Rally (With Revive)            |          32 |  dxgi.dll      | Root Folder (next to drt.exe)                    |
| Elite Dangerous                     |          64 |  d3d11.dll     | Root Folder (EliteDangerous64.exe)               |
| Euro Truck Simulator 2              |          64 |  dinput8.dll   | Root Folder \bin\win_x64                         |
| Half Life Alyx                      |          64 |  kernel32.dll  | Root Folder \game\bin\win64                      |
| IL-2 Sturmovik Battle of Stalingrad |          64 |  dxgi.dll      | Root Folder \bin\game                            |
| Project Cars 2                      |          64 |  opengl32.dll  | Root Folder (next to pCARS2.exe)                 |
| rFactor 2                           |          64 |  dxgi.dll      | Root Folder \Bin64                               |
| Skyrim VR                           |          64 |  dxgi.dll      | Root Folder (next to SkyrimVR.exe)               |
| VTOL VR                             |          64 |  dxgi.dll      | Root Folder (next to VTOLVR.exe)                 |

### Not Working

- Walking Dead Saints and Sinners (one eye stays black)
- Race Room Experience (Crashes on start in VR on 32 & 64bit version)
- XPlane (Failed to create ImGui pipeline)

Known Issues & Limitations
---------
- Opening the **Preprocessor Settings** in the SteamVR Reshade menu crashes the game. 
  As a workaround you need to use the screen mirror to change the preprocessor settings
  and then use the `reload button` it from the SteamVR Reshade to apply the settings.  
- On some games like Asseto Corsa Competizione one eye can remain black in the headset. 
  This is caused by the vr pixel count and can be fixed by going up and down a few steps until it works.
