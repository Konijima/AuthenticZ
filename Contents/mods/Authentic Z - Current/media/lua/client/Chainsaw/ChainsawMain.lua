--- Code by Konijima, 2022

local ChainsawAPI = require("Chainsaw/ChainsawAPI");
local ChainsawCutTreeAction = require("Chainsaw/TimedActions/ChainsawCutTreeAction");
local RefuelChainsawAction = require("Chainsaw/TimedActions/RefuelChainsawAction");
local StartChainsawAction = require("Chainsaw/TimedActions/StartChainsawAction");
local StopChainsawAction = require("Chainsaw/TimedActions/StopChainsawAction");

local function predicatePetrol(item)
	return (item:hasTag("Petrol") or item:getType() == "PetrolCan") and (item:getDrainableUsesInt() > 0)
end

local function doRefuelChainsaw(playerObj, chainsaw)
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, chainsaw);
    ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, chainsaw, 20, true, chainsaw:isTwoHandWeapon()));
    ISTimedActionQueue.add(RefuelChainsawAction:new(playerObj, chainsaw));
end

local function doStartChainsaw(playerObj, chainsaw)
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, chainsaw);
    ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, chainsaw, 20, true, chainsaw:isTwoHandWeapon()));
    ISTimedActionQueue.add(StartChainsawAction:new(playerObj, chainsaw));
end

local function doStopChainsaw(playerObj, chainsaw)
    ISWorldObjectContextMenu.transferIfNeeded(playerObj, chainsaw);
    ISTimedActionQueue.add(ISEquipWeaponAction:new(playerObj, chainsaw, 20, true, chainsaw:isTwoHandWeapon()));
    ISTimedActionQueue.add(StopChainsawAction:new(playerObj, chainsaw));
end

local function doChopTree(playerObj, chainsaw, tree)
    if luautils.walkAdj(playerObj, tree:getSquare()) then
        ISTimedActionQueue.add(ChainsawCutTreeAction:new(playerObj, chainsaw, tree));
    end
end

--- World Context Menu
local function onFillWorldObjectContextMenu(player, context, worldobjects, test)
    if test then return; end
    
    local playerObj = getSpecificPlayer(player);

    --- Chainsaw in a vehicle? not sure its a great idea lol
    if playerObj:getVehicle() then return; end

    local item = playerObj:getPrimaryHandItem();

    --- Is it a chainsaw
    if item and ChainsawAPI.predicateChainsaw(item) then

        --- is it running?
        if ChainsawAPI.isChainsawRunning(item) then
            context:addOptionOnTop(getText("ContextMenu_Stop_Chainsaw"), playerObj, doStopChainsaw, item);

            --- is a tree clicked?
            if tree then
                context:addOptionOnTop(getText("ContextMenu_Chainsaw_Tree"), playerObj, doChopTree, item, tree);
            end
        else
            --- wanna start chainsaw if it has fuel?
            local startOption = context:addOptionOnTop(getText("ContextMenu_Start_Chainsaw"), playerObj, doStartChainsaw, item);
            if not ChainsawAPI.hasFuel(item) then
                startOption.notAvailable = true;
            end

            --- Has fuel in inventory lets refuel?
            if not ChainsawAPI.isFull(item) and playerObj:getInventory():containsEval(predicatePetrol) then
                context:addOptionOnTop(getText("ContextMenu_Refuel_Chainsaw"), playerObj, doRefuelChainsaw, item);
            end
        end
    end

end
Events.OnFillWorldObjectContextMenu.Add(onFillWorldObjectContextMenu);

--- Inventory Context Menu
local function onFillInventoryObjectContextMenu(player, context, items)
    if test then return; end

    local playerObj = getSpecificPlayer(player);

    --- Check if a chainsaw was selected
    local chainsaw;
    for i,v in ipairs(items) do
        if not instanceof(v, "InventoryItem") then
            for _, it in ipairs(v.items) do
                if ChainsawAPI.predicateChainsaw(it) then
                    chainsaw = it;
                    break;
                end
            end
        elseif ChainsawAPI.predicateChainsaw(v) then
            chainsaw = v;
            break;
        end
    end

    --- Selected a chainsaw
    if chainsaw then
        
        --- is it running?
        if ChainsawAPI.isChainsawRunning(chainsaw) then
            context:addOptionOnTop(getText("ContextMenu_Stop_Chainsaw"), playerObj, doStopChainsaw, chainsaw);
        else
            
            --- wanna start chainsaw if it has fuel?
            local startOption = context:addOptionOnTop(getText("ContextMenu_Start_Chainsaw"), playerObj, doStartChainsaw, chainsaw);
            if not ChainsawAPI.hasFuel(chainsaw) then
                startOption.notAvailable = true;
            end

            --- Has fuel in inventory lets refuel?
            if not ChainsawAPI.isFull(chainsaw) and playerObj:getInventory():containsEval(predicatePetrol) then
                context:addOptionOnTop(getText("ContextMenu_Refuel_Chainsaw"), playerObj, doRefuelChainsaw, chainsaw);
            end
        end
    end
end
Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryObjectContextMenu);
