local COMMON = require "libs.common"
local RoomObject = require "model.rooms.room_object"

---@class RoomConfig
---@field scene_name string
---@field objects table

---@class Room
local Room = COMMON.class("Room")

---@param config RoomConfig
---@param world World
function Room:initialize(config, world)
	self.config = assert(config)
	self.world = assert(world)
	---@type RoomObject[]
	self.objects = {}
	local order = 0
	for k, object in pairs(self.config.objects) do
		order = order + 0.001
		local room_object = RoomObject({ id = object.id })
		if (object.info) then room_object:set_info(object.info) end
		if (object.speech) then room_object:set_speech(object.speech) end
		if (object.action) then room_object:set_action(object.action) end
		if (object.take) then room_object:set_take(object.take) end

		room_object:set_order(object.order or order)
		print("add object:" .. room_object.config.id)
		self:add_object(room_object)
	end
end

---@param object RoomObject
function Room:object_set_over(object)
	if (self.object_over == object) then return end
	if (self.object_over) then
		COMMON.LOG.i("object:" .. self.object_over.config.id .. " over end", "ROOM")
	end
	self.object_over = object
	if (self.object_over) then
		COMMON.LOG.i("object:" .. self.object_over.config.id .. " over", "ROOM")
	end
end

---@param object RoomObject
function Room:add_object(object)
	assert(object)
	assert(not self.objects[object.config.id])
	assert(object.info or object.action or object.speech or object.take, "no action:" .. object.config.id)
	self.objects[object.config.id] = object
	object:set_room(self)
end

---@return RoomObject
function Room:get_object_by_id(id)
	assert(id)
	return assert(self.objects[id], "no object with id" .. id)
end

function Room:on_input(action_id, action)
	local over_objects = {}
	for _, object in pairs(self.objects) do
		if (object.view:is_hit(action.x, action.y)) then
			table.insert(over_objects, object)
		end
	end
	table.sort(over_objects, function(a, b)
		local order_a = a.order or 0
		local order_b = b.order or 0
		return order_a >= order_b
	end)
	self:object_set_over(over_objects[1])
end

return Room