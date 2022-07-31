--- Code by Konijima, 2022

local ChainsawAPI = {};

local runningChainsaws = {};

LuaEventManager.AddEvent("onChainsawStarted");
LuaEventManager.AddEvent("onChansawStopped");

--- Check if the item is a chainsaw
--- Doesnt check for the running state
---@param item InventoryItem
function ChainsawAPI.predicateChainsaw(item)
	return item:hasTag("Chainsaw") or item:hasTag("ChainsawOff");
end

--- Check if the chainsaw is not broken
---@param item InventoryItem
function ChainsawAPI.predicateWorkingChainsaw(item)
	return not item:isBroken() and ChainsawAPI.predicateChainsaw(item);
end

--- Check if the chainsaw is running
---@param item InventoryItem
function ChainsawAPI.isChainsawRunning(item)
    return runningChainsaws[item] ~= nil;
end

--- Check if the chainsaw has some fuel
function ChainsawAPI.hasFuel(item)
    local modData = item:getModData();
    return modData.CurrentFuel and modData.CurrentFuel > 0;
end

--- Check if the chainsaw fuel is full
function ChainsawAPI.isFull(item)
    local modData = item:getModData();
    return modData.CurrentFuel and modData.CurrentFuel >= (modData.FuelCapacity or 4);
end

--- Convert a chainsaw to a running or stopped state
--- Transfer over the data for item persistence
function ChainsawAPI.convertChainsaw(item, state)
    if not state and item:hasTag("Chainsaw") or state and item:hasTag("ChainsawOff") then
        local modData = item:getModData();
        local container = item:getContainer();
        local currentFuel = modData.CurrentFuel or 0;
        local replaceType = modData.ChainSawReplaceType;
        local condition = item:getCondition() or item:getConditionMax();
        local repairCount = item:getHaveBeenRepaired() or 0;
        local isEquipped = item:isEquipped();
        local isFavorite = item:isFavorite();
        local bloodLevel = item:getBloodLevel();

        print("Converting '" .. item:getType() .. "' to '" .. replaceType .. "'");

        local newItem = InventoryItemFactory.CreateItem(replaceType);
        newItem:getModData().CurrentFuel = currentFuel;
        newItem:setCondition(condition);
        newItem:setHaveBeenRepaired(repairCount);
        newItem:setFavorite(isFavorite);
        newItem:setBloodLevel(bloodLevel);

        local player = container:getParent();
        if player and not player:isDead() then
            container:Remove(item);
            container:AddItem(newItem);
            if isEquipped then
                player:setPrimaryHandItem(newItem);
                player:setSecondaryHandItem(newItem);
            end
        end

        return newItem;
    end
end

--- Start the process of a running chainsaw
---@param playerObj IsoPlayer
---@param item InventoryItem
function ChainsawAPI.startChainsaw(playerObj, item)
    if ChainsawAPI.predicateWorkingChainsaw(item) and not ChainsawAPI.isChainsawRunning(item) then
        --- Dont start if not enough fuel
        if item:getModData().CurrentFuel <= 0 then
            return;
        end

        --- Convert the chainsaw
        local chainsaw = ChainsawAPI.convertChainsaw(item, true);
        local modData = chainsaw:getModData();

        local attackSound; -- store playing attack sound

        --- Update loop
        local function updateChainsaw()
            if chainsaw and chainsaw:isEquipped() and not chainsaw:isBroken() and modData.CurrentFuel > 0 then
                addSound(playerObj, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 30, 30);
                modData.CurrentFuel = modData.CurrentFuel - (modData.FuelConsumption * 0.001 * getGameTime():getMultiplier());
            else
                --- Stop attack sound if chainsaw stop
                if attackSound then
                    playerObj:stopOrTriggerSound(attackSound);
                end

                --- No more fuel, stop chainsaw
                ChainsawAPI.stopChainsaw(chainsaw);
            end

            --- Handle attack sound
            if playerObj:isAttacking() and playerObj:getAttackType() ~= "miss" then
                if not attackSound or attackSound and not playerObj:getEmitter():isPlaying(attackSound) then
                    if ChainsawAPI.isChainsawRunning(chainsaw) and modData.ChainsawAttackSound then
                        attackSound = playerObj:playSound(modData.ChainsawAttackSound);
                    end
                end
            end
        end
        Events.OnTick.Add(updateChainsaw);

        --- Play looped sound
        local loopSound;
        if modData.ChainsawIdleSound then
            loopSound = playerObj:playSound(modData.ChainsawIdleSound);
        end

        --- Store chainsaw instance
        runningChainsaws[chainsaw] = {
            player = playerObj,
            chainsaw = chainsaw,
            loopSound = loopSound,
            update = updateChainsaw,
        };

        triggerEvent("onChainsawStarted", chainsaw);

        print("Chainsaw has started!");
    end
end

--- Stop the process of a running chainsaw
---@param item InventoryItem
function ChainsawAPI.stopChainsaw(item)
    if ChainsawAPI.isChainsawRunning(item) then
        local modData = item:getModData();
        local instance = runningChainsaws[item];

        --- Stop Update loop
        Events.OnTick.Remove(instance.update);
        
        --- Stop looped sound
        if instance.loopSound then
            instance.player:stopOrTriggerSound(instance.loopSound);
        end

        --- Play stopping sound
        if modData.ChainsawStopSound then
            instance.player:playSound(modData.ChainsawStopSound);
        end

        --- Convert the chainsaw
        ChainsawAPI.convertChainsaw(item, false);

        print("Chainsaw has stopped!");
        runningChainsaws[item] = nil;

        triggerEvent("onChansawStopped", item);
    end
end

return ChainsawAPI;
