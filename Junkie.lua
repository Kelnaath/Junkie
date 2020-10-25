local filter, config, junkie = ...

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