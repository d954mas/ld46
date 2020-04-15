local WORLD = require "model.world"

--UPDATE SOME INFO.
--THAT INFO USED BY DEBUG GUI
local M = {}

M.entities = 0

function M.init()
end




function M.update_entities()
	local have_ecs = WORLD.battle_model and WORLD.battle_model.ecs and WORLD.battle_model.ecs
end

function M.update(dt)
	local have_ecs = WORLD.battle_model and WORLD.battle_model.ecs and WORLD.battle_model.ecs
	M.entities = have_ecs and #have_ecs.ecs.entities or 0
end

return M