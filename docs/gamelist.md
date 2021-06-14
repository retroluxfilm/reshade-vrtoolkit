---
---

Game List
=======

### Game Presets:
These are special presets tailored for the specific game to work with additional VR Mods that would otherwise collide with the default procedure.
Additionally they contain color corrections LUT especially created for the game.

- [Automobilista](https://www.racedepartment.com/downloads/retrolux-reshade-automobilista.30742/)
- [GTR2](https://www.racedepartment.com/downloads/retrolux-reshade-gtr2.42342/)
- [Richard Burns Rally](https://www.racedepartment.com/threads/reshade-preset-for-rbr.166023/) *(VR not working yet)*


### Working

| Game                                | DLL         | Rename To      | Game Root Drop Folder                |
| ----------------------------------- | -----------:| --------------:|------------------------------------- |
| American Truck Simulator            |          64 |  dinput8.dll   | bin\win_x64                          |
| Automobilista 2                     |          64 |  opengl32.dll  | next to AMS2.exe                     |
| Asseto Corsa Competizione           |          64 |  dxgi.dll      | AC2\Binaries\Win64                   |
| Beat Saber                          |          64 |  dxgi.dll      | next to "Beat Saber.exe"             |
| DCS World                           |          64 |  dxgi.dll      | bin                                  |
| Dirt Rally (With Revive)            |          32 |  dxgi.dll      | next to drt.exe                      |
| Elite Dangerous                     |          64 |  d3d11.dll     | next to EliteDangerous64.exe         |
| Euro Truck Simulator 2              |          64 |  dinput8.dll   | bin\win_x64                          |
| Half Life Alyx                      |          64 |  kernel32.dll  | game\bin\win64                       |
| IL-2 Sturmovik Battle of Stalingrad |          64 |  dxgi.dll      | bin\game                             |
| Project Cars 2                      |          64 |  opengl32.dll  | next to pCARS2.exe                   |
| rFactor 2                           |          64 |  dxgi.dll      | Bin64                                |
| Skyrim VR                           |          64 |  dxgi.dll      | next to SkyrimVR.exe                 |
| VTOL VR                             |          64 |  dxgi.dll      | next to VTOLVR.exe                   |

### Not Working

- Walking Dead Saints and Sinners (one eye stays black)
- Race Room Experience (Crashes on start in VR on 32 & 64bit version)
- XPlane (Failed to create ImGui pipeline)