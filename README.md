VRToolkit
=======

The VRToolkit is a shader created for [ReShade](https://github.com/crosire/reshade) to support the visuals fidelity in VR by combining multiple shaders to be processed into one single pass, while keeping the GPU overhead at a minimum.

*Note: Does only work on SteamVR.* 

### Main Features

- Sharpening Modes for enhanced clarity while only processing the pixels that are in the sweep spot of your HMD
- Color Correction Modes to be able to adjust your HMD colors to match
- Dithering to reduce banding effects of gradients

## How to install

**Complete Package** *(Recommended)*

1. Download the [Latest Release](https://gitlab.com/Retrolux/reshade-vrtoolkit/-/releases)
2. Check the `Game List` below for the game you want to use it on.    
3. Extract the contents of the release into the required folder. 
   If the game is not listed below its usually next where the game executable is located.
4. Rename the `ReShade64.dll` or `ReShade32.dll` depending on the required DLL. 
   Usually modern games use the 64 bit version and renamed to dxgi.dll.
5. Start up the game and adjust your HMD settings & preset if required *(see section below)*

**Official Way** (*Note: VR support is not released yet*)

1. Download [ReShade](https://reshade-me) from the official website.
2. Run the installer and select the game from the list.
3. Choose the required Rendering pipeline (modern games often use Direct3D 10/11/12)
4. On the "Shader Effect Packages" Screen of the add the url `https://gitlab.com/Retrolux/reshade-vrtoolkit`
   of the VRToolkit to the list. Click on Add and select the checkbox.
5. Start up the game and enable the VRToolkit.fx effect from the list and 
   adjust your HMD settings & preset if required *(see section below)*

## Configure your HMD and preset

1. Open Reshade Config Menu in SteamVR (Reshade icon in the dashboard)
2. Untick "Peformance Mode" checkbox and go to the VRToolkit tab
3. Adjust your "Sharpening Mask Radius" matching your HMD field of view sweet spot to your personal view range.
   - Keep the radius as small as possible, but as well not to small to not loose sharpness.
4. **Optional:** Change sharpening mode and color correction mode + settings to your liking.
   Hover over the `(?) Usage Help (?)` for mode instruction.
5. Enable "Peformance Mode" when done 


Game List
---------

### Working

#### Dedicated Presets:
These are special presets tailored for the specific games work with additional VR Mods that would otherwise collide with the default procedure.
Additionally they contain color correction and adjustments especially created for the game.

- [Automobilista](https://www.racedepartment.com/downloads/retrolux-reshade-automobilista.30742/)
- [GTR2](https://www.racedepartment.com/downloads/retrolux-reshade-gtr2.42342/)
- [Richard Burns Rally](https://www.racedepartment.com/threads/reshade-preset-for-rbr.166023/) *(VR not working yet)*

---

| Game                                | DLL         | Rename To      | Drop Folder                                      | Status        |
| ----------------------------------- | -----------:| --------------:|------------------------------------------------- |:-------------:|
| Automobilista 2                     |          64 |  opengl32.dll  | Root Folder (next to AMS2.exe)                   | Working       |
| Asseto Corsa                        |          64 |  dxgi.dll      | Root Folder (next to assetocorsa.exe)            | Working       |
| Asseto Corsa Competizione           |          64 |  dxgi.dll      | Root Folder \AC2\Binaries\Win64                  | Working       |
| Dirt Rally                          |          32 |  dxgi.dll      | Root Folder (next to drt.exe)                    | Working       |
| IL-2 Sturmovik Battle of Stalingrad |          64 |  dxgi.dll      | Root Folder \bin\game                            | Working       |
| Project Cars 2                      |          64 |  opengl32.dll  | Root Folder (next to pCARS2.exe)                 | Working       |
| VTOL VR                             |          64 |  dxgi.dll      | Root Folder (next to VTOLVR.exe)                 | Working       |

### Not Working
- American Truck Simulator
- Euro Truck Simulator 2
