if !(hasInterface) exitwith {};

#include "\a3\editor_f\Data\Scripts\dikCodes.h"

bbrr_trimview_rscLayer = "bbrr_trimview" call BIS_fnc_rscLayer;

// Init variables
// TODO: Is it really how you do it though?
bbrr_trimview_normalViewDistance;
bbrr_trimview_normalObjectViewDistance;

// Set up CBA (keys, settings)
[] spawn {
    waitUntil { sleep 0.1; !(isNull(findDisplay 46)); };

    // Check if CBA Keybinding system is available.
    if(!isNil "cba_keybinding") then {
        // Key bindings
        [
            "TrimView",
            "TrimViewToggleTrim",
            ["Toggle Trim", "Press to shorten the view distance. Press again to go back to normal"],
            {_this call bbrr_trimview_fnc_toggle_trim},
            "",
            [DIK_END, [false, true, false]],
            false,
            0,
            false
        ] call cba_fnc_addKeybind;
        [
            "TrimView",
            "TrimViewToggleFocus",
            ["Toggle Focus", "Press to lengthen the view distance. Press again to go back to normal"],
            {_this call bbrr_trimview_fnc_toggle_focus},
            "",
            [DIK_HOME, [false, true, false]],
            false,
            0,
            false
        ] call cba_fnc_addKeybind;

        // TODO: Here I should check if settings system is available, but documentation is scarce at best.
        // Settings
        [
            "bbrr_trimview_settings_minViewDistance",  // _setting,
            "SLIDER",  // _settingType,
            "Trim-mode view distance",  // _title,
            "TrimView",  // _category,
            [200, 15000, 200, 0],  // _valueInfo,
            false,  // _isGlobal,
            {
                params ["_value"];
                bbrr_trimview_minViewDistance = _value;
            }  // _script
        ] call CBA_Settings_fnc_init;

        [
            "bbrr_trimview_settings_maxViewDistance",  // _setting,
            "SLIDER",  // _settingType,
            "Focus-mode view distance",  // _title,
            "TrimView",  // _category,
            [200, 15000, 2000, 0],  // _valueInfo,
            false,  // _isGlobal,
            {
                params ["_value"];
                bbrr_trimview_maxViewDistance = _value;
            }  // _script
        ] call CBA_Settings_fnc_init;

        [
            "bbrr_trimview_settings_stopNaggingAboutABug",  // _setting,
            "CHECKBOX",  // _settingType,
            "Stop nagging me!",  // _title,
            "TrimView",  // _category,
            false,  // _valueInfo,
            false,  // _isGlobal,
            {
                params ["_value"];
                bbrr_trimview_stopNaggingAboutABug = _value;
            }  // _script
        ] call CBA_Settings_fnc_init;
        
        // Finally
        _version = getText (configFile >> "CfgPatches" >> "bbrr_trimview" >> "version");
        diag_log text format["TrimView: v%1, Init complete.", _version];
    } else {
        _version = getText (configFile >> "CfgPatches" >> "bbrr_trimview" >> "version");
        diag_log text format["TrimView: v%1, could not Init. Please upgrade CBA to the current release version.", _version];
    };
};

bbrr_trimview_fnc_shortenViewDistance = {
    _handled = false;

    if(!(player getVariable ["bbrr_trimview_mode", false] isEqualTo "short")) then {
        
        if(player getVariable ["bbrr_trimview_mode", false] isEqualTo false) then {
            bbrr_trimview_normalViewDistance = viewDistance;
            bbrr_trimview_normalObjectViewDistance = getObjectViewDistance;
        };
        if (bbrr_trimview_normalViewDistance >= bbrr_trimview_minViewDistance) then {
        	setViewDistance bbrr_trimview_minViewDistance;
        	bbrr_trimview_rscLayer cutRsc["bbrr_trimview_Display_Short", "PLAIN", 0.5, true];
        	player setVariable ["bbrr_trimview_mode", "short"];
        } else {
        	hint "TrimView:\nYour normal view distance setting is shorter than what you're trying to trim it to.\n\nGo to Options-> Game-> Configure addons to change trim setting.";
    	};
    };
    _handled;
};

bbrr_trimview_fnc_lengthenViewDistance = {
    _handled = false;

    if(!(player getVariable ["bbrr_trimview_mode", false] isEqualTo "long")) then {
        
        if(player getVariable ["bbrr_trimview_mode", false] isEqualTo false) then {
            bbrr_trimview_normalViewDistance = viewDistance;
            bbrr_trimview_normalObjectViewDistance = getObjectViewDistance;
        };
        if (bbrr_trimview_normalViewDistance <= bbrr_trimview_maxViewDistance) then {
	        setViewDistance bbrr_trimview_maxViewDistance;
	        setObjectViewDistance [bbrr_trimview_maxViewDistance, bbrr_trimview_normalObjectViewDistance select 1];
	        
	        bbrr_trimview_rscLayer cutRsc["bbrr_trimview_Display_Long", "PLAIN", 0.5, true];
	        player setVariable ["bbrr_trimview_mode", "long"];

	        // Warn user about a bug in Arma engine
	        if (!bbrr_trimview_stopNaggingAboutABug && (bbrr_trimview_normalViewDistance == (bbrr_trimview_normalObjectViewDistance select 0))) then {
	        	Hint "TrimView:\nA bug in the game engine does not allow me to show you objects that are further than your View Distance setting in video options.\nFor focus to work correctly, go to Options-> Video and raise 'View distance' slider while keeping 'Object view distance' as it was.\n\nTo suppress this warning, go to Option->Game->Configure addons and check 'Stop nagging me' option.";
	        };
    	} else {
    		hint "TrimView:\nYour normal view distance setting is longer than what you're trying to lengthen it to.\n\nGo to Options-> Game-> Configure addons to change focus setting.";
    	}
    };
    _handled;
};

bbrr_trimview_fnc_restoreViewDistance = {
    setViewDistance bbrr_trimview_normalViewDistance;
    setObjectViewDistance bbrr_trimview_normalObjectViewDistance;
    
    bbrr_trimview_rscLayer cutFadeout 0.5;
    
    player setVariable ["bbrr_trimview_mode", false];

    true;
};

bbrr_trimview_fnc_toggle_trim = {
    _handled = false;

    if(!(player getVariable ["bbrr_trimview_mode", false] isEqualTo "short")) then {
        [] call bbrr_trimview_fnc_shortenViewDistance;
        _handled = true;
    } else {
        [] call bbrr_trimview_fnc_restoreViewDistance;
        _handled = true;
    };
    _handled;
};

bbrr_trimview_fnc_toggle_focus = {
    _handled = false;

    if(!(player getVariable ["bbrr_trimview_mode", false] isEqualTo "long")) then {
        [] call bbrr_trimview_fnc_lengthenViewDistance;
        _handled = true;
    } else {
        [] call bbrr_trimview_fnc_restoreViewDistance;
        _handled = true;
    };
    _handled;
};