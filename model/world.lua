local COMMON = require "libs.common"
local Room = require "model.rooms.room"

---@class World
---@field battle_model BattleModel|nil
local World = COMMON.class("World")

function World:initialize()
end

function World:update(dt)
	if (self.current_room) then
		if (COMMON.CONTEXT:exist(COMMON.CONTEXT.NAMES.GAME_UI)) then
			local ctx = COMMON.CONTEXT:set_context_top_game_ui()
			ctx.data:room_set_over_object(self.current_room.object_over)
		end
	end
end

function World:init()
	self.SM = requiref "libs_project.sm"
	self.ROOMS_CONFIGS = {
		--TO_ Take Object
		OPERATION = { scene_name = self.SM.ROOMS.OPERATION, objects = {
			box = { id = "box", info = true, order = 1 },
			operation_table = { id = "operation_table", speech = true },
			door = { id = "door", action = true },
			lamp = { id = "lamp", info = true },
			human = { id = "human", action = true, order = 10 },
			table_with_wheels = { id = "table_with_wheels", action = true },
			pc_top = { id = "pc_top", action = true },
			pc_wall = { id = "pc_wall", action = true },
			TO_banana = { id = "TO_banana", take = true },
		} }
	}

	self.objects = {
		banana = { id = "banana", view = { icon_scale = 0.55 } }
	}

	self.inventory = {}

	self.rooms = {
		OPERATION = Room(self.ROOMS_CONFIGS.OPERATION, self)
	}

	self:room_change(self.rooms.OPERATION)

end

function World:take_object(object)
	assert(object)
	self.current_room:remove_object(object)
	assert(not COMMON.LUME.findi(self.inventory, object))
	table.insert(self.inventory, object)

end

function World:user_click()
	if (self.current_room.object_over) then
		COMMON.i("click on:" .. self.current_room.object_over.config.id, "ROOM")
		if (self.current_room.object_over.take) then
			self:take_object(self.current_room.object_over)
		end
	end
end

---@param room Room
function World:room_change(room)
	self.current_room = assert(room)
	assert(not self.room_changing, "already changing room")
	self.room_changing = true
	COMMON.APPLICATION.THREAD:add(function()
		while (self.SM:is_working()) do coroutine.yield() end
		self.SM:show(self.current_room.config.scene_name)
		while (self.SM:is_working()) do coroutine.yield() end
		self.room_changing = false
	end)
end

function World:final()

end

return World()

