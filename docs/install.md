---
---

Installation
=======

### Option A: Per Game 

1. Download the [Latest Release]({{ site.github.releases[0].assets[0].browser_download_url }}) `VRToolkitReshadeUniversal_*.zip`
2. Check the [Game List](/gamelist.html) for the game you want to use it on.
3. Extract the contents of the release zip into the required folder of the game.
   If the game is not listed, you usually place it next where the game executable is located.
4. Rename the `ReShade64.dll` or `ReShade32.dll` depending on the required DLL.
   Usually modern games use the 64 bit version and renamed to dxgi.dll.
5. Start up the game and then [Configure your HMD settings](/configuration.html)
6. *Optional:* Change the [default preset or create your own](/presets.html) 

*Note: For OpenXR Games you need to use the [Reshade Setup](https://github.com/retroluxfilm/reshade-vrtoolkit/releases/download/v1.1.0/ReShade.Setup_5.9.3-preview.exe)*


### Option B: Global
*(For Experienced Users Only)*

This installation type allows to update the toolkit easily for all games you use it on and keep
all the files in on one central place. It uses symlinks that are placed on each game that point
to the install directory of the VRToolkit.

**Prepare Global VRToolkit**
1. Install [Link Shell Extension](https://schinagl.priv.at/nt/hardlinkshellext/linkshellextension.html) 
   to create symlinks easily.
1. Download the [Latest Release]({{ site.github.releases[0].assets[0].browser_download_url }}) `VRToolkitReshadeUniversal_*.zip`
3. Extract the contents of the release zip into a global folder you want the toolkit to installed
   (eg. D:\Games\VRToolkit)
   
**Link to Game**
1. Go to the global VRToolkit installation folder and select all files. (Reshade folder + ini + *.dll)
2. Right click on the selected files and choose "Pick Link Source"
3. Navigate to the folder of the game ([Game List](/gamelist.html)) and right click on the destination
   folder and choose "Drop As... -> Symbolic link". Now all required files should be placed to the game directory.
4. Rename the symlinked `ReShade64.dll` or `ReShade32.dll` in the game folder depending on the required DLL.
   Usually modern games use the 64 bit version and renamed to dxgi.dll.
   
5. Start up the game and then [Configure your HMD settings](/configuration.html)
6. Optional: Change the [default preset  or create your own](/presets.html) 