# ArmA (self written) scripts collection

### Abbreviations 
The code examples begin with a prefered calling method which is abbreviated
* The [Event-Scripts](https://community.bistudio.com/wiki/Event_Scripts)
    * initPlayerLocal.sqf
    * initServer.sqf 
* init Field of a unit
    * Plane.init: The init-field of a plane
* In activation of a Trigger
    * Trigger.OnActivation

### ammoBox.sqf
1. spawns ammunition box with parachute.
2. land box safely (error: stuck in tree)
3. spawn enemy patrol as a drawback

initPlayerLocal.sqf:
```
player addAction ["Spawn Ammobox", { _this call compile preprocessFileLineNumbers "ammoBox.sqf"; }];
```

### artillery.sqf
Lets group of artillery fire simultaneously at targets (with deviation). Source artillery verhicle and target object are hard coded.

Trigger.OnActivation:
```
[] call compile preprocessFileLineNumbers "artillery.sqf";
```

### cleanup.sqf
Cleanup (land) units around marker (if no friendly unit present)

initPlayerLocal.sqf:
```
player addAction ["Cleanup Iraklia", Spec_fnc_cleanup, [player,"cleanup_1",2000]];
```

### destroyUnits.sqf
Destroys units (Man and LandVehicle) around given marker with given radius.

Trigger.OnActivation:
```
["target1", 500] call compile preprocessFileLineNumbers "destroyUnits.sqf";
```

### heli_evac.sqf
1. spawns helicopter at defined marker (private _markerNameHeliSpawn = "heli_spawn";)
2. fly to player
3. liftoff if no man nearby
4. destination marker (private _markerNameBase = "ende";)

initPlayerLocal.sqf:
```
player addAction ["Call MedEvac", { _this call compile preprocessFileLineNumbers "heli_evac.sqf"; }];
```

### hh_service.sqf (by highhead)
simple script for a service point to perform a maintenance (repair, refuel, reammo) with german hints
http://www.tacticalteam.de/content/script-servicepoint

Trigger.OnActivation:
```
[thisList select 0] call compile preprocessFileLineNumbers "hh_service.sqf";
```

### hideTerrain_initServer.sqf
3 examples to hide terrain objects in the initServer.sqf

### Medic Tent

#### jk_medicTent.sqf ([by jokoho48](https://github.com/jokoho48))
Adds a Medical Tent to vehicles which can be built and used as an ACE medical facility has to be torn down before it can be constructed again.
1. add vehicles to JK_Medical_Vehicles (```JK_Medical_Vehicles = [zamak_medic];```)
2. execute script on mission start (e.g. initPlayerLocal.sqf: ```[] call compile preprocessFileLineNumbers "jk_medicTent.sqf";```)

#### jk_medicTent_backpack.sqf
Variant using Backpacks
1. add class names of supported backpacks to JK_SupportedBackpacks (```JK_SupportedBackpacks = ["B_Carryall_mcamo"];```)
2. execute script on mission start (e.g. initPlayerLocal.sqf: ```[] call compile preprocessFileLineNumbers "jk_medicTent_backpack.sqf";```)

### laptop
take and put down a laptop - in initPlayerLocal.sqf
1. addAction to take a laptop (which is attached to the player) - attacheLaptop.sqf (see header for example usage)
2. addAction to the player to put the attached laptop down - detachLaptop.sqf (see header for example usage)

### missionCheck.sqf
Checks if anything for a mission has been forgotten (e.g. respawn marker).

### plane.sqf
Spawn pilots into plane (plane takes off) and assigns waypoints (with flyInHeight). The names of the waypoints as well as other stuff are hard coded (```_markerNameWaypoints = ["wp1","wp2"];```)

MyPlane.init:
```
this addAction ["We are ready for take off.", {
    params ["_target", "_caller"];
    _target setVariable ["takeOffStarted", true, true];
    [_target] call compile preprocessFileLineNumbers "plane.sqf";
}, [], 1.5, false, true, "", "!(_target getVariable [""takeOffStarted"", false])"];
```

### spawn_vehicle.sqf
Spawn vehicle at defined marker (private _markerVehicleSpawn = "marker_spawner";) if no vehicle of same type nearby.

Noticeboard.init:
```
this addAction ["Spawn Vehicle", { _this call compile preprocessFileLineNumbers "spawn_vehicle.sqf"];
```

### spec_cache
simple caching script for infantry
1. spawn groups in editor and set waypoints
2. add in init field: ```[this, numberOfGroup ] call Spec_cache_fnc_cacheGroup;```
3. to spawn unit call (e.g. in trigger):
    * ```numberOfGroup call Spec_cache_fnc_spawnGroup;```
    * numberOfGroup is unique (otherwise error is shown)

#### example mission
* see error that vehicle with crew can not be cached
* go near offroad to spawn patrolling team
* go to nearest armored vehicle to spawn crew at furthest armored vehicle (gets in and drives off)

### spec_cargoDrop
ACE Cargo droppable in flight with Parachute
* pilot and gunner (with EventHander GetIn) can drop ACE Cargo (interaction with plane)
* dropped cargo will land safely (see addParachute)
* optional: small crates (NATO_Box_Base) can be packed into big supply crate (```[player] call Spec_cargoDrop_fnc_addPackAction;```)

Plane.init:
```
[this] call Spec_cargoDrop_fnc_addParaDropEvent;
```

### spec_checkpoint
Simple AI checkpoint script with smuggler (and intel) via ACE action.
* in Waypoint add to onAction: ```[this,"marker_target"] call Spec_checkpoint_fnc_addPassCheckAction;```
    * then vehicle and unit has ace action to pass the checkpoint and drives to given marker position
* in vehicle of smuggler add: ```[this call Spec_checkpoint_fnc_loadSmugglerItems;``` to load nearby items (see const.hpp) into ace cargo
* in initPlayerLocal of HQ add: ```[this] call Spec_checkpoint_fnc_addTakeIntelAction;``` to show how many smuggler reached their target
* to take (intel objects) via ace action add: ```[this] call Spec_checkpoint_fnc_addTakeIntelAction;```

### spec_construction
Simple construction script for static objects. A player or object can have an interaction to initiate construction progress (for a single object). In addition a object can be assigned multiple objects of one type (inclusively race conditions).
* ```[truck,typeOf object, name of object, (number of animation),(number of objects)] call Spec_construct_fnc_objectAddConstructionStation;```
* ```[player,actionID, name of action, typeOf object, (number of animation)] call Spec_construct_fnc_playerAddConstructAction;```

### spec_crate
Template for ammo crates
* After mission start (fn_postInit.sqf) all available crates are searched for specific types and refilled (e.g. "TTT_Logistik_Medic_Bw" is filled with ACE medic content)
* Contains a crate filler

### spec_farming
Adds a waypoint to a single unit where a "farming" animation (crouch and stand up) is executed and another waypoint added.
* place (rectangle) marker to define a farming area
* place single civilian
    * in init field: ```this setVariable ["Spec_farming_marker", "marker_0"];```

### spec_fullheal
1. add action to assign vehicle to provide full heal
if player enters this tagged vehicle he will be healed with ACE personal aid kit and get some bandages (if not exist in backpack

initPlayerLocal.sqf:
```
[noticeboard_spawnerA, "spawnerA", 1, 5] call Spec_fullheal_fnc_addAssignVehicleAction;
```

### spec_heli
two different upgrades of heli_evac.sqf which use a helicopter placed in the editor
1. Spec_heli_fnc_taxi (taxi.sqf) and Spec_heli_fnc_moveMarkerLZ (moveMarkerLZ.sqf)
    1. choose ace action to mark a LZ
    2. if player clicks on map a LZ marker will be placed (visible for everyone and unique name)
    3. if helicopter is called flies to marker position and flies off to base if no man nearby
2. Spec_heli_fnc_medEvac (medEvac.sqf) (Spec_heli_fnc_medEvacRetransfer heli_medevac_retransfer)
    1. helicopter flies to player/caller position
    2. flies to base if no man nearby
    3. unloaded passenger will be fully healed with a PAK (from ACE Advanced Medic)
    4. optional (heli_medevac_retransfer): ace action is to retransfer to last called LZ

initPlayerLocal.sqf:
```
private _actionMedevac = ["Spec_action_callMedevac", "Call MedEvac", "", {_this remoteExec ["Spec_fnc_heli_medevac",2]}, {true}] call ace_interact_menu_fnc_createAction;
[player,1, ["ACE_SelfActions"], _actionMedevac] call ace_interact_menu_fnc_addActionToObject;
[] call Spec_fnc_moveMarkerLZ;
private _actionBussard = ["Spec_action_callBussard", "Call Transport", "", {_this remoteExec ["Spec_fnc_heli_taxi",2]}, {true}] call ace_interact_menu_fnc_createAction;
[player,1, ["ACE_SelfActions"], _actionBussard] call ace_interact_menu_fnc_addActionToObject;
```

Name of Helicopter and Helipad in Editor are defined in const.hpp
```
#define MEDEVAC_ID weiss
#define MEDEVAC_HELIPAD_BASE_ID landingpad_weiss
#define HELI_TAXI_ID bussard
#define HELI_TAXI_HELIPAD_BASE_ID landingpad_bussard
```

### spec_medic
training station for ACE advanced medical
* spawn medic dummy with wounds
* assign as medic
* show medic data of ace of nearest man (if player is medic)
* spawn medic supply

initPlayerLocal.sqf:
```
[sign_medic_area, medic_mat_1, "Medic Dummy A"] call Spec_medic_fnc_addTrainingStation;
```

### spec_mortar
training scripts for mk6 mortar with ACE (3CB BAF mortar)
* add in init field: ```[this] call Spec_mortar_fnc_addTrainingStation;```
1. training station has ACE interaction to spawn crates (mortar, mortar ammo) and assign player to FAC
    1. FAC can spawn/move one target (offroad vehicle)
    2. FAC has different ACE self interactions to show info about target (liner, tip, solution)
    3. Hints are displayed if vehicle is hit/destroyed

### spec_presentation
simple slide show of pictures (e.g. at billboard)
1. in init.sqf: ```[sign_presentation, numberOfSlides, "pictureDirectory"] call Spec_presentation_fnc_addSlides;``` OR ```[sign_presentationm, numberOfSlides] call Spec_presentation_fnc_addSlides;``` (uses default directory "pictures")
2. object sign_presentation has addActions to navigate slides (calls are only handled from the server)
3. pictures have to be named presentation_xxx.jpg starting with presentation_000.jpg

### spec_tfar
1. for each unit ```setVariable ["Spec_var_TFARgroup", 0];```
2. edit group entries in fn_initGroups.sqf (see switch case)
3. sets TFAR frequencies according to Arrays (on Respawn)
to test (BFT values) team switch to unit and execute ```[player] call "Spec_tfar_fnc_init";```

### spec_zeus
* Curator unit sharing incl JIP/Respawn (from https://forums.bistudio.com/topic/166808-making-placed-units-be-editable-for-every-zeus/)
* placed units are transfered to the server (later extendable to headless client)
* currently serverID is determined in a bad way (with sleep 20)
1. add functions via header-file in descriptions.ext

### suicide.sqf
If conditions are met unit, vehicle or other attached object will trigger a explosion (with 3 possible sizes).

Trigger.OnActivation:
```
[bomberA, 100, "Die!", 1, "SMALL"] call compile preprocessFileLineNumbers "suicide.sqf";
```

The (sever-only) trigger should be attached to bomberA (via initServer.sqf).