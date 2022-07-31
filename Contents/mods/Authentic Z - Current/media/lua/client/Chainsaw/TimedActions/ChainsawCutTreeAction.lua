--- Code by Konijima, 2022

local ChainsawAPI = require("Chainsaw/ChainsawAPI");

---@class ChainsawCutTreeAction : ISBaseTimedAction
local ChainsawCutTreeAction = ISBaseTimedAction:derive("ChainsawCutTreeAction")

function ChainsawCutTreeAction:isValid()
	return self.tree ~= nil and self.tree:getObjectIndex() >= 0 and self.character:CanAttack() and ChainsawAPI.isChainsawRunning(self.chainsaw)
end

function ChainsawCutTreeAction:waitToStart()
	self.character:faceThisObject(self.tree)
	return self.character:shouldBeTurning()
end

function ChainsawCutTreeAction:start()
    local modData = self.chainsaw:getModData();
--    self.action:setTime(math.max((self.tree:getHealth() / self.chainsaw:getTreeDamage()) * 62, 30)) --62 is as close as I can get to making the timer sync up. -Fox
    self.chainsaw:setJobType(getText("ContextMenu_Chainsaw_Tree"));
    self.chainsaw:setJobDelta(0.0);

	if self.character:isTimedActionInstant() then
		self.tree:setHealth(1)
    end

    self:setActionAnim("Chainsaw");
	self.character:SetVariable("ChainsawAction", "CutTree");

	if modData.ChainsawChopSound then
		self.sound = self.character:playSound(modData.ChainsawChopSound);
	end

    self:setOverrideHandModels(self.chainsaw, nil)
end

function ChainsawCutTreeAction:stop()
	if self.sound then
        self.character:stopOrTriggerSound(self.sound);
    end
    self.chainsaw:setJobDelta(0.0);

    ISBaseTimedAction.stop(self)
end

function ChainsawCutTreeAction:perform()
	if self.sound then
        self.character:stopOrTriggerSound(self.sound);
    end
    self.chainsaw:setJobDelta(0.0);

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function ChainsawCutTreeAction:update()
    self.chainsaw:setJobDelta(self:getJobDelta());

	self.character:faceThisObject(self.tree)

	if ZombRand(100) < 3 then
		self.tree:WeaponHit(self.character, self.chainsaw);
	end

	if ZombRand(self.chainsaw:getConditionLowerChance() * 2 + self.character:getMaintenanceMod() * 2) == 0 then
		self.chainsaw:setCondition(self.chainsaw:getCondition() - 1)
		ISWorldObjectContextMenu.checkWeapon(self.character);
	else
		self.character:getXp():AddXP(Perks.Maintenance, 1)
	end

	if self.tree:getObjectIndex() == -1 then
		self:forceComplete();
	end

    if instanceof(self.character, "IsoPlayer") then
        self.character:setMetabolicTarget(Metabolics.ForestryAxe);
    end
end

-- function ChainsawCutTreeAction:animEvent(event, parameter)
-- 	if event == 'ChopTree' then
-- 		self.tree:WeaponHit(self.character, self.chainsaw)
-- 		self:useEndurance()
-- 		if ZombRand(self.chainsaw:getConditionLowerChance() * 2 + self.character:getMaintenanceMod() * 2) == 0 then
-- 			self.chainsaw:setCondition(self.chainsaw:getCondition() - 1)
-- 			ISWorldObjectContextMenu.checkWeapon(self.character);
-- 		else
-- 			self.character:getXp():AddXP(Perks.Maintenance, 1)
-- 		end
-- 		if self.tree:getObjectIndex() == -1 then
-- 			self:forceComplete()
-- 		end
-- 	end
-- end

-- function ChainsawCutTreeAction:useEndurance()
-- 	if self.chainsaw:isUseEndurance() then
-- 		local use = self.chainsaw:getWeight() * self.chainsaw:getFatigueMod(self.character) * self.character:getFatigueMod() * self.chainsaw:getEnduranceMod() * 0.1
-- 		local useChargeDelta = 1.0
-- 		use = use * useChargeDelta * 0.041
-- 		if self.chainsaw:isTwoHandWeapon() and self.character:getSecondaryHandItem() ~= self.chainsaw then
-- 			use = use + self.chainsaw:getWeight() / 1.5 / 10 / 20
-- 		end
-- 		self.character:getStats():setEndurance(self.character:getStats():getEndurance() - use)
-- 	end
-- end

function ChainsawCutTreeAction:new(character, chainsaw, tree)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.chainsaw = chainsaw
	o.tree = tree
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = -1
	o.spriteFrame = 0
    o.caloriesModifier = 4;
	o.forceProgressBar = true;
	return o
end

return ChainsawCutTreeAction;
