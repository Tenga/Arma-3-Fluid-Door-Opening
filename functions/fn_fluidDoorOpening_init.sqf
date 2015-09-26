/*
	Author: Sniperwolf572

	Description:
		Initializes the fluid door opening

	Parameter(s):
		None

	Returns:
		Nothing
*/
#include "\a3\editor_f\Data\Scripts\dikCodes.h"

//#define DEBUG 1

#ifdef DEBUG

	// Debug visualisation of the intersect line
	["TEN_fluidDoorOpening_debug", "onEachFrame", {

		if(!(missionNamespace getVariable ["TEN_fluidDoorOpening_fluidOpenActive", false])) exitWith {};

		private ["_points"];

		_points = call TEN_fnc_fluidDoorOpening_getIntersectPoints;

		drawLine3D [ASLtoAGL (_points select 0), ASLtoAGL (_points select 1), [1,0,0,1]];

	}] call BIS_fnc_addStackedEventHandler;

#endif

// Add CBA keybinds
[
	"TEN Fluid Door Opening", 
	"ten_fluid_door_open_hold",
	"Fluid door opening (Hold + Mouse Wheel)", 
	{
		showHUD false;
		missionNamespace setVariable ["TEN_fluidDoorOpening_fluidOpenActive", true];
	}, 
	{
		showHUD true;
		missionNamespace setVariable ["TEN_fluidDoorOpening_fluidOpenActive", false];
	}, 
	[DIK_TAB, [false, false, false]],
	false
] call CBA_fnc_addKeybind;

// Add event handlers
[] spawn {
	waitUntil {!isNull (findDisplay 46)};
	missionNamespace setVariable ["TEN_fluidDoorOpening_scrollEH", ((findDisplay 46) displayAddEventHandler ["MouseZChanged", { [_this select 1] call TEN_fnc_fluidDoorOpening_openDoorFluid}])];
};