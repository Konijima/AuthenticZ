--- Code by Konijima, 2022
--- Make tree selectable to chainsaw them down savagely :D

local ChainsawAPI = require("Chainsaw/ChainsawAPI");
local ChainsawCutTreeAction = require("Chainsaw/TimedActions/ChainsawCutTreeAction");

local function doChopTree(playerObj, chainsaw, tree)
    if luautils.walkAdj(playerObj, tree:getSquare()) then
        ISTimedActionQueue.add(ChainsawCutTreeAction:new(playerObj, chainsaw, tree));
    end
end

---@class ChainsawTreeCursor : ISBuildingObject
ChainsawTreeCursor = ISBuildingObject:derive("ChainsawTreeCursor")

function ChainsawTreeCursor:create(x, y, z, north, sprite)
	local square = getWorld():getCell():getGridSquare(x, y, z)
	doChopTree(self.character, self.chainsaw, square:getTree());
end

function ChainsawTreeCursor:isValid(square)
	return square:HasTree() and ChainsawAPI.isChainsawRunning(self.chainsaw);
end

function ChainsawTreeCursor:render(x, y, z, square)
	if not ChainsawTreeCursor.floorSprite then
		ChainsawTreeCursor.floorSprite = IsoSprite.new()
		ChainsawTreeCursor.floorSprite:LoadFramesNoDirPageSimple('media/ui/FloorTileCursor.png')
	end
	local r,g,b,a = 0.0,1.0,0.0,0.8
	if self:isValid(square) then
		square:getTree():setHighlighted(true)
	else
		r = 1.0
		g = 0.0
	end
	ChainsawTreeCursor.floorSprite:RenderGhostTileColor(x, y, z, r, g, b, a)
	IsoTree.setChopTreeCursorLocation(self.player, x, y, z)
end

function ChainsawTreeCursor:new(sprite, northSprite, character, chainsaw)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o:init()
	o:setSprite(sprite)
	o:setNorthSprite(northSprite)
	o.character = character
    o.chainsaw = chainsaw;
	o.player = character:getPlayerNum()
	o.noNeedHammer = true
	o.skipBuildAction = true
	return o
end
