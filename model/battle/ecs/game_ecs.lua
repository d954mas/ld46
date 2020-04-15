local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "model.battle.ecs.systems"
local Entities = require "model.battle.ecs.entities.entities"

---@class GameEcsWorld
local EcsWorld = COMMON.class("EcsWorld")

---@param world World
function EcsWorld:initialize(world)
	self.ecs = ECS.world()
	self.ecs.game = self
	self.world = assert(world)
	self.entities = Entities(world)
	self:_init_systems()
	self.ecs.on_entity_added = function(...) self.entities:on_entity_added(...) end
	self.ecs.on_entity_updated = function(...) self.entities:on_entity_updated(...) end
	self.ecs.on_entity_removed = function(...) self.entities:on_entity_removed(...) end
end

function EcsWorld:_init_systems()
	SYSTEMS.load()
	self.ecs:addSystem(SYSTEMS.AutoDestroySystem)
end

function EcsWorld:load_level()
	assert(not self.level_loaded)
	self.level_loaded = true
	self.level = self.world.battle_model.level
end

function EcsWorld:update(dt)
	self.ecs:update(dt)
end

function EcsWorld:clear()
	self.ecs:clear()
	self.ecs:refresh()
end

function EcsWorld:add(...)
	self.ecs:add(...)
end

function EcsWorld:add_entity(e)
	self.ecs:addEntity(e)
end

function EcsWorld:remove_entity(e)
	self.ecs:removeEntity(e)
end

return EcsWorld



