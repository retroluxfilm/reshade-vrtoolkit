---
---

VRToolkit
=======

The VRToolkit is a modular shader created for [ReShade](https://github.com/crosire/reshade)
to enhance the clarity & sharpness in VR to get most out of your HMD while keeping the performance impact minimal.

### Main Features

- Sharpening Modes for enhanced clarity while only processing the pixels that are in the sweet spot of your HMD
- Color Correction Modes to be able to adjust your HMD colors & contrast to your liking
- Dithering to reduce banding effects of gradients and sharpening artifacts
- All modules are processed in a single render pass post shader to improve performance instead of having them all separate

*Note: ReShade currently only works on games run through SteamVR. (OpenVR API)*

### Known Issues

- Opening the `Preprocessor Settings` in the SteamVR Reshade menu crashes the game.
  As a workaround you need to use the screen mirror to change the preprocessor settings
  and then use the `reload button` it from the SteamVR Reshade to apply the settings.
- On some games like "Asseto Corsa Competizione" one eye can remain black in the headset.
  This is caused by the vr pixel count and can be fixed by going up and down a few steps until it works.
