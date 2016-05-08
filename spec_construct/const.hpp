// deconstruct (for constructed object) available
#define SPEC_BUILD_DESTRUCTION_AVAILABLE true
// use key handler (arrow keys) to adjust building [added for each local object, global EH possible]
#define SPEC_BUILD_USE_KEY_HANDLER true

// local attached object parameter
#define SPEC_VAR_ATTACHED_OBJECT "Spec_var_building_attachedObject"
#define SPEC_VAR_OFFSET_HEIGHT "Spec_var_building_attachedObject_heightOffset"
#define SPEC_VAR_OFFSET_DISTANCE "Spec_var_building_attachedObject_distanceOffset"

#define SPEC_VAR_OFFSET_TYPE_HEIGHT "changeHeight"
#define SPEC_VAR_OFFSET_TYPE_DISTANCE "changeDistance"

#define SPEC_BUILD_OFFSET_MULTI 0.1
#define SPEC_ATTACHED_OBJECT_EXTRA_DISTANCE 2

// animation, time and hint when building
#define SPEC_ACTION_BUILD_ANIMATION "Acts_carFixingWheel"
#define SPEC_ACTION_BUILD_ANIMATION_TIME 12
#define SPEC_ACTION_BUILD_STATUS_TEXT "%1/%2"

#define SPEC_HINT_MAN_NEARBY "Ein anderer Mensch ist im Weg!"
#define SPEC_HINT_NUMBER_OF_OBJECTS_LEFT "Noch %1 uebrig"

// bounding box
#define SPEC_FNC_IS_BOUNDING_BOX_FREE Spec_construct_fnc_isBoundingBoxFree
#define SPEC_BOUNDING_BOX_EXTRA_RADIUS 2

// ace actions (extern)
#define SPEC_ACTION_ATTACH_BOOL_STR "%1_bool"

// ace actions (intern)
#define SPEC_FNC_CONSTRUCT_ACTION Spec_construct_fnc_constructObject
#define SPEC_ACTION_CONSTRUCT_ID "Spec_action_build"
#define SPEC_ACTION_CONSTRUCT_NAME "Baue auf"
#define SPEC_ACTION_CONSTRUCT_NAME_PARAM "Baue %1 auf"

#define SPEC_FNC_ABORT_CONSTRUCT Spec_construct_fnc_abortConstruction
#define SPEC_ACTION_ABORT_ID "Spec_action_abort"
#define SPEC_ACTION_ABORT_NAME "Abbrechen"

#define SPEC_FNC_DECONSTRUCT_ACTION Spec_construct_fnc_destructObject
#define SPEC_ACTION_DESTRUCT_ID "Spec_action_destruct"
#define SPEC_ACTION_DESTRUCT_NAME "Baue ab"

#define SPEC_FNC_OFFSET_CONSTRUCTION Spec_construct_fnc_changeOffset
#define SPEC_VAR_OFFSET_INCREASE 1
#define SPEC_VAR_OFFSET_DECREASE -1

#define SPEC_ACTION_UP_ID "Spec_action_up"
#define SPEC_ACTION_UP_NAME "Hoeher"

#define SPEC_ACTION_DOWN_ID "Spec_action_down"
#define SPEC_ACTION_DOWN_NAME "Niedriger"

#define SPEC_ACTION_FAR_ID "Spec_action_far"
#define SPEC_ACTION_FAR_NAME "Weiter weg"

#define SPEC_ACTION_NEAR_ID "Spec_action_near"
#define SPEC_ACTION_NEAR_NAME "Naeher heran"

// other functions
#define SPEC_FNC_CLEAR_ATTACHED_OBJECT Spec_construct_fnc_clearAttachedObjectActions
#define SPEC_FNC_ATTACH_OBJECT Spec_construct_fnc_attachObject

#define SPEC_FNC_PLAYER_ADD_CONSTRUCT_ACTION Spec_construct_fnc_playerAddConstructAction
#define SPEC_FNC_OBJECT_ADD_CONSTRUCT_ACTION Spec_construct_fnc_objectAddConstructAction
#define SPEC_FNC_COBJECT_ADD_CONSTRUCTION_STATION Spec_construct_fnc_objectAddConstructionStation

#define SPEC_FNC_ADD_KEY_HANDLER Spec_construct_fnc_changeOffsetAddKeyHandler
#define SPEC_FNC_KEY_HANDLER Spec_construct_fnc_changeOffsetKeyHandler