local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');

local DecoratorNode = require('Scripts.LuaBehaviorTree.DecoratorNode');

--- Inverts the result of its child node. If the child return `running()`,
--- this node returns `running()` too.
---@class InvertorNode: DecoratorNode
local InvertorNode = class('InvertorNode', DecoratorNode);

function InvertorNode:success()
    self._parent:failure();
end

function InvertorNode:failure()
    self._parent:success();
end

return InvertorNode;