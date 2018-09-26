#define ADDON ace_cargo
#define PREFIX ace

#define DOUBLES(var1,var2) ##var1##_##var2
#define TRIPLES(var1,var2,var3) ##var1##_##var2##_##var3
#define QUOTE(var1) #var1

#define GVAR(var1) DOUBLES(ADDON,var1)
#define EGVAR(var1,var2) TRIPLES(ADDON,var1,var2)
#define QGVAR(var1) QUOTE(GVAR(var1))

#define FUNC(var1) TRIPLES(ADDON,fnc,var1)
#define FUNCMAIN(var1) TRIPLES(PREFIX,fnc,var1)
#define FUNC_INNER(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)
#define EFUNC(var1,var2) FUNC_INNER(var1,var2)

#ifndef STRING_MACROS_GUARD
#define STRING_MACROS_GUARD
    #define LSTRING(var1) QUOTE(TRIPLES(STR,ADDON,var1))
    #define ELSTRING(var1,var2) QUOTE(TRIPLES(STR,DOUBLES(PREFIX,var1),var2))
    #define CSTRING(var1) QUOTE(TRIPLES($STR,ADDON,var1))
    #define ECSTRING(var1,var2) QUOTE(TRIPLES($STR,DOUBLES(PREFIX,var1),var2))
#endif

// onMenuOpen uses DFUNC
#define DGVAR(varName)    if(isNil "ACE_DEBUG_NAMESPACE") then { ACE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(GVAR(varName)) in ACE_DEBUG_NAMESPACE)) then { PUSH(ACE_DEBUG_NAMESPACE, QUOTE(GVAR(varName))); }; GVAR(varName)
#define DVAR(varName)     if(isNil "ACE_DEBUG_NAMESPACE") then { ACE_DEBUG_NAMESPACE = []; }; if(!(QUOTE(varName) in ACE_DEBUG_NAMESPACE)) then { PUSH(ACE_DEBUG_NAMESPACE, QUOTE(varName)); }; varName
#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)
#define DEFUNC(var1,var2) TRIPLES(DOUBLES(PREFIX,var1),fnc,var2)