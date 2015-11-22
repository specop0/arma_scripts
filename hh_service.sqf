//Made by Highhead
//1.0 - 06.03.2015
//from scratch
//1.1 - 22.11.2015
//added spawn if used compiled and local variables (by Spec)

private ["_scriptHandle"];
_scriptHandle = _this spawn {
	if(params [ ["_object",objNull,[objNull]] ]) then {
		private ["_delay"];
		_delay = 5;
		
		_object setFuel 0;
		_object vehicleChat format ["Wartung wird durchgeführt... Bitte warten..."];
		_object vehicleChat format ["Aufmunitionieren der Primärwaffen..."];
		sleep _delay;
		_object vehicleChat format ["Aufmunitionieren der Sekundärwaffen..."];
		sleep _delay;
		_object vehicleChat format ["Aufmunitionieren abschließen..."];
		_object setVehicleAmmo 1;
		sleep _delay;
		_object vehicleChat "Instandsetzung...";
		sleep _delay;
		_object setDamage 0;
		_object vehicleChat "Auftanken...";
		sleep _delay;
		_object setFuel 1;
		sleep _delay;
		_object vehicleChat "Wartung ist abgeschlossen!";
	} else {
		["Wrong Parameter: Expected object to perform a maintenance. Called manually?"];
	};
};
true
