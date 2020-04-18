local COMMON = require "libs.common"

---@class RoomObjectConfig
---@field id string

---@class RoomObject
local Object = COMMON.class("RoomObject")

---@param config RoomObjectConfig
function Object:initialize(config)
	checks("?", {
		id = "string"
	})
	self.config = assert(config)
end

---@param room Room
function Object:set_room(room)
	assert(not self.room, "already in room")
	self.room = room
end

---@param view RoomObjectView
function Object:set_view(view)
	view:set_room_object(self)
	self.view = assert(view)
end

return Object