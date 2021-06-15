---
---

Configuration
=======

## Headset Setup

1. Open the `SteamVR Dashboard` and click on the ReShade Settings button.
2. Un-tick `"Performance Mode"` checkbox to see the settings of the VRToolkit.
3. Use your VR pointer to Adjust the `"Circle Radius"` matching your HMD field of view sweet spot and to your personal view range.
    - Keep the radius as small as possible, but as well not to small to not loose sharpness.
4. Re-enable `"Performance Mode"` when done.

![HMD Configuration](./assets/images/vrtoolkit_config.jpg "HMD Configuration")

### Circle Radius
Try to get set up the smallest circle as possible to save GPU processing time. 
You can use the Recommended settings below as a good staring point.
A trick to see the mask better is to enable the `"Preview Sharpen Layer"` checkbox 
under sharpning settings when using mode 1

|  VR Headset (HMD)          | Circle Radius |
| -------------------------- | ------------- |
| Valve Index                |  0.25 to 0.35 |
| HP G1 & G2                 |  0.41 to 0.46 |


## Configure Preset 
*(For Experienced Users Only)*

You can adjust the VRToolkit settings by changing the shader modules and settings it has available.
The base `generic_vr` preset is configured to work without modification for almost all VR titles 
to look natural without artifacts. 

Its best to work on the vr mirror on the monitor while creating a new preset and fine tweak it later in VR.

1. Click on the **+** icon near the `generic_vr` preset to create a duplicate of the generic preset.
2. Un-tick `"Performance Mode"` checkbox to see the settings of the VRToolkit.
3. Hover over the `(?) Usage Help (?)` on the ReShade settings menu to see available modes.
4. Adjust settings to tweak the setting to your taste.
5. Re-enable `"Performance Mode"` when done.

### Hotkeys: 

- **CTRL+PRINT** => Creates a screenshot in the `.\ReShade\Screenshots` folder
- **CTRL+END** => Toggle all Reshade effect on/off *(Does not work in VR view yet)*
- **CTRL+POS1/HOME** => Enter Reshade config menu *(not visible in VR, only in the SteamVR desktop window)*.
  Use the SteamVR Dashboard instead.