local COMMON = require "libs.common"


---@class RoomConfig
---@field scene_name string

---@class World
---@field battle_model BattleModel|nil
local World = COMMON.class("World")



function World:initialize()
end

function World:update(dt)

end

function World:init()
	local SM = requiref "libs_project.sm"
	self.ROOMS_CONFIGS = {
		OPERATION = {scene_name = SM.ROOMS.OPERATION}
	}

	self.current_room = self.ROOMS_CONFIGS.OPERATION


	COMMON.APPLICATION.THREAD:add(function ()
		while(SM:is_working())do coroutine.yield() end
		SM:show(self.current_room.scene_name)
	end)
end

function World:final()

end

return World()

