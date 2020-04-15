local COMMON = require "libs.common"
local M = {}
local TAG = "LEVEL"



function M.load_level(name)
	local time = os.clock()
	local data = {}
	COMMON.d("lvl:" .. name .. " loaded. Time:" .. (os.clock() - time), TAG)
	return data
end

return M