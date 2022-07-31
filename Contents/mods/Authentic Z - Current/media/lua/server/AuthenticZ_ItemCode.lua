local ChainsawAPI = require("Chainsaw/ChainsawAPI");

AZItemCode = AZItemCode or {}
AZItemCode.OnCreate = AZItemCode.OnCreate or {}

--- Delay the execution of a function by X ticks
local function delayedFunctionExecution(func, delay)
    delay = delay or 1;
    local ticks = 0;
    local function delayed()
        if ticks < delay then
            ticks = ticks + 1;
            return;
        end
        Events.OnTick.Remove(delayed);
        func();
    end
    Events.OnTick.Add(delayed);
end

-- Turn off only if the created chainsaw was inside an inventory
-- This is used to transform a turn off chainsaw when the game start
function AZItemCode.OnCreate.TurnOffChainsaw(item)
    delayedFunctionExecution(function()
        if item:getContainer() and not ChainsawAPI.isChainsawRunning(item) then
            ChainsawAPI.convertChainsaw(item, false);
        end
    end, 1);
end
