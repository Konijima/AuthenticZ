local ChainsawAPI = require("Chainsaw/ChainsawAPI");

---@class ChainsawItemEditorUI : ISPanel
local ChainsawItemEditorUI = ISPanel:derive("ChainsawItemEditorUI");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function ChainsawItemEditorUI:initialise()
    ISPanel.initialise(self);
    self:create();
end


function ChainsawItemEditorUI:setVisible(visible)
    --    self.parent:setVisible(visible);
    self.javaObject:setVisible(visible);
end

function ChainsawItemEditorUI:render()
--    local y = 20;
--    local splitPt = 100;
--
--    self:drawText(getText("IGUI_ItemEditor_Title"), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_ItemEditor_Title")) / 2),y, 1,1,1,1, UIFont.Medium);
end

function ChainsawItemEditorUI:prerender()
    ISPanel.prerender(self);
    local y = 20;
    local dy = self.dy
    local splitPt = 100;


    self:drawText("Edit Chainsaw", self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, "Edit Chainsaw") / 2),y, 1,1,1,1, UIFont.Medium);
    y = y + 30;

    self:drawText(getText("IGUI_ItemEditor_ItemType") .. ":", 5, y, 1,1,1,1,UIFont.Small);
    y = y + 30;

    self:drawText(getText("IGUI_Name") .. ":", 5, y, 1,1,1,1,UIFont.Small);
    self.name:setY(y);
    if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_Name")) + 10 then
        splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_Name")) + 10;
    end
    y = y + dy;

    self:drawText(getText("Tooltip_item_Weight") .. ":", 5, y, 1,1,1,1,UIFont.Small);
    self.weight:setY(y);
    if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("Tooltip_item_Weight")) + 10 then
        splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("Tooltip_item_Weight")) + 10;
    end
    y = y + dy;

    self:drawText(getText("IGUI_invpanel_Condition") .. ":", 5, y, 1,1,1,1,UIFont.Small);
    self.condition:setY(y);
    if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpanel_Condition")) + 10 then
        splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpanel_Condition")) + 10;
    end
    y = y + dy;

    if self.color:isVisible() then
        self:drawText(getText("IGUI_Color") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.color:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_Color")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_Color")) + 10;
        end
        y = y + dy;
    end

    if self.isWeapon then
        self:drawText(getText("IGUI_ItemEditor_MinDmg") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.minDmg:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MinDmg")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MinDmg")) + 10;
        end
        y = y + dy;

        self:drawText(getText("IGUI_ItemEditor_MaxDmg") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.maxDmg:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MaxDmg")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MaxDmg")) + 10;
        end
        y = y + dy;

        self:drawText(getText("IGUI_ItemEditor_MinAngle") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.minAngle:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MinAngle")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MinAngle")) + 10;
        end
        y = y + dy;

        self:drawText(getText("IGUI_ItemEditor_MinRange") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.minRange:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MinRange")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MinRange")) + 10;
        end
        y = y + dy;

        self:drawText(getText("IGUI_ItemEditor_MaxRange") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.maxRange:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MaxRange")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_MaxRange")) + 10;
        end
        y = y + dy;

        -- self:drawText(getText("IGUI_ItemEditor_AimingTime") .. ":", 5, y, 1,1,1,1,UIFont.Small);
        -- self.aimingTime:setY(y);
        -- if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_AimingTime")) + 10 then
        --     splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_ItemEditor_AimingTime")) + 10;
        -- end
        -- y = y + dy;

        self:drawText("Fuel Capacity" .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.fuelCapacity:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, getText("Fuel Capacity")) + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, getText("Fuel Capacity")) + 10;
        end
        y = y + dy;

        self:drawText("Current Fuel" .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.currentFuel:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, "Current Fuel") + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, "Current Fuel") + 10;
        end
        y = y + dy;

        self:drawText("Fuel Consumption" .. ":", 5, y, 1,1,1,1,UIFont.Small);
        self.fuelConsumption:setY(y);
        if splitPt < getTextManager():MeasureStringX(UIFont.Small, "Fuel Consumption") + 10 then
            splitPt = getTextManager():MeasureStringX(UIFont.Small, "Fuel Consumption") + 10;
        end
        y = y + dy;

        self.minDmg:setX(splitPt);
        self.maxDmg:setX(splitPt);
        self.minAngle:setX(splitPt);
        self.minRange:setX(splitPt);
        self.maxRange:setX(splitPt);
        -- self.aimingTime:setX(splitPt);
        self.fuelCapacity:setX(splitPt);
        self.currentFuel:setX(splitPt);
        self.fuelConsumption:setX(splitPt);
    end

    self.name:setX(splitPt);
    self.weight:setX(splitPt);
    self.condition:setX(splitPt);
    self.color:setX(splitPt);
    self:drawText(self.item:getFullType(), splitPt, 50, 1,1,1,1,UIFont.Small);
end

function ChainsawItemEditorUI:create()
    local btnWid = 150
    local btnHgt = FONT_HGT_SMALL + 2 * 4
    local entryHgt = FONT_HGT_SMALL + 2 * 2
    local padBottom = 10
    local numberWidth = 50;
    local dy = math.max(20, entryHgt)
    self.dy = dy

    local y = 30;

    self.name = ISTextEntryBox:new(self.item:getName(), 10, y, 150, entryHgt);
    self.name:initialise();
    self.name:instantiate();
    self:addChild(self.name);

    self.weight = ISTextEntryBox:new(luautils.round(self.item:getActualWeight(),3) .. "", 10, y, numberWidth, entryHgt);
    self.originalWeight = luautils.round(self.item:getActualWeight(),3);
    self.weight:initialise();
    self.weight:instantiate();
    self.weight.min = 0;
    self.weight:setOnlyNumbers(true);
    self.weight:setEditable(false)
    self:addChild(self.weight);
    y = y + dy;

    self.condition = ISTextEntryBox:new(self.item:getCondition() .. "", 10, y, numberWidth, entryHgt);
    self.condition:initialise();
    self.condition:instantiate();
    self.condition.min = 0;
    self.condition.max = self.item:getConditionMax();
    self.condition:setOnlyNumbers(true);
    self:addChild(self.condition);
    y = y + dy;

    self.color = ISButton:new(10, y, 18, 18, "", self, ChainsawItemEditorUI.onColor);
    self.originalColorR = self.item:getColorInfo():getR();
    self.originalColorG = self.item:getColorInfo():getG();
    self.originalColorB = self.item:getColorInfo():getB();
    self.originalColorA = self.item:getColorInfo():getA();
    self.color:initialise();
    self.color.backgroundColor = {r = self.item:getColorInfo():getR(), g = self.item:getColorInfo():getG(), b = self.item:getColorInfo():getB(), a = 1};
    self:addChild(self.color);
    self.colorBtn = self.color;
    y = y + dy;

    if not self.item:allowRandomTint() then
        self.color:setVisible(false);
        y = y - dy;
    end

    --************** WEAPON **************--
    if self.isWeapon then
        self.minDmg = ISTextEntryBox:new(luautils.round(self.item:getMinDamage(),3) .. "", 10, y, numberWidth, entryHgt);
        self.minDmg:initialise();
        self.minDmg:instantiate();
        self.minDmg.min = 0;
        self.minDmg:setOnlyNumbers(true);
        self.minDmg:setEditable(false)
        self:addChild(self.minDmg);
        y = y + dy;

        self.maxDmg = ISTextEntryBox:new(luautils.round(self.item:getMaxDamage(),3) .. "", 10, y, numberWidth, entryHgt);
        self.maxDmg:initialise();
        self.maxDmg:instantiate();
        self.maxDmg.min = 0;
        self.maxDmg:setOnlyNumbers(true);
        self.maxDmg:setEditable(false)
        self:addChild(self.maxDmg);
        y = y + dy;

        self.minAngle = ISTextEntryBox:new(luautils.round(self.item:getMinAngle(),3) .. "", 10, y, numberWidth, entryHgt);
        self.minAngle:initialise();
        self.minAngle:instantiate();
        self.minAngle.min = 0;
        self.minAngle:setOnlyNumbers(true);
        self.minAngle:setEditable(false)
        self:addChild(self.minAngle);
        y = y + dy;

        local minRangeNbr = luautils.round(self.item:getMinRange(),3);
        if self.item:isRanged() then
            minRangeNbr = luautils.round(self.item:getMinRangeRanged(),3);
        end
        self.minRange = ISTextEntryBox:new(minRangeNbr .. "", 10, y, numberWidth, entryHgt);
        self.minRange:initialise();
        self.minRange:instantiate();
        self.minRange.min = 0;
        self.minRange:setOnlyNumbers(true);
        self.minRange:setEditable(false)
        self:addChild(self.minRange);
        y = y + dy;

        self.maxRange = ISTextEntryBox:new(luautils.round(self.item:getMaxRange(),3) .. "", 10, y, numberWidth, entryHgt);
        self.maxRange:initialise();
        self.maxRange:instantiate();
        self.maxRange.min = 0;
        self.maxRange:setOnlyNumbers(true);
        self.maxRange:setEditable(false)
        self:addChild(self.maxRange);
        y = y + dy;

        -- self.aimingTime = ISTextEntryBox:new(luautils.round(self.item:getAimingTime(),3) .. "", 10, y, numberWidth, entryHgt);
        -- self.aimingTime:initialise();
        -- self.aimingTime:instantiate();
        -- self.aimingTime.min = 0;
        -- self.aimingTime:setOnlyNumbers(true);
        -- self.aimingTime:setEditable(self.item:isRanged())
        -- self:addChild(self.aimingTime);
        -- y = y + dy;

        self.fuelCapacity = ISTextEntryBox:new(tostring(self.modData.FuelCapacity) .. "", 10, y, numberWidth, entryHgt);
        self.fuelCapacity:initialise();
        self.fuelCapacity:instantiate();
        self.fuelCapacity.min = 0;
        self.fuelCapacity:setOnlyNumbers(true);
        self.fuelCapacity:setEditable(false)
        self:addChild(self.fuelCapacity);
        y = y + dy;

        self.currentFuel = ISTextEntryBox:new(tostring(self.modData.CurrentFuel) .. "", 10, y, numberWidth, entryHgt);
        self.currentFuel:initialise();
        self.currentFuel:instantiate();
        self.currentFuel.min = 0;
        self.currentFuel.max = self.modData.FuelCapacity;
        self.currentFuel:setOnlyNumbers(true);
        self.currentFuel:setEditable(true)
        self:addChild(self.currentFuel);
        y = y + dy;

        self.fuelConsumption = ISTextEntryBox:new(tostring(self.modData.FuelConsumption) .. "", 10, y, numberWidth, entryHgt);
        self.fuelConsumption:initialise();
        self.fuelConsumption:instantiate();
        self.fuelConsumption.min = 0;
        self.fuelConsumption:setOnlyNumbers(true);
        self.fuelConsumption:setEditable(true)
        self:addChild(self.fuelConsumption);
        y = y + dy;
    end

    self:setHeight(y + 150);

    self.save = ISButton:new(5, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("IGUI_RadioSave"), self, ChainsawItemEditorUI.onOptionMouseDown);
    self.save.internal = "SAVE";
    self.save:initialise();
    self.save:instantiate();
    self.save.borderColor = self.buttonBorderColor;
	if isClient() then
		self.save.enable = self.admin:getInventory():contains(self.item)
	end
    self:addChild(self.save);

    self.cancel = ISButton:new(self:getWidth() - btnWid - 5, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("IGUI_Exit"), self, ChainsawItemEditorUI.onOptionMouseDown);
    self.cancel.internal = "CANCEL";
    self.cancel:initialise();
    self.cancel:instantiate();
    self.cancel.borderColor = self.buttonBorderColor;
    self:addChild(self.cancel);

    self.colorPicker = ISColorPicker:new(0, 0)
    self.colorPicker:initialise()
    self.colorPicker.pickedTarget = self;
    self.colorPicker.resetFocusTo = self;
    self.colorPicker:setInitialColor(self.item:getColorInfo());


    self:updateButtons(self);
end

function ChainsawItemEditorUI:updateButtons(internalUI)
--    local ui = internalUI or self.parent;
--    ui.save.enable = ui.originalName ~= string.trim(ui.name:getInternalText()) or
--            (ui.originalWeight ~= luautils.round(string.trim(ui.weight:getInternalText()),3)) or
--            (ui.originalColorR ~= ui.color.backgroundColor.r or ui.originalColorG ~= ui.color.backgroundColor.g or ui.originalColorB ~= ui.color.backgroundColor.b) or
--            (ui.isWeapon and (ui.originalMinDmg ~= luautils.round(ui.minDmg:getInternalText(),3) or ui.originalMaxDmg ~= luautils.round(ui.maxDmg:getInternalText(),3)
--                    or ui.originalMinAngle ~= luautils.round(ui.minAngle:getInternalText(),3) or ui.originalAimingTime ~= luautils.round(ui.aimingTime:getInternalText(),3)
--                    or ui.originalMinRange ~= luautils.round(ui.minRange:getInternalText(),3) or ui.originalMaxRange ~= luautils.round(ui.maxRange:getInternalText(),3)
--                    or ui.originalRecoilDelay ~= luautils.round(ui.recoilDelay:getInternalText(),3) or ui.originalReloadTime ~= luautils.round(ui.reloadTime:getInternalText(),3))
--            )

end

function ChainsawItemEditorUI:onOptionMouseDown(button, x, y)
    if button.internal == "SAVE" then
        self.item:setName(string.trim(self.name:getInternalText()));
        if self.originalWeight ~= string.trim(self.weight:getInternalText()) then
            self.item:setActualWeight(tonumber(string.trim(self.weight:getInternalText())));
            self.item:setCustomWeight(true);
        end
        self.item:setCondition(tonumber(string.trim(self.condition:getInternalText())));
		if (self.item:getConditionMax() - self.item:getCondition() == 0 ) and instanceof(self.item, "Clothing") then
			for i=1,BloodBodyPartType.MAX:index() do
				self.item:getVisual():removeHole(i-1)
			end
			self.admin:resetModelNextFrame();
			sendClothing(self.admin)
		end
        if self.originalColorR ~= self.color.backgroundColor.r or self.originalColorG ~= self.color.backgroundColor.g or self.originalColorB ~= self.color.backgroundColor.b then
            local color = Color.new(self.color.backgroundColor.r, self.color.backgroundColor.g, self.color.backgroundColor.b,1);
            self.item:setColor(color);
            self.item:getVisual():setTint(ImmutableColor.new(color));
            if self.admin:isEquipped(self.item) then
                self.admin:resetModelNextFrame();
            end
            self.item:setCustomColor(true);
        end
        if self.isWeapon then
            self.item:setMinDamage(tonumber(string.trim(self.minDmg:getInternalText())));
            self.item:setMaxDamage(tonumber(string.trim(self.maxDmg:getInternalText())));
            self.item:setMinAngle(tonumber(string.trim(self.minAngle:getInternalText())));
            if self.item:isRanged() then
                self.item:setMinRangeRanged(tonumber(string.trim(self.minRange:getInternalText())));
            else
                self.item:setMinRange(tonumber(string.trim(self.minRange:getInternalText())));
            end
            self.item:setMaxRange(tonumber(string.trim(self.maxRange:getInternalText())));
            -- self.item:setAimingTime(tonumber(string.trim(self.aimingTime:getInternalText())));
            self.modData.FuelCapacity = tonumber(string.trim(self.fuelCapacity:getInternalText()));
            self.modData.CurrentFuel = tonumber(string.trim(self.currentFuel:getInternalText()));
            self.modData.FuelConsumption = tonumber(string.trim(self.fuelConsumption:getInternalText()));
        end
        self:setVisible(false);
        self:removeFromUIManager();
    end
    if button.internal == "CANCEL" then
        self:setVisible(false);
        self:removeFromUIManager();
    end
end

function ChainsawItemEditorUI:onColor(button)
    self.colorPicker:setX(button:getAbsoluteX());
    self.colorPicker:setY(button:getAbsoluteY() + button:getHeight());
    self.colorPicker.pickedFunc = ChainsawItemEditorUI.onPickedColor;
    self.colorPicker:setInitialColor(self.item:getColorInfo());
    self.colorPicker:addToUIManager()
end

function ChainsawItemEditorUI:onPickedColor(color, mouseUp)
    self.color.backgroundColor = { r=color.r, g=color.g, b=color.b, a = 1 }
    self:updateButtons(self);
end

function ChainsawItemEditorUI:new(x, y, width, height, admin, item)
    local o = {};
    x = getMouseX() + 10;
    y = getMouseY() + 10;
    o = ISPanel:new(x, y, 400, height);
    setmetatable(o, self);
    self.__index = self;
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.zOffsetSmallFont = 25;
    o.moveWithMouse = true;
    o.admin = admin;
    o.item = item;
    o.modData = item:getModData();
    ChainsawItemEditorUI.instance = self;
    o.isWeapon = instanceof(item, "HandWeapon");
    o.isFood = instanceof(item, "Food");
    o.isDrainable = instanceof(item, "DrainableComboItem");

    return o;
end

return ChainsawItemEditorUI;
