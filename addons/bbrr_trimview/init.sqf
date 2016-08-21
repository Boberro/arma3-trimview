if !(hasInterface) exitwith {};

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

bbrr_trimview_normalViewDistance;

bbrr_trimview_rscLayer = "bbrr_trimview" call BIS_fnc_rscLayer;

[] spawn {
    waitUntil { sleep 0.1; !(isNull(findDisplay 46)); };

    // Check if CBA Keybinding system is available.
    if(!isNil "cba_keybinding") then {
        // Register PtH keybinds via CBA
        ["Boberro's TrimView", "TrimViewToggle", ["TrimView Toggle", "Press to shorten the view distance. Press again to go back to normal"], {_this call bbrr_trimview_fnc_toggle}, "", [DIK_END, [false, true, false]], false, 0, false] call cba_fnc_addKeybind;
        
        [] call bbrr_trimview_fnc_processSettings;

        _version = getText (configFile >> "CfgPatches" >> "bbrr_trimview" >> "version");
        diag_log text format["Boberro's TrimView: v%1, Init complete.", _version];
    } else {
        diag_log text format["Boberro's TrimView: v%1, could not Init. Please upgrade CBA to the current release version.", _version];
    };
};

bbrr_trimview_fnc_processSettings = {
    bbrr_trimview_minViewDistance = 200;

    if(isNumber (configFile >> "bbrr_trimview_settings" >> "BBRR_TRIMVIEW_TRIMMED_VIEW_DISTANCE")) then {
        bbrr_trimview_minViewDistance = (getNumber (configFile >> "bbrr_trimview_settings" >> "BBRR_TRIMVIEW_TRIMMED_VIEW_DISTANCE"))
    };
};

bbrr_trimview_fnc_trimViewDistance = {
    _handled = false;

    if(!(player getVariable ["bbrr_trimview_isOn", false])) then {
        
        bbrr_trimview_normalViewDistance = viewDistance;
        
        if(bbrr_trimview_normalViewDistance > bbrr_trimview_minViewDistance) then {
            setViewDistance bbrr_trimview_minViewDistance;
            _handled = true;
        };
        
        if(_handled) then {
            bbrr_trimview_rscLayer cutRsc["bbrr_trimview_Display", "PLAIN", 0.5, true];
            player setVariable ["bbrr_trimview_isOn", true];
        };
    };
    _handled;
};

bbrr_trimview_fnc_restoreViewDistance = {
    setViewDistance bbrr_trimview_normalViewDistance;
    
    bbrr_trimview_rscLayer cutFadeout 0.5;
    
    player setVariable ["bbrr_trimview_isOn", false];
    player setVariable ["bbrr_trimview_isToggleOn", false];

    true;
};

bbrr_trimview_fnc_toggle = {
    _handled = false;

    switch(player getVariable ["bbrr_trimview_isToggleOn", false]) do {
        case false: {
            [] call bbrr_trimview_fnc_trimViewDistance;
            player setVariable ["bbrr_trimview_isToggleOn", true];
            _handled = true;
        };
        case true: {
            [] call bbrr_trimview_fnc_restoreViewDistance;
            _handled = true;
        };
    };
    _handled;
};