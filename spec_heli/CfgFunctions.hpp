class spec_heli {
	tag = "Spec_heli";
	class init {
		file="spec_heli";
		class medEvac {};
		class medEvacRetransfer { postInit = 1; };
		class taxi {};
		class moveMarkerLZ { postInit = 1; };
	};
};