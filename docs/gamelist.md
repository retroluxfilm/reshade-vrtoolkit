---
---

Game List
=======

## Game Presets
These are special presets tailored for the specific game to work with additional VR Mods that would otherwise collide with the default procedure.
Additionally they contain color corrections LUT especially created for the game.

- [Automobilista](https://www.racedepartment.com/downloads/retrolux-reshade-automobilista.30742/)
- [GTR2](https://www.racedepartment.com/downloads/retrolux-reshade-gtr2.42342/)
- [Richard Burns Rally](https://www.racedepartment.com/threads/reshade-preset-for-rbr.166023/)


### Working
Here is a list of tested games that work with ReShade.
Many more will work and require to figure out what settings it needs.
Feel free to contribute to get that list up to date :)

| Game                                | DLL         | Rename To      | Extract to Folder                    |
| ----------------------------------- | -----------:| --------------:|------------------------------------- |
| American Truck Simulator            |          64 |  dinput8.dll   | bin\win_x64                          |
| Automobilista 2                     |          64 |  opengl32.dll  | next to AMS2.exe                     |
| Asseto Corsa                        |          64 |  dxgi.dll      | next to AssettoCorsa.exe             |
| Asseto Corsa Competizione           |          64 |  dxgi.dll      | AC2\Binaries\Win64                   |
| Beat Saber                          |          64 |  dxgi.dll      | next to "Beat Saber.exe"             |
| DCS World                           |          64 |  dxgi.dll      | bin                                  |
| Dirt Rally (With Revive)            |          32 |  dxgi.dll      | next to drt.exe                      |
| Dirt Rally 2                        |          64 |  dinput8.dll   | next to dirtrally2.exe               |
| Elite Dangerous                     |          64 |  d3d11.dll     | next to EliteDangerous64.exe         |
| Euro Truck Simulator 2              |          64 |  dinput8.dll   | bin\win_x64                          |
| Google Earth VR                     |          64 |  opengl32.dll  | next to Earth.exe                    |
| Half Life Alyx                      |          64 |  kernel32.dll  | game\bin\win64                       |
| IL-2 Sturmovik Battle of Stalingrad |          64 |  dxgi.dll      | bin\game                             |
| Project Cars 2                      |          64 |  opengl32.dll  | next to pCARS2.exe                   |
| Race Room Experience 64 Bit         |          64 |  dxgi.dll      | Game\x64\                            |    
| Race Room Experience 32 Bit         |          32 |  dxgi.dll      | Game\                                |
| rFactor 2                           |          64 |  dxgi.dll      | Bin64                                |
| Skyrim VR                           |          64 |  dxgi.dll      | next to SkyrimVR.exe                 |
| VTOL VR                             |          64 |  dxgi.dll      | next to VTOLVR.exe                   |
| The Walking Dead Saints and Sinners |          64 |  dxgi.dll      | TWD\Binaries\Win64\                  |

### Not Working

- XPlane (Failed to create ImGui pipeline)

## Known Issues

- **Steam VR Reshade Settings window & effects flicker**

  This is caused when the render target switches, especially prominent on games that dynamically
  change the resolution like Half Life Alyx does.
