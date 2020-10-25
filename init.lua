local _, core = ...; --Namespace

function core:Init(event, name)
    if(name ~= "Junkie") then --Event fires for every time an addon gets loaded so we only check for when this addon is fully loaded.
        return;
    end

    SLASH_JunkieSettings1 = "/junkie";
    SlashCmdList.JunkieSettings = core.Config.Toggle;

    print("Junkie has been loaded!");
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:SetScript("OnEvent", core.Init);