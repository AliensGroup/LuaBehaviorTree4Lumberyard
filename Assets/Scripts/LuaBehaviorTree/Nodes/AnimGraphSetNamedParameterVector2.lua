local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local AnimGraphSetNamedParameter = require('Scripts.LuaBehaviorTree.Nodes.AnimGraphSetNamedParameter');

function split(inputstr, sep) sep=sep or '%s' local t={}  for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do table.insert(t,field)  if s=="" then return t end end end

--- Changes the value of a parameter in an Animation Graph.
---@class AnimGraphSetNamedParameterVector2: AnimGraphSetNamedParameter
local AnimGraphSetNamedParameterVector2 = class('AnimGraphSetNamedParameterVector2', AnimGraphSetNamedParameter);

function AnimGraphSetNamedParameterVector2:_setParameter()
    Debug.Log("Setting parameter Vector2 " .. self.parameter);
    AnimGraphComponentRequestBus.Event.SetParameterVector2(self.subject.entityId, self.index, self:_parseValue(self.value));
end

function AnimGraphSetNamedParameterVector2:_parseValue(value)
    if value == '1' or value == 1 then
        return Vector2(1, 1);
    elseif value == '0' or value == 0 then
        return Vector2(0, 0);
    elseif type(value) == "string" then
        local values = split(value, ',');
        if #values == 2 then
            return Vector2(tonumber(values[1]), tonumber(values[2]));
        end
    end

    return AnimGraphSetNamedParameter._parseValue(self, value);
end

return AnimGraphSetNamedParameterVector2;