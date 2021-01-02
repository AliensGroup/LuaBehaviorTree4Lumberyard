local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local Logger = require('Scripts.LuaBehaviorTree.Utils.Logger');

local Action = require('Scripts.LuaBehaviorTree.Action');

--- Returns a specific result.
---@class Return: Action
---@field value '"success"'|'"failure"'|'"running"' The result to return.
local Return = class('Return', Action);

function Return:tick()
    if self.value == "success" then
        return self:success();
    elseif self.value == "failure" then
        return self:failure();
    elseif self.value == "running" then
        return self:running();
    else
        return self:success();
    end
end

function Return:_parseXmlNode(node, context)
    if not node._attr or not node._attr.value then
        Logger.error('The Return node must have a value attribute.');
    end

    Action._parseXmlNode(self, node, context);
end

return Return;