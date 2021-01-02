local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local AnimGraphSetNamedParameter = require('Scripts.LuaBehaviorTree.Nodes.AnimGraphSetNamedParameter');

--- Changes the value of a parameter in an Animation Graph.
---@class AnimGraphSetNamedParameterBool: AnimGraphSetNamedParameter
local AnimGraphSetNamedParameterBool = class('AnimGraphSetNamedParameterBool', AnimGraphSetNamedParameter);

function AnimGraphSetNamedParameterBool:_setParameter()
    Debug.Log("Setting parameter bool " .. self.parameter);
    AnimGraphComponentRequestBus.Event.SetParameterBool(self.subject.entityId, self.index, self:_parseValue(self.value));
end

function AnimGraphSetNamedParameterBool:_parseValue(value)
    if value == true or value == 'true' or value == '1' or value == 1 then
        return true;
    elseif value == false or value == 'false' or value == '0' or value == 0 then
        return false;
    else
        return AnimGraphSetNamedParameter._parseValue(self, value);
    end
end

return AnimGraphSetNamedParameterBool;