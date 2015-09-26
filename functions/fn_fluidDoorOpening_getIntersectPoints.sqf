/*
	Author: Sniperwolf572

	Description:
		Calculates the two sets of intersect points, starting from the eyePos of the current unit and extending in the direction the camera is facing

	Parameter(s):
		0: NUMBER - How far the end point is from the start point

	Returns:
		ARRAY - Start and end point
			0: ARRAY - Start point in ASL
			1: ARRAY - End point in ASL
*/

params [["_magnitude", 3, [0]]];
private ["_camPos", "_camVector", "_endPos"];

// Starting point for the intersect line
_camPos = eyePos (missionNamespace getVariable ["BIS_fnc_moduleRemoteControl_unit", player]);

// Get the current camera direction vector
_camVector = (AGLtoASL (positionCameraToWorld [0,0,0])) vectorFromTo (AGLtoASL (positionCameraToWorld [0,0,1]));

// Calculate the end position for the intersect line based on the camera vector and magnitude given
_endPos = _camPos vectorAdd ((vectorNormalized _camVector) vectorMultiply _magnitude);

[_camPos, _endPos];