local COMMON = require "libs.common"
local BaseScene = require "libs.sm.scene"


---@class StartRoomScene:Scene
local Scene = BaseScene:subclass("FlatRoomScene")
function Scene:initialize()
	BaseScene.initialize(self, "FlatRoomScene", "/flat_room_scene#collectionproxy")
end

function Scene:load_done()

end

function Scene:show_done()

end

function Scene:hide_done()

end

function Scene:pause_done()

end

function Scene:resume_done()

end


function Scene:update(dt)
end

function Scene:on_input(action_id, action)
	
end

function Scene:unload_done()
	
end

return Scene