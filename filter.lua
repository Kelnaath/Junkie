local _, core = ... --Namespace

--[[
    FILTER CLASS
]]
Filter = {
    id = "TEMPLATE", -- Identifier of filter.
    rarity = {}, -- Uses Item.ItemQuality values from WoW API to compare.
    onlyLowLevelGear = true, --For now just use a bool. ToDo: make level settable as a number.
    bindType = 1, --Default is BoP.
    itemTypes = {}, --ToDo: Create item type ignore list. For now we only sell junk and gear.
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

function Filter:TypeIsInTable(filterType, filterTable)
    for i=1, #filterTable, 1 do
        print("table type: " .. filterTable[i] .. " itemType: " .. filterType)
        if filterTable[i] == filterType then
            return true;
        end
    end
end