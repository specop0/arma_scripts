// hide all terrain objects (Tanoa)
private _terrainObjects = nearestTerrainObjects [[5682.446,11060.217,0],[],15];
{
    hideObjectGlobal _x;
    _x allowDamage false;
} forEach _terrainObjects;

// hide some buildings in Mansoura (G.O.S. Al Rayak)
{
    _x params ["_pos","_distance"];
    {
        hideObjectGlobal _x;
    _x allowDamage false;
    } forEach nearestTerrainObjects [_pos ,["House"],_distance];
    {
        if(typeOf _x in ["Land_Terrace_K_1_EP1"]) then {
            hideObjectGlobal _x;
            _x allowDamage false;
        };
    } forEach nearestTerrainObjects [_pos ,[],_distance];
} forEach [
    [[6656.33,17368.2,0],50],
    [[6541.25,17385.1,0],50]
];

// hide some terrain objects in a straight line - here we only expect trees in the area, but do not check for them (Panthera)
// define the helper (invisible helipad) in the "correct direction", distance and width of rectangle to cut
private _treeCutter = [
    [treecutter_1, 150, 12],
    [treecutter_2, 80, 10]
];

{
    _x params ["_helper", "_distance", "_width"];
    private _pos = getPosASL _helper;
    {
        private _relativePos = _helper worldToModel (getPosASL _x);
        private _relativeWidth = _relativePos select 0;
        private _relativeDistance = _relativePos select 1;
        if(_relativeDistance > 0 && _relativeDistance < _distance && _relativeWidth > - _width && _relativeWidth < _width) then {
            hideObjectGlobal _x;
        };
    } foreach nearestTerrainObjects [_pos ,[],_distance];
} forEach _treeCutter;