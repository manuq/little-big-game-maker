extends Node

const GRID_SIZE = Vector2i(18, 18)
const GRID_SEPARATION = Vector2i(1, 1)

const EMPTY = Vector2i(-1, -1)

# items:
const COIN = Vector2i(11, 7)

const ITEMS = [COIN]

# blocks
const CAGE = Vector2i(9, 0)
const TUBE = Vector2i(15, 4) # terrain set 0
const BLOCK = Vector2i(7, 2) # terrain set 0
const GROUND = Vector2i(0, 0) # terrain set 1

const BLOCKS = [
	CAGE,
	TUBE,
	BLOCK,
	GROUND,
]

const TERRAIN_SETS = {
	TUBE: [0, 0],
	BLOCK: [0, 1],
	GROUND: [1, 0],
}

# players:
const PLAYER_PLATFORMER = Vector2i(7, 6)
const PLAYER_SHIP = Vector2i(6, 6)
const PLAYER_SLUG = Vector2i(8, 6)

const PLAYERS = [
	PLAYER_PLATFORMER,
	PLAYER_SHIP,
	PLAYER_SLUG,
]

# npcs:
const NPC_PLATFORMER = Vector2i(6, 7)
const NPC_SHIP = Vector2i(5, 6)
const NPC_SLUG = Vector2i(4, 6)

const NPCS = [
	NPC_PLATFORMER,
	NPC_SHIP,
	NPC_SLUG,
]

var ALL = ITEMS + BLOCKS + PLAYERS + NPCS
