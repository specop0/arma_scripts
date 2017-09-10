# ArmA (self written) scripts collection

### ammoBox.sqf
1. spawn ammunition box with parachute
2. land box safely (error: stuck in tree)
3. spawn enemy patrol as a drawback

### artillery.sqf
Lets group of artillery fire simultaneously at targets (with deviation)

### cleanup.sqf
Cleanup (land) units around marker (if no friendly unit present)

### destroyUnits.sqf
Destroys units (Man and LandVehicle) around given marker with given radius.

### heli_evac.sqf
1. spawn helicopter at defined marker
2. fly to player
3. liftoff if no man nearby
4. destination marker

### hh_service.sqf (by highhead)
simple script for a service point to perform a maintenance (repair, refuel, reammo) with german hints
http://www.tacticalteam.de/content/script-servicepoint

### hideTerrain_initServer.sqf
3 examples to hide terrain objects in the initServer.sqf

### jk_medicTent.sqf ([by jokoho48](https://github.com/jokoho48))
adds a Medical Tent to vehicles which can be built and used as an ACE medical facility
has to be torn down before it can be constructed again
1. add vehicles to JK_Medical_Vehicles
2. execute script on mission start (e.g. initPlayerLocal.sqf)

### laptop
take and put down a laptop - in initPlayerLocal.sqf
1. addAction to take a laptop (which is attached to the player) - attacheLaptop.sqf (see header for example usage)
2. addAction to the player to put the attached laptop down - detachLaptop.sqf (see header for example usage)

### plane.sqf
Spawn pilots into plane (plane takes off) and assigns waypoints (with flyInHeight)

### spawn_vehicle.sqf
Spawn vehicle at defined marker (if no vehicle of same type nearby)

### spec_cache
simple caching script for infantry
1. spawn groups in editor and set waypoints
2. add in init field: [this, numberOfGroup ] call Spec_cache_fnc_cacheGroup;
3. to spawn unit call (e.g. in trigger):
    * numberOfGroup call Spec_cache_fnc_spawnGroup;
    * numberOfGroup is unique (otherwise error is shown)

#### example mission
* see error that vehicle with crew can not be cached
* go near offroad to spawn patrolling team
* go to nearest armored vehicle to spawn crew at furthest armored vehicle (gets in and drives off)

### spec_cargoDrop
ACE Cargo droppable in flight with Parachute
1. in init of plane: [this] call Spec_cargoDrop_fnc_addParaDropEvent
* pilot and gunner (with EventHander GetIn) can drop ACE Cargo (interaction with plane)
* dropped cargo will land safely (see addParachute)
* optional: small crates (NATO_Box_Base) can be packed into big supply crate ([player] call Spec_cargoDrop_fnc_addPackAction)

### spec_checkpoint
Simple AI checkpoint script with smuggler (and intel) via ACE action.
* in Waypoint add to onAction: [this,"marker_target"] call Spec_checkpoint_fnc_addPassCheckAction
    * then vehicle and unit has ace action to pass the checkpoint and drives to given marker position
* in vehicle of smuggler add: [this call Spec_checkpoint_fnc_loadSmugglerItems to load nearby items (see const.hpp) into ace cargo
* in initPlayerLocal of HQ add: [this] call Spec_checkpoint_fnc_addTakeIntelAction to show how many smuggler reached their target
* to take (intel objects) via ace action add: [this] call Spec_checkpoint_fnc_addTakeIntelAction

### spec_construction
Simple construction script for static objects. A player or object can have an interaction to initiate construction progress (for a single object).
In addition a object can be assigned multiple objects of one type (inclusively race conditions).
* [truck,typeOf object, name of object, (number of animation),(number of objects)] call Spec_construct_fnc_objectAddConstructionStation;
* [player,actionID, name of action, typeOf object, (number of animation)] call Spec_construct_fnc_playerAddConstructAction;

### spec_crate
template for ammo crates

### spec_farming
Adds a waypoint to a single unit where a "farming" animation (crouch and stand up) is executed and another waypoint added.
* place (rectangle) marker to define a farming area
* place single civilian
    * in init field: this setVariable ["Spec_farming_marker", "marker_0"]

### spec_fullheal
1. add action to assign vehicle to provide full heal
if player enters this tagged vehicle he will be healed with ACE personal aid kit and get some bandages (if not exist in backpack)

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

### spec_medic
training station for ACE advanced medical
* spawn medic dummy with wounds
* assign as medic
* show medic data of ace of nearest man (if player is medic)
* spawn medic supply

### spec_mortar
training scripts for mk6 mortar with ACE (3CB BAF mortar)
* add in init field: [this] call Spec_mortar_fnc_addTrainingStation;
1. training station has ACE interaction to spawn crates (mortar, mortar ammo) and assign player to FAC
    1. FAC can spawn/move one target (offroad vehicle)
    2. FAC has different ACE self interactions to show info about target (liner, tip, solution)
    3. Hints are displayed if vehicle is hit/destroyed

### spec_presentation
simple slide show of pictures (e.g. at billboard)
1. in init.sqf: [sign_presentation, numberOfSlides, "pictureDirectory"] call Spec_presentation_fnc_addSlides OR [sign_presentationm, numberOfSlides] call Spec_presentation_fnc_addSlides (uses default directory "pictures")
2. object sign_presentation has addActions to navigate slides (calls are only handled from the server)
3. pictures have to be named presentation_xxx.jpg starting with presentation_000.jpg

### spec_tfar
1. for each unit 'setVariable ["Spec_var_TFARgroup", 0]'
2. edit group entries in fn_initGroups.sqf (see switch case)
3. sets TFAR frequencies according to Arrays (on Respawn)
to test (BFT values) team switch to unit and execute [player] call 'Spec_tfar_fnc_init'

### spec_zeus
* Curator unit sharing incl JIP/Respawn (from https://forums.bistudio.com/topic/166808-making-placed-units-be-editable-for-every-zeus/)
* placed units are transfered to the server (later extendable to headless client)
* currently serverID is determined in a bad way (with sleep 20)
1. add functions via header-file in descriptions.ext

### suicide.sqf
If conditions are met unit, vehicle or other attached object will trigger a explosion (with 3 possible sizes).
See file for usage.