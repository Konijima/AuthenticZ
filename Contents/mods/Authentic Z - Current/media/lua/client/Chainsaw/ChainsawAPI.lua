--- Code by Konijima, 2022

local ChainsawAPI = {};

local runningChainsaws = {};

---@param item InventoryItem
function ChainsawAPI.predicateChainsaw(item)
	return not item:isBroken() and item:hasTag("Chainsaw");
end

---@param item InventoryItem
function ChainsawAPI.isChainsawRunning(item)
    return runningChainsaws[item] ~= nil;
end

function ChainsawAPI.hasFuel(item)
    local modData = item:getModData();
    return modData.CurrentFuel and modData.CurrentFuel > 0;
end

function ChainsawAPI.isFull(item)
    local modData = item:getModData();
    return modData.CurrentFuel and modData.CurrentFuel >= (modData.FuelCapacity or 4);
end

---@param playerObj IsoPlayer
---@param item InventoryItem
function ChainsawAPI.startChainsaw(playerObj, item)
    if ChainsawAPI.predicateChainsaw(item) and not ChainsawAPI.isChainsawRunning(item) then
        local modData = item:getModData();
        local FuelConsumption = modData.FuelConsumption or 0.1;

        --- Dont start if not enough fuel
        if modData.CurrentFuel <= 0 then
            modData.CurrentFuel = 0;
            return;
        end

        local attackSound; -- store playing attack sound
        local isAttacking = false; -- toggle attack state for sound

        --- Update loop
        local function updateChainsaw()
            if item and item:isEquipped() and not item:isBroken() and modData.CurrentFuel > 0 then
                addSound(playerObj, playerObj:getX(), playerObj:getY(), playerObj:getZ(), 30, 30);
                modData.CurrentFuel = modData.CurrentFuel - FuelConsumption;
            else
                --- Stop attack sound if chainsaw stop
                if attackSound then
                    playerObj:stopOrTriggerSound(attackSound);
                end

                --- No more fuel, stop chainsaw
                ChainsawAPI.stopChainsaw(item);
            end

            --- Handle attack sound
            if playerObj:isAttacking() and not isAttacking then
                isAttacking = true;
                if ChainsawAPI.isChainsawRunning(item) and modData.ChainsawAttackSound then
                    attackSound = playerObj:playSound(modData.ChainsawAttackSound);
                end
            elseif not playerObj:isAttacking() and isAttacking then
                isAttacking = false;
                if attackSound then
                    playerObj:stopOrTriggerSound(attackSound);
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
        runningChainsaws[item] = {
            player = playerObj,
            chainsaw = item,
            loopSound = loopSound,
            update = updateChainsaw,
        };

        print("Chainsaw has started!");
    end
end

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

        print("Chainsaw has stopped!");
        runningChainsaws[item] = nil;
    end
end

return ChainsawAPI;
