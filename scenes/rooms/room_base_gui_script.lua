local COMMON = require "libs.common"
local WORLD = require "model.world"
local RoomObjectView = require "model.rooms.room_object_view"
local ACTIONS = require "libs.actions.actions"

---@class RoomBaseGUI
local Script = COMMON.new_n28s()

function Script:bind_vh() end

function Script:init_gui() end

function Script:bind_room()

end

function Script:bind_config()
end

function Script:init()
	COMMON.input_acquire()
	self:bind_vh()
	self:init_gui()
	self:bind_room()
	self:bind_config()
	self.thread = COMMON.ThreadManager()
	self.animations = ACTIONS.Sequence()
	self.animations.drop_empty = false
	self.thread:add(self.animations)

	for k, object in pairs(self.config.objects) do
		self.room:get_object_by_id(object.id):set_view(RoomObjectView({ root = gui.get_node(object.id) }))
	end

	self:init_done()
end

function Script:init_done()

end

function Script:update(dt)
	self.thread:update(dt)
end

function Script:final()
	COMMON.input_release()
end

function Script:on_input(action_id, action)
	self.room:on_input(action_id, action)

	if action_id == COMMON.HASHES.INPUT.TOUCH and action.pressed then
		WORLD:user_click()
	end
end

return Script