--- Code by Konijima, 2022
--- Stop chainsaw when unequipping

local ChainsawAPI = require("Chainsaw/ChainsawAPI");

local original_ISUnequipAction_perform = ISUnequipAction.perform;
function ISUnequipAction:perform()

    if self.item:hasTag("Chainsaw") then
        -- stop the chain if running
        ChainsawAPI.stopChainsaw(self.item);
    end

    original_ISUnequipAction_perform(self);

end
