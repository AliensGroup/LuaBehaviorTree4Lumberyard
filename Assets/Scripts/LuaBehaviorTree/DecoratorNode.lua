local class = require('Scripts.LuaBehaviorTree.Utils.MiddleClass');
local Logger = require('Scripts.LuaBehaviorTree.Utils.Logger');

local Registry = require('Scripts.LuaBehaviorTree.NodeRegistry');
local Node = require('Scripts.LuaBehaviorTree.Node');

--- Represents a decorator node of a behavior tree.
---@class DecoratorNode: Node
local DecoratorNode = class('DecoratorNode', Node);

function DecoratorNode:initialize(config)
    Node.initialize(self, config);
    self:_setChild(self.child);
end

function DecoratorNode:start()
    self.child:start();
    Node.start(self);
end

function DecoratorNode:tick()
    Node.tick(self);
    self.child:_setParent(self);
    self.child:tick();
end

function DecoratorNode:finish()
    Node.finish(self);
    self.child:finish();
end

function DecoratorNode:setSubject(subject)
    Node.setSubject(self, subject);
    if self.child then
        self.child:setSubject(subject);
    end
end

function DecoratorNode:_setChild(node)
    self.child = Registry.getNode(node);
    self:setSubject(self.subject);
end

function DecoratorNode:_parseXmlNode(node, context)
    if node._name ~= self.class.name then
        Logger.error('Tried to parse an invalid node as a ' .. self.class.name .. ' node.');
    end

    if node._children.n ~= 1 then
        Logger.error('A DecoratorNode must only have one children.');
    end

    local current = node._children[1];
    local child = Node._parseXmlNode(self, current, context);

    self.child = child;
end

return DecoratorNode;