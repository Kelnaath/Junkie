local _, core = ... --Namespace

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

core.Filter = Filter;

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
        print("table rarirty: " .. self.rarity[i] .. " itemrarity: " .. itemRarity)
        if self.rarity[i] == itemRarity then
            return true;
        end
    end

    return false;
end