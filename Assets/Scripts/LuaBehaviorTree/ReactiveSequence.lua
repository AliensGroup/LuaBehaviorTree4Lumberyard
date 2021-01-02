local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');

local Sequence = require('Scripts.LuaBehaviorTree.Sequence');

--- Executes each child nodes sequentially until one node returns `failure()`,
--- or all nodes returns `success()`. If every child nodes returns `success()`,
--- the `ReactiveSequence` node returns `success()` too, otherwise returns `failure()`.
--- If a node returns `running()`, the `ReactiveSequence` node will restart the sequence.
---@class ReactiveSequence: Sequence
local ReactiveSequence = class('ReactiveSequence', Sequence);

function ReactiveSequence:running()
    self._running = false;
    self._actualTask = 1;
    self._parent:running();
end

return ReactiveSequence;