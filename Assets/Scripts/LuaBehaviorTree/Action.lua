local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local Logger = require('Scripts.LuaBehaviorTree.Utils.Logger');

local Node = require('Scripts.LuaBehaviorTree.Node');

--- An action node, used to execute a specific thing.
---@class Action: Node
local Action = class('Action', Node);

function Action:_parseXmlNode(node, context)
    if node._children.n ~= 0 then
        Logger.error('The ' .. self.class.name .. ' node cannot have children.');
    end

    -- Copy attributes in node fields
    if node._attr then
        for key, value in pairs(node._attr) do
            self[key] = value;
        end
    end
end

return Action;
