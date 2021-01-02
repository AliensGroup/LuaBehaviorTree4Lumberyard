local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local Action = require('Scripts.LuaBehaviorTree.Action');

--- Waits for a given amount of seconds.
---@class Wait: Action
---@field seconds number The amount of seconds to wait for.
local Wait = class('Wait', Action);

function Wait:start()
    self._countdown = self.seconds;
end

function Wait:tick()
    local dt = TickRequestBus.Broadcast.GetTickDeltaTime();
    self._countdown = self._countdown - dt;
    if self._countdown <= 0 then
        self._countdown = self.seconds;
        self:success();
    else
        self:running();
    end
end

return Wait;