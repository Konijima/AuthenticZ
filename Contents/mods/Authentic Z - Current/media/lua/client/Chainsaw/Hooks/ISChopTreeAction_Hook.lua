--- Code by Konijima, 2022
--- Prevent Axe Cut Tree Action

local original_ISChopTreeAction_isValid = ISChopTreeAction.isValid;
function ISChopTreeAction:isValid()
    local item = self.character:getPrimaryHandItem();
    return item and not item:hasTag("Chainsaw") and original_ISChopTreeAction_isValid(self);
end
