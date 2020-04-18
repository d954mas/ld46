local SM = require "libs.sm.scene_manager"
--MAIN SCENE MANAGER
local sm = SM()


local scenes = {
	require "scenes.main_menu.main_menu_scene",
	require "scenes.game.game_scene",
	require "scenes.rooms.operation.operation_scene"
}

sm.SCENES = {
	MAIN_MENU = "MainMenuScene",
	GAME_SCENE = "GameScene"
}

sm.ROOMS = {
	OPERATION = "OperationRoomScene"
}

sm.MODALS = {
	PAUSE = "PauseModal"
}

function sm:register_scenes()
	local reg_scenes = {}
	for i, v in ipairs(scenes) do reg_scenes[i] = v() end --create instances
	self:register(reg_scenes)
end

return sm