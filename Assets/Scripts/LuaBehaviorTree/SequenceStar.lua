local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');

local Sequence = require('Scripts.LuaBehaviorTree.Sequence');

--- Use this sequence node when you don't want to tick children again that already returned `success()`.
---@class SequenceStar: Sequence
local SequenceStar = class('SequenceStar', Sequence);

function SequenceStar:failure()
    Sequence.running(self);
end

function SequenceStar:running()
    Sequence.running(self);
end

return SequenceStar;