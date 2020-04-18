local COMMON = require "libs.common"

---@class Room
local Room = COMMON.class("Room")

---@param config RoomConfig
---@param world World
function Room:initialize(config, world)
	self.config = assert(config)
	self.world = assert(world)
end


return Room