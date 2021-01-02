local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');

local BranchNode = require('Scripts.LuaBehaviorTree.BranchNode');

--- Executes each child nodes sequentially until one node returns `failure()`,
--- or all nodes returns `success()`. If every child nodes returns `success()`,
--- the `Sequence` node returns `success()` too, otherwise returns `failure()`.
---@class Sequence: BranchNode
local Sequence = class('Sequence', BranchNode);

function Sequence:success()
    BranchNode.success(self);
    self._actualTask = self._actualTask + 1;
    if self._actualTask <= #self.children then
        self:_tick();
    else
        self._parent:success();
    end
end

function Sequence:failure()
    BranchNode.failure(self);
    self._parent:failure();
end

return Sequence;