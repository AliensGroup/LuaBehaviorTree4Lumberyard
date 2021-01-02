local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local Action = require('Scripts.LuaBehaviorTree.Action');

--- Finds the path to an entity for an AI agent.
---@class NavigationFindPathToEntity: Action
---@field target userdata The target entity.
---@field onTraversalStarted function This function is called as soon the AI agent starts navigating.
---@field onTraversalInProgress function This function is called each time the navigation is in progress.
---@field onTraversalPathUpdate function This function is called each time the AI navpath is updated.
---@field onTraversalComplete function This function is called as soon the AI agent has reached the target.
---@field onTraversalCancelled function This function is called when the navigation request is explicitly cancelled.
local NavigationFindPathToEntity = class('NavigationFindPathToEntity', Action);

function NavigationFindPathToEntity:initialize(config)
    Action.initialize(self, config);

    self._navigationState = "invalid";
end

function NavigationFindPathToEntity:start()
    if self.target ~= nil then
        local currentTarget = self:_parseValue(self.target);
        if not self._requestId or currentTarget ~= self._lastTarget then
            self._lastTarget = currentTarget;
            self._navigationState = "invalid";
            self:_restartNavigation();
            self:_reconnectBus();
        end
    else
        Debug.Log("No target provided");
    end
end

function NavigationFindPathToEntity:tick()
    if self._lastTarget and self._lastTarget:IsValid() and self._requestId then
        Debug.Log("Has target");
        Debug.Log(self._navigationState);
        if self._navigationState == "navigating" then
            self:running();
        elseif self._navigationState == "reached" then
            self:success();
        else
            self:failure();
        end
    else
        self:failure();
    end
end

function NavigationFindPathToEntity:_connectBus()
    if self._navigationNotificationBus == nil then
        self._navigationNotificationBus = NavigationComponentNotificationBus.Connect(self, self.subject.entityId, self._requestId);
        Debug.Log("NavMesh -> Bus connected");
    end
end

function NavigationFindPathToEntity:_disconnectBus()
    if self._navigationNotificationBus ~= nil then
        self._navigationNotificationBus:Disconnect();
        self._navigationNotificationBus = nil;
        Debug.Log("NavMesh -> Bus disconnected");
    end
end

function NavigationFindPathToEntity:_reconnectBus()
    self:_disconnectBus();
    self:_connectBus();
    Debug.Log("NavMesh -> Bus reconnected");
end

function NavigationFindPathToEntity:StartNavigation()
    if self._requestId == nil then
        self._requestId = NavigationComponentRequestBus.Event.FindPathToEntity(self.subject.entityId, self._lastTarget);
        Debug.Log("NavMesh -> Navigation started");
    end
end

function NavigationFindPathToEntity:StopNavigation()
    if self._requestId then
        NavigationComponentRequestBus.Event.Stop(self.subject.entityId, self._requestId);
        self._requestId = nil;
        Debug.Log("NavMesh -> Navigation stopped");
    end
end

function NavigationFindPathToEntity:_restartNavigation()
    self:StopNavigation();
    self:StartNavigation();
    Debug.Log("NavMesh -> Navigation restarted");
end

function NavigationFindPathToEntity:_parseValue(value)
    local tree = self:getNearestBehaviorTreeNode();
    if type(value) == "string" and tree.properties[value] ~= nil then
        return tree.properties[value];
    else
        return value;
    end
end


function NavigationFindPathToEntity:OnTraversalStarted(requestId)
    if requestId == self._requestId then
        if self.onTraversalStarted then
            self.onTraversalStarted(self, requestId);
        end
        self._navigationState = "navigating";
        Debug.Log("Traversal Started");
    end
end

function NavigationFindPathToEntity:OnTraversalInProgress(requestId, distanceRemaining)
    if requestId == self._requestId then
        if self.onTraversalInProgress then
            self.onTraversalInProgress(self, requestId, distanceRemaining);
        end
        self._navigationState = "navigating";
        Debug.Log("Traversal In Progress");
    end
end

function NavigationFindPathToEntity:OnTraversalPathUpdate(requestId, nextPathPosition, inflectionPosition)
    if requestId == self._requestId then
        if self.onTraversalPathUpdate then
            self.onTraversalPathUpdate(self, requestId, nextPathPosition, inflectionPosition);
        end
        self._navigationState = "navigating";
        Debug.Log("Traversal Path Update");
    end
end

function NavigationFindPathToEntity:OnTraversalComplete(requestId)
    if requestId == self._requestId then
        if self.onTraversalComplete then
            self.onTraversalComplete(self, requestId);
        end
        self._navigationState = "reached";
        Debug.Log("Traversal Complete");
    end
end

function NavigationFindPathToEntity:OnTraversalCancelled(requestId)
    if requestId == self._requestId then
        if self.onTraversalCancelled then
            self.onTraversalCancelled(self, requestId);
        end
        self._navigationState = "invalid";
        Debug.Log("Traversal Cancelled");
    end
end

return NavigationFindPathToEntity;