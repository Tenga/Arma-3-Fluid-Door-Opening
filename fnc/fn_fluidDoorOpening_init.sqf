diag_log [__FILE__, "CALLED"];

if (!isDedicated) then {

	[] spawn {
		private [
			"_distance",
			"_isAdjust", 
			"_isNext", 
			"_isPrev",
			"_cursorTarget",
			"_cameraPosition", 
			"_cameraVector", 
			"_cameraPositionTrue", 
			"_finalPosition", 
			"_finalPositionTrue",
			"_intersects",
			"_selectionName",
			"_doorPhase"
		];

		_distance = 3; // Length of the intersect vector in meters

		// Evil loop of doom
		while {true} do {

			// Wait until the combination of Adjust + NextAction / PrevAction keys is pressed
			waitUntil {
				_isAdjust = (inputaction "Adjust" > 0);
				_isNext = (inputaction "NextAction" > 0);
				_isPrev = (inputaction "PrevAction" > 0);
				(_isAdjust && {_isNext or {_isPrev}});
			};

			_cursorTarget = cursorTarget;

			// No point in doing anything if the player isn't pointing at anything
			if(!isNull _cursorTarget) then {

				_cameraVector = [positionCameraToWorld [0,0,0], positionCameraToWorld [0,0,1]] call BIS_fnc_vectorFromXtoY; // Get the current camera vector
				_cameraPosition = eyePos player; // Starting point for the intersect line
				_cameraPositionTrue = if(surfaceIsWater _cameraPosition) then {_cameraPosition} else {ASLtoATL _cameraPosition}; // Normalize the starting position
				_finalPosition = [_cameraPosition, [_cameraVector call BIS_fnc_unitVector, _distance] call BIS_fnc_vectorMultiply] call BIS_fnc_vectorAdd; // Calculate the end position for the intersect line based on the camera vector
				_finalPositionTrue = if(surfaceIsWater _finalPosition) then {_finalPosition} else {ASLtoATL _finalPosition}; // Normalize the final position of the intersect line
				_intersects = [_cursorTarget, "GEOM"] intersect [_cameraPositionTrue, _finalPositionTrue]; // Get the stuff the line intersects

				// If we've got something in our way, let's try to open it
				if(count _intersects > 0) then {

					// Currently most interesting doors and hatches are named door_#_rot or hatch_#_rot, those that aren't can rot in hell
					_selectionName = format ["%1_rot", (_intersects select 0) select 0];	

					// Get the current door phase so we can increment or decrement it based on the input we've been given
					_doorPhase = _cursorTarget animationPhase _selectionName;

					// BI, can we have a sane "elseif" in SQF so I don't have to do this to avoid silly if chains?
					switch true do {
						case (_isNext && { _doorPhase < 1 }) : { _doorPhase = _doorPhase + 0.1; }; // Player wants to open the door
						case (_isPrev && { _doorPhase > 0 }) : { _doorPhase = _doorPhase - 0.1; }; // Player wants to close the door
					};

					// Make it happen!
					_cursorTarget animate [_selectionName, _doorPhase];
				};
			};

		};

	};

};