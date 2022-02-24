---
---

Automobilista 1 VR Guide (WIP)
===============
This guide will focus on setting up Automobilista 1 for VR and 
getting the best experience out from it.

Setup
---------------
Download the latest release here: [AMS1 VR MOD](http://crewchief.isnais.de/AMS_VR_beta.zip)
Creator Post and Support Link: https://forum.reizastudios.com/threads/ams1-working-in-vr.14245/  
Nils Tutorial: https://www.youtube.com/watch?v=JsCwdixVCJM

Performance & Tweaks
---------------
AMS 1 uses the isiMotor2 engine that still uses DirectX9 as rendering API.<br>
In addition, the game runs in 32 bit. This has the following downsides:
- Limited Memory address range 4GB
- Single core rendering where the CPU often gets exhausted when to many objects are rendered. 
- VR will require the double amount of work as it needs to render both eyes for each frame.

### In-game Settings ###

#### Display ####

Exit to Confirmation Menu = off

Head Movement = 0%  
Look to the Apex = 0%  
Lock to Horizon = 100%  

#### Graphics #### 
Shadows = Medium  
SpecialFX = Low  
Number of Visible Cars = 10-15


### User file *.plr settings ###

CPU & GPU performance improvements to help to reduce the amount of rendered objects (batches)

```ini
[ Graphic Options ]
Rearview Cull="1" // enable that objects in the mirros are culled out of view (lower objects to render)
Rearview_Back_Clip="250.00000" // overrides a fixed rear mirror rendering distance regardless of the track settings 
Rearview Particles="0"  // disables particles in the rear mirrors to reduce CPU impact
Self In Cockpit Rearview="0" // reduce uneeded and often buggy read mirror onbjects of the own car 
Garage Detail="0.15000" // LOD multiplier when vehicle is in garage (0.01-1.00)
Shadow Updates="1" // Static shadow updates per frame (Shadow Updates * Sky Update Frames should exceed number of static shadows on track)
Sky Update Frames="900" // Frames between sky and light updates
Max Headlights="5" // Max headlights visible relative to your car.
```

Reduce camera shaking for VR to reduce motion sickness

```ini
[ Graphic Options ]
Cockpit Vibration Mult1="0.00000" // Primary vibration multiplier affects eyepoint position (base magnitude is in VEH or cockpit file)
Cockpit Vibration Mult2="0.00000" // Secondary vibration multiplier affects eyepoint orientation (base magnitude is in VEH or cockpit file)
Head Physics="0.00000" // Fraction of head physics movement applied to cockpit view (position AND rotation)
```

### User controller.ini
For some Direct Drive wheels it can help to lower the FFB rate to reduce the CPU impact.
```ini
[ Force Feedback ]
FFB Effects Level="1"
FFB Skip Updates="7"
```