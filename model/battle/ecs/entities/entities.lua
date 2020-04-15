local COMMON = require "libs.common"
local TAG = "Entities"


---@class InputInfo
---@field action_id hash
---@field action table


---@class EntityMovement
---@field velocity vector3
---@field direction vector3
---@field max_speed number
---@field accel number
---@field deaccel number




---@class Entity
---@field tag string tag used for help when debug
---@field player boolean true if it player entity
---@field enemy boolean
---@field visible boolean
---@field position vector3
---@field movement EntityMovement
---@field angle vector3 radians anticlockwise  x-horizontal y-vertical
---@field input_info InputInfo used for player input
---@field auto_destroy boolean if true will be destroyed
---@field auto_destroy_delay number when auto_destroy false and delay nil or 0 then destroy entity
---@field root_go nil|url


---@class ENTITIES
local Entities = COMMON.class("Entities")

function Entities:initialize()
end
---@param world World
function Entities:set_world(world)
	self.world = assert(world)
	self.battle_model = assert(world.battle_model)
	self.ecs = assert(world.battle_model.ecs)
end

--region ecs callbacks
---@param e Entity
function Entities:on_entity_removed(e)
	if e.physics_body then
		physics3d.destroy_rect(e.physics_body)
	end
	if (e.light_params) then
		native_raycasting.camera_delete(e.light_params.camera)
	end
end

---@param e Entity
function Entities:on_entity_added(e)
end

---@param e Entity
function Entities:on_entity_updated(e)
end

--endregion


--region Entities

---@param pos vector3
---@return Entity
function Entities:create_player(pos)
	assert(pos)
	---@type Entity
	local e = {}
	e.tag = "player"
	e.position = vmath.vector3(pos.x, pos.y, pos.z)
	e.angle = vmath.vector3(0, 0, 0)
	e.player = true
	e.visible = true
	return e
end


---@return Entity
function Entities:create_input(action_id, action)
	return { input_info = { action_id = action_id, action = action }, auto_destroy = true }
end

return Entities




