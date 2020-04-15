local M = {}

--ecs systems created in require.
--so do not cache then
local require_old = require
local require = function(k)
	local m = require_old(k)
	package.loaded[k] = nil
	return m
end

function M.load()
	M.AutoDestroySystem = require "model.battle.ecs.systems.auto_destroy_system"
end

return M