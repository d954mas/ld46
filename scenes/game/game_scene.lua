local COMMON = require "libs.common"
local WORLD = require "model.world"
local CURSOR_HELPER = require "libs_project.cursor_helper"
local BaseScene = require "libs.sm.scene"


---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
	BaseScene.initialize(self, "GameScene", "/game_scene#collectionproxy")
end

function Scene:load_done()
	assert(self._input, "GameScene need input")
	self.sm = requiref "libs_project.sm"
	WORLD:battle_set_level()
end

function Scene:show_done()
	WORLD.battle_model:on_scene_show()
	CURSOR_HELPER.register_listeners()
end

function Scene:hide_done()
	CURSOR_HELPER.unregister_listener()
end

function Scene:pause_done()

end

function Scene:resume_done()

end


function Scene:update(dt)
end

function Scene:on_input(action_id, action)
	CURSOR_HELPER.on_input(action_id,action)
	if action_id == COMMON.HASHES.INPUT.ESK and action.released then
		self.sm:show(self.sm.MODALS.PAUSE)
		return true
	end
end

function Scene:unload_done()
	WORLD:battle_model_final()
	self.level = nil
end

return Scene