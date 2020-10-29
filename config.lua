local _, core = ...;
core.Config = {};

local Config = core.Config;

local bop_epic_filter = Filter:new({id = "Low Level BoP Epics", rarity = {0, 1, 2, 3, 4}}); --SomeTest Filter

Config.Filter = bop_epic_filter;

local UIConfig;

function Config:CreateRarityCheckbox(frameName, parentFrame, relativePoint, color, offset, text)
    local cb = CreateFrame("CheckButton", frameName, parentFrame, "UICheckButtonTemplate");
    cb:SetPoint("TOPLEFT", relativePoint, "TOPLEFT", offset.x, offset.y);
    cb.text:SetTextColor(color.r, color.g, color.b, color.a);
    cb.text:SetText(text);

    return cb;
end

function Config:Toggle()
    local menu = UIConfig or Config:CreateMenu();
    menu:SetShown(not menu:IsShown());
end

function Config:CreateMenu()
    UIConfig = CreateFrame("Frame", "JunkieSettings", UIParent, "BasicFrameTemplateWithInset");
    UIConfig:SetSize(300, 360);
    UIConfig:SetPoint("CENTER", UIParent, "CENTER");
    
    UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY");
    UIConfig.title:SetFontObject("GameFontHighlight");
    UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0);
    UIConfig.title:SetText("Junkie Settings");
    
    --Rarities
    UIConfig.rarityLabel = UIConfig:CreateFontString(nil, "OVERLAY");
    UIConfig.rarityLabel:SetFontObject("GameFontHighlight");
    UIConfig.rarityLabel:SetPoint("TOPLEFT", UIConfig.InsetBorderTopLeft, "TOPLEFT", 5, -10);
    UIConfig.rarityLabel:SetText("Rarities to Sell");
    
    UIConfig.checkButtonJunk = self:CreateRarityCheckbox("JunkieSettings_trashCheckbox", UIConfig, UIConfig.rarityLabel, {r=0.62, g= 0.62, b=0.62, a=1}, {x=0, y= -10}, "Poor");
    UIConfig.checkButtonCommon = self:CreateRarityCheckbox("JunkieSettings_commonCheckbox", UIConfig, UIConfig.checkButtonJunk, {r=1, g= 1, b=1, a=1}, {x=0, y= -25}, "Common");
    UIConfig.checkButtonUncommon = self:CreateRarityCheckbox("JunkieSettings_uncommonCheckbox", UIConfig, UIConfig.checkButtonCommon, {r=0.12, g= 1, b=0, a=1}, {x=0, y= -25}, "Uncommon");
    UIConfig.checkButtonRare = self:CreateRarityCheckbox("JunkieSettings_rareCheckbox", UIConfig, UIConfig.checkButtonUncommon, {r=0, g= 0.44, b=0.87, a=1}, {x=0, y= -25}, "Rare");
    UIConfig.checkButtonEpic = self:CreateRarityCheckbox("JunkieSettings_epicCheckbox", UIConfig, UIConfig.checkButtonRare, {r=0.64, g= 0.21, b=0.93, a=1}, {x=0, y= -25}, "Epic");

    --Save Button
    UIConfig.saveButton = CreateFrame("Button", "JunkieSettings_Save", UIConfig, "GameMenuButtonTemplate");
    UIConfig.saveButton:SetPoint("BOTTOMRIGHT", UIConfig.InsetBorderBottomRight, "BOTTOMRIGHT", -5, 10);
    UIConfig.saveButton:SetText("Save Settings");
    UIConfig.saveButton:SetScript("OnClick", Config.SaveConfig);

    UIConfig:Hide();
    return UIConfig;
end;

function Config:SaveConfig()
    local filterSettings = Filter:new({id = "filter", rarity = {}});

    local i = 0;

    if UIConfig.checkButtonJunk:GetChecked() then i= i+1 ; filterSettings.rarity[i] = 0; end;
    if UIConfig.checkButtonCommon:GetChecked() then i= i+1 ; filterSettings.rarity[i] = 1; end;
    if UIConfig.checkButtonUncommon:GetChecked() then i= i+1 ; filterSettings.rarity[i] = 2; end;
    if UIConfig.checkButtonRare:GetChecked() then i= i+1 ; filterSettings.rarity[i] = 3; end;
    if UIConfig.checkButtonEpic:GetChecked() then i= i+1 ; filterSettings.rarity[i] = 4; end;

    Config.Filter = filterSettings;
end

    --[[
    CreateFrame("CheckButton", "JunkieSettings_trashCheckbox", settingsFrame, "UICheckButtonTemplate");
    UIConfig.checkButtonJunk:SetPoint("TOPLEFT", settingsFrame.rarityLabel, "TOPLEFT", 0, -10);
    UIConfig.checkButtonJunk.text:SetTextColor(0.62, 0.62, 0.62, 1);
    UIConfig.checkButtonJunk.text:SetText("Poor");

    
    UIConfig.checkButtonCommon = CreateFrame("CheckButton", "JunkieSettings_commonCheckbox", settingsFrame, "UICheckButtonTemplate");
    UIConfig.checkButtonCommon:SetPoint("TOPLEFT", settingsFrame.checkButtonJunk, "TOPLEFT", 0, -25);
    UIConfig.checkButtonCommon.text:SetTextColor(1, 1, 1, 1);
    UIConfig.checkButtonCommon.text:SetText("Common");
    
    UIConfig.checkButtonUncommon = CreateFrame("CheckButton", "JunkieSettings_uncommonCheckbox", settingsFrame, "UICheckButtonTemplate");
    UIConfig.checkButtonUncommon:SetPoint("TOPLEFT", settingsFrame.checkButtonCommon, "TOPLEFT", 0, -25);
    UIConfig.checkButtonUncommon.text:SetTextColor(0.12, 1, 0, 1);
    UIConfig.checkButtonUncommon.text:SetText("Uncommon");
    
    UIConfig.checkButtonRare = CreateFrame("CheckButton", "JunkieSettings_rareCheckbox", settingsFrame, "UICheckButtonTemplate");
    UIConfig.checkButtonRare:SetPoint("TOPLEFT", settingsFrame.checkButtonUncommon, "TOPLEFT", 0, -25);
    UIConfig.checkButtonRare.text:SetTextColor(0, 0.44, 0.87, 1);
    UIConfig.checkButtonRare.text:SetText("Rare");
    
    UIConfig.checkButtonEpic = CreateFrame("CheckButton", "JunkieSettings_epicCheckbox", settingsFrame, "UICheckButtonTemplate");
    UIConfig.checkButtonEpic:SetPoint("TOPLEFT", settingsFrame.checkButtonRare, "TOPLEFT", 0, -25);
    UIConfig.checkButtonEpic.text:SetTextColor(0.64, 0.21, 0.93, 1);
    UIConfig.checkButtonEpic.text:SetText("Epic");
    ]]