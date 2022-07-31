--- Code by Konijima, 2022

local ChainsawAPI = require("Chainsaw/ChainsawAPI");

local function predicatePetrol(item)
	return (item:hasTag("Petrol") or item:getType() == "PetrolCan") and (item:getDrainableUsesInt() > 0)
end

---@class RefuelChainsawAction : ISBaseTimedAction
local RefuelChainsawAction = ISBaseTimedAction:derive("RefuelChainsawAction")

function RefuelChainsawAction:isValid()
	return self.petrol and 
    self.chainsaw and 
    self.chainsaw:hasTag("ChainsawOff") and 
    not self.character:isMoving() and
    not ChainsawAPI.isChainsawRunning(self.chainsaw) and 
    not ChainsawAPI.isFull(self.chainsaw);
end

function RefuelChainsawAction:update()
    self.chainsaw:setJobDelta(self:getJobDelta());
    self.petrol:setJobDelta(self:getJobDelta());
end

function RefuelChainsawAction:start()
    self.chainsaw:setJobType(getText("ContextMenu_Refuel_Chainsaw"));
    self.chainsaw:setJobDelta(0.0);
    self.petrol:setJobType(getText("ContextMenu_Refuel_Chainsaw"));
    self.petrol:setJobDelta(0.0);

    local unitLeft = math.floor(self.petrol:getUsedDelta() / self.petrol:getUseDelta());
    local unitNeeded = (self.chainsawModData.FuelCapacity or 4) - (self.chainsawModData.CurrentFuel or 0);
    local unitTransfer = math.min(unitLeft, unitNeeded);

    self.action:setTime(unitTransfer * 50);

    self:setActionAnim("RefuelChainsaw");

    self:setOverrideHandModels(self.chainsaw:getStaticModel(), self.petrol:getStaticModel());

    self.sound = self.character:playSound("GeneratorAddFuel");
end

function RefuelChainsawAction:stop()
    self.character:stopOrTriggerSound(self.sound);
    self.chainsaw:setJobDelta(0.0);
    self.petrol:setJobDelta(0.0);

    ISBaseTimedAction.stop(self)
end

function RefuelChainsawAction:perform()
    self.character:stopOrTriggerSound(self.sound);
    self.chainsaw:setJobDelta(0.0);
    self.petrol:setJobDelta(0.0);

    self.chainsawModData.CurrentFuel = self.chainsawModData.CurrentFuel or 0;

    local endFuel = 0;
    while self.petrol and self.petrol:getUsedDelta() > 0 and self.chainsawModData.CurrentFuel + endFuel < self.chainsawModData.FuelCapacity do
        self.petrol:Use();
        endFuel = endFuel + 1;
    end

    self.chainsawModData.CurrentFuel = self.chainsawModData.CurrentFuel + endFuel;

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function RefuelChainsawAction:new(character, chainsaw)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.chainsaw = chainsaw
    o.chainsawModData = chainsaw:getModData();
    o.petrol = character:getInventory():getFirstEval(predicatePetrol);
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = 50
	return o
end

return RefuelChainsawAction;
