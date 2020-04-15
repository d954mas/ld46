local COMMON = require "libs.common"
local GameEcs = require "model.battle.ecs.game_ecs"

---@class BattleModel
local Model = COMMON.class("BattleModel")

---@param world World
---@param level Level
function Model:initialize(world)
	self.world = assert(world)
	self.time = 0
	self.ecs = GameEcs(self.world)
end

function Model:on_scene_show()
	if (not self.inited) then
		self.inited = true
	end
end

function Model:load_level()
	physics3d.init()
	self.ecs:load_level()
end

function Model:update(dt)
	self.time = self.time + dt
	if (self.inited) then
		self.ecs:update(dt)
	end
end

function Model:on_input(action, action_id) end

function Model:final()
	if self.ecs then self.ecs:clear() end
	physics3d.clear()
	self.ecs = nil
	self.level = nil
end

return Model