/*
	Author: Sniperwolf572

	Description:
		Performs the fluid door opening

	Parameter(s):
		0: NUMBER - Scroll magnitude, usually provided by MouseZChanged event handler (Default: 1)
		1: NUMBER - Scroll magnitude multiplier (Default: 0.1)
		2: NUMBER - Distance in which to check for doors (Default: 3)

	Returns:
		Nothing
*/

if(!(missionNamespace getVariable ["TEN_fluidDoorOpening_fluidOpenActive", false])) exitWith {};

params [
	["_scrollMagnitude", 1, [0]],
	["_scrollMultiplier", 0.06, [0]],
	["_distance", 3, [0]]
];

private [
	"_objects",
	"_object",
	"_doorInfo",
	"_selections",
	"_selection",
	"_animName",
	"_doorPhase"
];

_intersectPoints = [_distance] call TEN_fnc_fluidDoorOpening_getIntersectPoints;

// We intersect instead of using cursorTarget as cursor target isn't always "revealed" to the player
_objects = lineIntersectsWith [_intersectPoints select 0, _intersectPoints select 1, objNull, objNull, true];

// No point in doing anything if the intersect hasn't returned anything
if((count _objects) > 0) then {
	
	_object = _objects select 0;

	// Fetch the selections we're intersecting
	_selections = [_object, "GEOM"] intersect [ASLtoAGL (_intersectPoints select 0), ASLtoAGL (_intersectPoints select 1)]; // Get the stuff the line intersects

	// If we've got something in our way, let's try to open it
	if(count _selections > 0) then {

		_selection = _selections select 0;
		_doorInfo = [_selection select 0] call TEN_fnc_fluidDoorOpening_getDoorInfo;

		// Selection is not a door or no anim defined
		if(_doorInfo select 0 == "") exitWith {};

		// Door is locked
		if(_doorInfo select 1 != "" && (_object getVariable [_doorInfo select 1, 0]) == 1) exitWith { 
			hintSilent "The door is locked";
			//[_object, _doorInfo select 2] call BIS_fnc_LockedDoorNoHandleOpen;
		};

		// Get the current door phase so we can increment or decrement it based on the input we've been given
		_doorPhase = _object animationPhase (_doorInfo select 0);

		// Open the door depending on the scrollwheel rotation and clamp the value
		_doorPhase = ((_doorPhase + ((_scrollMagnitude * _scrollMultiplier) min 0.1)) max 0) min 1;

		// Make it happen!
		_object animate [_doorInfo select 0, _doorPhase, true];
	};
};	