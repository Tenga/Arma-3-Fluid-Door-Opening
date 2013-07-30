class CfgPatches {

	class TEN_fluidDoorOpening {
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {};
		version = "1.0.1";
		author[]= {"Sniperwolf572"};
		authorUrl = "https://twitter.com/tenga6";
	};

};

class CfgFunctions
{
	class TEN
	{
		tag = "TEN";

		class fluidDoorOpening
		{
			file = "x\TEN\addons\TEN_fluidDoorOpening\fnc";
			
			class fluidDoorOpening_init
			{
				postInit = 1;
			};
		};
	};
};