--- Code by Konijima, 2022

local ChainsawAPI = require("Chainsaw/ChainsawAPI");

---@class StartChainsawAction : ISBaseTimedAction
local StartChainsawAction = ISBaseTimedAction:derive("StartChainsawAction")

function StartChainsawAction:isValid()
	return self.chainsaw ~= nil and self.chainsaw:hasTag("ChainsawOff");
end

function StartChainsawAction:update()
    self.chainsaw:setJobDelta(self:getJobDelta());
end

function StartChainsawAction:start()
    local modData = self.chainsaw:getModData();

    self.chainsaw:setJobType(getText("ContextMenu_Start_Chainsaw"));
    self.chainsaw:setJobDelta(0.0);

    self:setActionAnim("Chainsaw");
	self.character:SetVariable("ChainsawAction", "Start");

    if modData.ChainsawStartSound then
        self.sound = self.character:playSound(modData.ChainsawStartSound);
    end

    self:setOverrideHandModels(self.chainsaw, nil)
end

function StartChainsawAction:stop()
    if self.sound then
        self.character:stopOrTriggerSound(self.sound);
    end
    self.chainsaw:setJobDelta(0.0);

    ISBaseTimedAction.stop(self);
end

function StartChainsawAction:perform()
    if self.sound then
        self.character:stopOrTriggerSound(self.sound);
    end
    self.chainsaw:setJobDelta(0.0);

    ChainsawAPI.startChainsaw(self.character, self.chainsaw);

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function StartChainsawAction:new(character, chainsaw)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.chainsaw = chainsaw
	o.stopOnWalk = false
	o.stopOnRun = true
	o.maxTime = 60
	return o
end

return StartChainsawAction;
