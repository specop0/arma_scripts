// medevac
#define MEDEVAC_ID weiss
#define MEDEVAC_HELIPAD_BASE_ID landingpad_weiss

// name of get/setVariable
#define HELIPAD_GET_VARIABLE "helipad"
// hints
#define HINT_MEDEVAC_ON_MOVE "Hier Weiss\nSind auf dem Weg zu ihrer Position.\nWeiss Ende."
#define HINT_MEDEVAC_NEAR_LZ "Hier Weiss\nNaehern uns der LZ. Werfen Sie violetten Rauch.\nWeiss Ende."
#define HINT_MEDEVAC_NUMBER_OF_MAN_OUTSIDE "Noch %1 draussen."
#define HINT_MEDEVAC_LANDED "Touchdown!"
#define HINT_MEDEVAC_LIFTOFF "Liftoff!"

// parameters
// if this distance is the travel distance or less the script won't work (helicopter takes off instantly)
#define MEDEVAC_DISTANCE_TO_LZ 700 
#define MEDEVAC_HEIGHT_ABOVE_LZ 1
#define MEDEVAC_RADIUS_OF_UNITS_TO_LOAD 25

// retransfer
#define ALLOW_RETRANSFER_WITH_MEDEVAC 1
#define ACTION_MEDEVAC_RETRANSFER_NAME "Fliege Sie uns zurueck an die Front."
#define ACTION_MEDEVAC_RETRANSFER_ID "Spec_action_medevacRetransfer"
#define MEDEVAC_HELIPAD_BASE_VAR "Spec_var_landingPadBasePos"
#define MEDEVAC_HELIPAD_LAST_LZ_VAR "Spec_var_landingPadPos"


// heli taxi / logistic
#define HELI_TAXI_ID bussard
#define HELI_TAXI_HELIPAD_BASE_ID landingpad_bussard

// hints
#define HINT_HELI_TAXI_ON_MOVE "Hier Bussard\nSind auf dem Weg zu LZ Alpha.\nBussard Ende."
#define HINT_HELI_TAXI_NEAR_LZ "Hier Bussard\nNaehern uns der LZ. Werfen Sie violetten Rauch.\nBussard Ende."
#define HINT_HELI_TAXI_NUMBER_OF_MAN_OUTSIDE "Noch %1 draussen."
#define HINT_HELI_TAXI_LANDED "Touchdown!"
#define HINT_HELI_TAXI_LIFTOFF "Liftoff!"
#define HINT_HELI_TAX_LZ_MARKER_NOT_FOUND "Hier Bussard\nKoennen Markierung von LZ Alpha nicht finden. Bitte neu markieren.\nBussard Ende."

// parameters
// if this distance is the travel distance or less the script won't work (helicopter takes off instantly)
#define HELI_TAXI_DISTANCE_TO_LZ 700 
#define HELI_TAXI_HEIGHT_ABOVE_LZ 1
#define HELI_TAXI_RADIUS_OF_UNITS_TO_LOAD 25

// LZ marker parameters
#define MARKER_A_NAME "LZ Alpha"
#define MARKER_A_COLOR_SIDE "ColorBLUFOR"
#define MARKER_A_ID "Spec_marker_LZ"

#define ACTION_MOVE_MARKER_A_NAME "Bewege LZ"
#define ACTION_MOVE_MARKER_A_ID "Spec_action_moveMarkerLZ"
#define MOVE_MARKER_A_BOOL_VAR "Spec_var_selectLZ"