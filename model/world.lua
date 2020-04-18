local COMMON = require "libs.common"
local Room = require "model.rooms.room"
local SpeechContent = require "model.speech.speech_content"

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

---@class InventoryObject
---@field id string
---@field icon string|hash

function World:init()
	self.SM = requiref "libs_project.sm"

	self.objects = {
		banana = { id = "banana", icon = hash("banana_icon") },
		knife = { id = "knife", icon = hash("knife_icon") }
	}

	self.ROOMS_CONFIGS = {
		--TO_ Take Object
		FLAT = { scene_name = self.SM.ROOMS.FLAT,
				 objects = {
					 door = { id = "door", action = true, order = 1 },
					 phone = { id = "phone", action = true, order = 2 },
					 curtains = { id = "curtains", action = true },
					 box = { id = "box", action = true, },
				 }
		},
		OPERATION = { scene_name = self.SM.ROOMS.OPERATION,
					  objects = {
						  box = { id = "box", info = true, order = 1 },
						  operation_table = { id = "operation_table", speech = true },
						  door = { id = "door", action = true },
						  lamp = { id = "lamp", info = true },
						  human = { id = "human", action = true, order = 10 },
						  table_with_wheels = { id = "table_with_wheels", action = true },
						  pc_top = { id = "pc_top", action = true },
						  pc_wall = { id = "pc_wall", action = true },
						  TO_banana = { id = "TO_banana", take = self.objects.banana },
						  TO_knife = { id = "TO_knife", take = self.objects.knife, order = 11 },
					  }
		}
	}

	---@type InventoryObject[]
	self.inventory = {}

	self.rooms = {
		FLAT = Room(self.ROOMS_CONFIGS.FLAT, self),
		START = Room(self.ROOMS_CONFIGS.OPERATION, self)
	}

	self.room_can_click = true

	self.active_object = nil
	self.speech = false

	self:room_change(self.rooms.FLAT)

	self.game_events = {
		flat_phone_call = true
	}

end

function World:take_object(object)
	if (self.active_object) then return end
	if (self.speech) then return end
	assert(object)
	assert(object.take)
	self.current_room:remove_object(object)
	assert(not self.objects[object.id], "no object with id:" .. object.take.id)
	self:inventory_add_object(object.take)
end

---@param object RoomObject
function World:interact_object(object)
	if(self.speech) then return end
	if (self.current_room == self.rooms.FLAT) then
		if (object.config.id == "phone") then
			if (self.game_events.flat_phone_call) then
				self.game_events.flat_phone_call = false
				self:dialog(SpeechContent.FLAT_PHONE_CALL_1.id)
				--show dialog
			else
				--reaction i do not need to call someone
			end
		end
	end
end

---@param object InventoryObject
function World:inventory_add_object(object)
	assert(object)
	assert(not COMMON.LUME.findi(self.inventory, object))
	table.insert(self.inventory, object)
end

---@param object InventoryObject
function World:inventory_remove_object(object)
	assert(object)
	local idx = COMMON.LUME.findi(self.inventory, object)
	assert(idx)
	table.remove(self.inventory, idx)

end

function World:user_click()
	if (self.active_object or self.speech) then
		return
	end
	if (self.room_can_click and self.current_room.object_over) then
		COMMON.i("click on:" .. self.current_room.object_over.config.id, "ROOM")
		if (self.current_room.object_over.take) then
			self:take_object(self.current_room.object_over)
		end
		if (self.current_room.object_over.action) then
			self:interact_object(self.current_room.object_over)
		end
	end
end

function World:dialog(id)
	msg.post("game_scene:/speech_controller", "trigger_speech", { id = id })
end

---@param object_1 InventoryObject
---@param object_2 InventoryObject
function World:mix_object(object_1, object_2)
	if(self.speech) then return end
	assert(object_1)
	assert(object_2)
	--objects order is in alphabet. knife->banana == banana->knife
	if (object_2.id < object_1.id) then
		local object_tmp = object_1
		object_1 = object_2
		object_2 = object_tmp
	end
	print("mix " .. object_1.id .. " vs " .. object_2.id)

	if (object_1.id == "banana") then
		self:inventory_remove_object(object_1)
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

