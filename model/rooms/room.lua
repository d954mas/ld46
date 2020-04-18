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
		self:add_object(RoomObject({ id = object.id }))
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