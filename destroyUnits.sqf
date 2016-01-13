/*
	Author: SpecOp0

	Description:
	Destroys units (Man and LandVehicle) around given marker with given radius.
	Sleeps between each valid unit 1 second.

	Parameter(s):
	0: STRING - marker name
	1: NUMBER - radius to destroy units

	Returns:
	true
*/

if(isServer) then {
	private _scriptHanddle = _this spawn {
		params [ ["_markerName","",[""]], ["_radius",0,[0]]  ];
		private _markerPos = getMarkerPos _markerName;
		if(_markerPos select 0 != 0 && _markerPos select 1 != 0) then {
			private _objectList = nearestObjects [_markerPos, ["LandVehicle","Man"], _radius];
			{
				if(!isNull _x && {!isPlayer _x && getDammage _x != 1}) then {
					_x allowDamage true;
					_x setDamage 1;
					sleep 1;
				};
			} forEach _objectList;
		} else {
			["Wrong Parameter: Marker %1 does not exist (or has x- and y-coordinate 0).", _markerName] call BIS_fnc_error;
		};
	};
};
true
