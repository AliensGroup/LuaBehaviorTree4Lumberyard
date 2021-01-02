local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local Logger = require('Scripts.LuaBehaviorTree.Utils.Logger');

local Action = require('Scripts.LuaBehaviorTree.Action');

--- Changes the value of a parameter in an Animation Graph.
---@class AnimGraphSetNamedParameter: Action
---@field parameter string The name of the parameter to edit.
---@field value any The value to give to the parameter.
---@field index number The parameter index in the Animation Graph.
local AnimGraphSetNamedParameter = class('AnimGraphSetNamedParameter', Action);

AnimGraphSetNamedParameter.static.INVALID_PARAMETER_INDEX = 2^32 - 1;

function AnimGraphSetNamedParameter:start()
    Action.start(self);

    self.index = AnimGraphComponentRequestBus.Event.FindParameterIndex(self.subject.entityId, self.parameter);

    if self.index == AnimGraphSetNamedParameter.static.INVALID_PARAMETER_INDEX then
        Logger.debug("The named parameter " .. self.parameter .. " was not found in the animation graph.");
    end
end

function AnimGraphSetNamedParameter:tick()
    if self.index == AnimGraphSetNamedParameter.static.INVALID_PARAMETER_INDEX then
        self:failure();
    else
        self:_setParameter();
        self:success();
    end
end

function AnimGraphSetNamedParameter:_setParameter()
    Logger.debug('Usage of unimplemented BehaviorTree node.');
end

--- Parses the given value before give it to the parameter.
---@param value string The value to parse.
---@return any
function AnimGraphSetNamedParameter:_parseValue(value)
    -- Default implementation doesn't do any parsing on the value
    local tree = self:getNearestBehaviorTreeNode();

    if tree.properties[value] ~= nil then
        return tree.properties[value];
    else
        return value;
    end
end

return AnimGraphSetNamedParameter;