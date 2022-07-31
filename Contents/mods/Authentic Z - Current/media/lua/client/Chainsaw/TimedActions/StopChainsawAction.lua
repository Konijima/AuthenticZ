--- Code by Konijima, 2022

local ChainsawAPI = require("Chainsaw/ChainsawAPI");

---@class StopChainsawAction : ISBaseTimedAction
local StopChainsawAction = ISBaseTimedAction:derive("StopChainsawAction")

function StopChainsawAction:isValid()
	return self.chainsaw ~= nil and self.chainsaw:hasTag("Chainsaw") and ChainsawAPI.isChainsawRunning(self.chainsaw);
end

function StopChainsawAction:update()
    self.chainsaw:setJobDelta(self:getJobDelta());
end

function StopChainsawAction:start()
    local modData = self.chainsaw:getModData();

    self.chainsaw:setJobType(getText("ContextMenu_Stoping_Chainsaw"));
    self.chainsaw:setJobDelta(0.0);

    -- self:setActionAnim("StopChainSaw");

    if modData.ChainsawStartSound then
        self.sound = self.character:playSound(modData.ChainsawStartSound);
    end

    self:setOverrideHandModels(self.chainsaw, nil)
end

function StopChainsawAction:stop()
    if self.sound then
        self.character:stopOrTriggerSound(self.sound);
    end
    self.chainsaw:setJobDelta(0.0);

    ISBaseTimedAction.stop(self)
end

function StopChainsawAction:perform()
    if self.sound then
        self.character:stopOrTriggerSound(self.sound);
    end
    self.chainsaw:setJobDelta(0.0);

    ChainsawAPI.stopChainsaw(self.chainsaw);

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function StopChainsawAction:new(character, chainsaw)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.chainsaw = chainsaw
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = 15
	return o
end

return StopChainsawAction;
