local CLASS = require "libs.middleclass"
local ContextManager = require "libs.contexts_manager"

---@class ContextManagerProject:ContextManager
local Manager = CLASS.class("ContextManagerProject", ContextManager)

Manager.NAMES = {
	MAIN = "MAIN",
	GAME = "GAME",
	RENDER = "RENDER",
	GAME_UI = "GAME_UI",
}

---@class ContextStackWrapperMain:ContextStackWrapper
-----@field data ScriptMain

---@return ContextStackWrapperMain
function Manager:set_context_top_main()
	return self:set_context_top_by_name(self.NAMES.MAIN)
end


---@class ContextStackWrapperGameUI:ContextStackWrapper
-----@field data GameUIGuiScript

---@return ContextStackWrapperMain
function Manager:set_context_top_main()
	return self:set_context_top_by_name(self.NAMES.MAIN)
end

---@return ContextStackWrapperGameUI
function Manager:set_context_top_game_ui()
	return self:set_context_top_by_name(self.NAMES.GAME_UI)
end

return Manager()