--[[
    FILTER CLASS, ToDo: Split in own class
]]
Filter = {
    id = "TEMPLATE", -- Identifier of filter.
    rarity = {}, -- Uses Item.ItemQuality values from WoW API to compare, ToDo: Actually use a table containing all rarirties. BitMask?
    onlyLowLevelGear = true, --For now just use a bool. ToDo: make level settable as a number.
    bindType = 1, --Default is BoP.
    ignoreTypes = {}, --ToDo: Create item type ignore list. For now we only sell junk and gear.
    specificIgnore = {} --ToDo: Create specific item ignore list.
}

function Filter:new (o)
    o = o or {};
    setmetatable(o, self);
    self.__index = self;
    return o;
end

function Filter:ShouldIgnoreItem(itemId)
    return false;
end

function Filter:ContainsRarity(itemRarity)
    for i=1, #self.rarity,1 do
        if self.rarity[i] == itemRarity then
            return true;
        end
    end

    return false;
end

local itemBatch = {};
local bop_epic_filter = Filter:new({id = "Low Level BoP Epics", rarity = {0, 1, 2, 3, 4}});

--[[
    Repairs your gear when interacting with a merchant.
]]
local function RepairGear()
    print("Attempting to auto repair.");
    local repairAllCost, canRepair = GetRepairAllCost();
    local canRepairString = "cannot repair";

    if canRepair then
        canRepairString = "Repairing";
        RepairAllItems(); --ToDo: Use options table value as argument for using guild funds (1,0).
    end

    print(repairAllCost .. " " .. canRepairString);
end

local function SellItemBatch()
    local bIndex = itemBatch[1].bagIndex;
    local sIndex = itemBatch[1].slotIndex;
    local lock = select(3, GetContainerItemInfo(bIndex, sIndex));

    if not lock then
        UseContainerItem(bIndex, sIndex);
        tremove(itemBatch, 1);
    end

    if #itemBatch > 0 then
        C_Timer.After(0.2, SellItemBatch);
    end
end

local function ItemPassedFilter(itemId, quality, itemLink, filter)
    if filter:ShouldIgnoreItem(itemId) then
        print("Ignoring" .. itemLink);
        return false;
    end

    --Quality
    if not filter:ContainsRarity(quality) then -- Currently checking if item rarity is equal to specified rarity filter. ToDo: Give filter options 
        print("not selling " .. itemLink .. " because the quality does not match.");
        return false;                          
     end

     return true;
end

local function SellItemsWithFilter(filter)
    itemBatch = {};

    for bag=0, 4, 1 do
        print("checking bag " .. bag);

        local numberOfBagSlots = GetContainerNumSlots(bag);

        if numberOfBagSlots > 0 then
            for i=1, numberOfBagSlots, 1 do
                local _, _, locked, quality, _, _, itemLink, _, noValue, itemId = GetContainerItemInfo(bag, i);

                if(itemId and quality and itemLink and not noValue) then
                    local passedFilter = ItemPassedFilter(itemId, quality, itemLink, filter)
                    
                    if passedFilter then
                        print("Adding item " .. itemLink .. " to batch.");
                        local bIndex, sIndex = bag, i;
                        
                        tinsert(itemBatch, {bagIndex = bIndex, slotIndex = sIndex});
                    end
                end   
            end
        end
    end

    if #itemBatch > 0 then
        SellItemBatch();
    end
end

local function OnEvent(self, event, ...)
    --ToDo: Call functions based on user settings.
    if(event == "MERCHANT_SHOW") then    
        RepairGear();
        SellItemsWithFilter(bop_epic_filter);
    end
end

--MERCHANT_SHOW
local frame = CreateFrame("Frame", "JunkieFrame", UIParent, "MerchantItemTemplate");
frame:RegisterEvent("MERCHANT_SHOW");
frame:SetScript("OnEvent", OnEvent);

--SETTINGS
local settingsFrame = CreateFrame("Frame", "JunkieSettings", UIParent, "BasicFrameTemplateWithInset");
settingsFrame:SetSize(300, 360);
settingsFrame:SetPoint("CENTER", UIParent, "CENTER");

settingsFrame.title = settingsFrame:CreateFontString(nil, "OVERLAY");
settingsFrame.title:SetFontObject("GameFontHighlight");
settingsFrame.title:SetPoint("LEFT", settingsFrame.TitleBg, "LEFT", 5, 0);
settingsFrame.title:SetText("Junkie Settings");

--Rarities
settingsFrame.rarityLabel = settingsFrame:CreateFontString(nil, "OVERLAY");
settingsFrame.rarityLabel:SetFontObject("GameFontHighlight");
settingsFrame.rarityLabel:SetPoint("TOPLEFT", settingsFrame.InsetBorderTopLeft, "TOPLEFT", 5, -10);
settingsFrame.rarityLabel:SetText("Rarities to Sell");

settingsFrame.checkButtonJunk = CreateFrame("CheckButton", "JunkieSettings_trashCheckbox", settingsFrame, "UICheckButtonTemplate");
settingsFrame.checkButtonJunk:SetPoint("TOPLEFT", settingsFrame.rarityLabel, "TOPLEFT", 0, -10);
settingsFrame.checkButtonJunk.text:SetTextColor(0.62, 0.62, 0.62, 1);
settingsFrame.checkButtonJunk.text:SetText("Poor");

settingsFrame.checkButtonCommon = CreateFrame("CheckButton", "JunkieSettings_commonCheckbox", settingsFrame, "UICheckButtonTemplate");
settingsFrame.checkButtonCommon:SetPoint("TOPLEFT", settingsFrame.checkButtonJunk, "TOPLEFT", 0, -25);
settingsFrame.checkButtonCommon.text:SetTextColor(1, 1, 1, 1);
settingsFrame.checkButtonCommon.text:SetText("Common");

settingsFrame.checkButtonUncommon = CreateFrame("CheckButton", "JunkieSettings_uncommonCheckbox", settingsFrame, "UICheckButtonTemplate");
settingsFrame.checkButtonUncommon:SetPoint("TOPLEFT", settingsFrame.checkButtonCommon, "TOPLEFT", 0, -25);
settingsFrame.checkButtonUncommon.text:SetTextColor(0.12, 1, 0, 1);
settingsFrame.checkButtonUncommon.text:SetText("Uncommon");

settingsFrame.checkButtonRare = CreateFrame("CheckButton", "JunkieSettings_rareCheckbox", settingsFrame, "UICheckButtonTemplate");
settingsFrame.checkButtonRare:SetPoint("TOPLEFT", settingsFrame.checkButtonUncommon, "TOPLEFT", 0, -25);
settingsFrame.checkButtonRare.text:SetTextColor(0, 0.44, 0.87, 1);
settingsFrame.checkButtonRare.text:SetText("Rare");

settingsFrame.checkButtonEpic = CreateFrame("CheckButton", "JunkieSettings_epicCheckbox", settingsFrame, "UICheckButtonTemplate");
settingsFrame.checkButtonEpic:SetPoint("TOPLEFT", settingsFrame.checkButtonRare, "TOPLEFT", 0, -25);
settingsFrame.checkButtonEpic.text:SetTextColor(0.64, 0.21, 0.93, 1);
settingsFrame.checkButtonEpic.text:SetText("Epic");

--Level


--Shortcuts

print("Loaded Junkie");