class CfgPatches {

	class TEN_fluidDoorOpening {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {"CBA_keybinding"};
		version = "1.1.0";
		author[]= {"Sniperwolf572"};
		authorUrl = "https://twitter.com/tenga6";
	};
};

class CfgFunctions {

	class TEN {

		tag = "TEN";

		class fluidDoorOpening {

			file = "x\TEN\addons\TEN_fluidDoorOpening\functions";
			
			class fluidDoorOpening_init {
				postInit = 1;
			};

			class fluidDoorOpening_getIntersectPoints {};

			class fluidDoorOpening_openDoorFluid {};

			class fluidDoorOpening_getDoorInfo {};
		};
	};
};