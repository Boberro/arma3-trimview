class CfgPatches
{
    class bbrr_trimview
    {
        units[] = {};
        weapons[] = {};
        requiredVersion = 1.62;
        requiredAddons[] = {"CBA_MAIN"};
        version = "1.0.2";
        author[] = {"boberro"};
        authorUrl = "https://github.com/Boberro/arma3-trimview/releases";
    };
};

class Extended_PostInit_EventHandlers
{
    class bbrr_trimview
    {
        clientInit = "call compile preProcessFileLineNumbers 'bbrr_trimview\init.sqf'";
    };
};

class RscTitles
{
    class bbrr_trimview_Display_Short
    { 
        idd = -1; 
        duration = 1e+1000;
        class controls 
        { 
            class bbrr_trimview_Display_Short_Bg
            { 
                idc = 0; 
                type = 0; //CT_STATIC;
                style = 0; // borderless box
                x = "0.0115015 * safezoneW + safezoneX";
                y = "0.72 * safezoneH + safezoneY";
                w = "0.05 * safezoneW";
                h = "0.05 * safezoneH";
                colorBackground[] = {0.204, 0.231, 0.255, 0.3}; // #4d343b41 -- DOESNT APPLY TO IMG
                colorText[] =  {0.855, 0.847, 0.851, 1}; // #DAD8D9 - rgb 218 216 217
                font = "TahomaB"; 
                sizeEx = 0.1; 
                text = "";
            };
            class bbrr_trimview_Display_Short_Icon: bbrr_trimview_Display_Short_Bg
            { 
                idc = 1; 
                style = 2096; //ST_PICTURE 48 //+2048 for aspect ratio
                text = "bbrr_trimview\bbrr_trimview_icon_short.paa";
            };
        }; 
    };
    // I know it can be done more efficiently, but have no idea how
    class bbrr_trimview_Display_Long
    { 
        idd = -1; 
        duration = 1e+1000;
        class controls 
        { 
            class bbrr_trimview_Display_Long_Bg
            { 
                idc = 0; 
                type = 0; //CT_STATIC;
                style = 0; // borderless box
                x = "0.0115015 * safezoneW + safezoneX";
                y = "0.72 * safezoneH + safezoneY";
                w = "0.05 * safezoneW";
                h = "0.05 * safezoneH";
                colorBackground[] = {0.204, 0.231, 0.255, 0.3}; // #4d343b41 -- DOESNT APPLY TO IMG
                colorText[] =  {0.855, 0.847, 0.851, 1}; // #DAD8D9 - rgb 218 216 217
                font = "TahomaB"; 
                sizeEx = 0.1; 
                text = "";
            };
            class bbrr_trimview_Display_Long_Icon: bbrr_trimview_Display_Long_Bg
            { 
                idc = 1; 
                style = 2096; //ST_PICTURE 48 //+2048 for aspect ratio
                text = "bbrr_trimview\bbrr_trimview_icon_long.paa";
            };
        }; 
    };
};
