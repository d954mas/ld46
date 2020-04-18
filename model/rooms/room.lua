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
	for k, object in pairs(self.config.objects) do
		local room_object = RoomObject({ id = object.id })
		if (object.info) then room_object:set_info(object.info) end
		if (object.speech) then room_object:set_speech(object.speech) end
		if (object.action) then room_object:set_action(object.action) end
		assert(room_object.info or room_object.action or room_object.speech, "no action:" .. object.id)
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
	self.objects[object.config.id] = object
	object:set_room(self)
end

---@return RoomObject
function Room:get_object_by_id(id)
	assert(id)
	return assert(self.objects[id], "no object with id" .. id)
end

return Room