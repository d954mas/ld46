local COMMON = require "libs.common"

---@class RoomObjectViewConfig
---@field room_object RoomObject
---@field root GuiNode

---@class RoomObjectView
local Object = COMMON.class("RoomObjectView")

---@param config RoomObjectViewConfig
function Object:initialize(config)
	checks("?", {
		root = "?"
	})
	self.config = assert(config)
	self.pointer_over = false
end

---@param room_object RoomObject
function Object:set_room_object(room_object)
	assert(not self.room_object)
	self.room_object = assert(room_object)
end

function Object:set_touch_node(node)
	self.node_touch = assert(node)
end

function Object:is_hit(x, y)
	local node = self.node_touch or self.config.root
	return gui.is_enabled(self.config.root) and gui.pick_node(node, x, y)
end

function Object:set_visible(visible)
	gui.set_enabled(self.config.root, visible)
end

return Object