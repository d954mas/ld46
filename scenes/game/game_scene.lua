local COMMON = require "libs.common"
local WORLD = require "model.world"
local BaseScene = require "libs.sm.scene"
local CURSOR_HELPER = require "libs_project.cursor_helper"

---@class GameScene:Scene
local Scene = BaseScene:subclass("GameScene")
function Scene:initialize()
	BaseScene.initialize(self, "GameScene", "/game_scene#collectionproxy", { always_show = true, always_run = true })
end

function Scene:load_done()
	self.sm = requiref "libs_project.sm"
	self.sheduler = COMMON.RX.CooperativeScheduler.create()
	self.subscription = COMMON.EVENT_BUS:subscribe("speech_ended"):go(self.sheduler):subscribe(function(data)
		WORLD:dialog_completed(data.id)
	end)
	WORLD:init()
end

function Scene:show_done()
	COMMON.input_acquire()
	CURSOR_HELPER.register_listeners()
	CURSOR_HELPER.lock_cursor()
end

function Scene:hide_done()
	COMMON.input_release()
	CURSOR_HELPER.unregister_listener()
end

function Scene:pause_done()

end

function Scene:resume_done()

end

function Scene:update(dt)
	self.sheduler:update(dt)
	WORLD:update(dt)
end

function Scene:on_input(action_id, action)
end

function Scene:unload_done()
	self.subscription:unsubscribe()
	WORLD:final()
end

return Scene