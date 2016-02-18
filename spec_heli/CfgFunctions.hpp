class spec_heli {
	tag = "Spec";
	class init {
		file="spec_heli";
		class heli_medevac {};
		class heli_medevac_retransfer { postInit = 1; };
		class heli_taxi {};
		class moveMarkerLZ { postInit = 1; };
	};
};