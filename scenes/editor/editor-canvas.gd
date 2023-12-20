extends Node2D

# @onready var GRID_SIZE = %TileMap.tile_set.tile_size
# @onready var GRID_SEPARATION = %TileMap.tile_set.get_source(0).separation

const MODE_PAINT = 0
const MODE_ERASE = 1
const MODE_TERRAIN = 2

var dragging = null
var mode = MODE_PAINT
var previous_mode = null # to go back after erase
var current_tile = null
var terrain_cells = []


func _ready():
	# Input.set_custom_mouse_cursor(cursor_cross, Input.CURSOR_CROSS)
	# Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	# get_tree().set_auto_accept_quit(false)
	set_current_tile(Constants.COIN)
	var data = GameManager.load_game()
	if data:
		%TileMap.clear()
		GameManager.set_tilemap_data(%TileMap, data)

func get_tilemap():
	return %TileMap

func get_grid_pixel():
	var p = get_local_mouse_position()
	return (p - $GridReference.get_pivot_offset()).snapped(Constants.GRID_SIZE)

func get_grid_index():
	return %TileMap.local_to_map(get_local_mouse_position())

func get_region(pos):
	return Rect2(pos * (Constants.GRID_SIZE + Constants.GRID_SEPARATION), Constants.GRID_SIZE)

func set_current_tile(pos):
	current_tile = pos
	$Sprite2D.set_region_rect(get_region(pos))	
	if current_tile in Constants.TERRAIN_SETS.keys():
		mode = MODE_TERRAIN
	else:
		mode = MODE_PAINT

func clear():
	%TileMap.clear()
		
func _input(event):
	if event.is_action_released("save"):
		GameManager.save_game(%TileMap)

	elif event is InputEventMouseMotion:
		$GridReference.position = get_grid_pixel()
		$Sprite2D.position = get_local_mouse_position()
		var ip = get_grid_index()
		var atlas_coords = $TileMap.get_cell_atlas_coords(0, ip)
		$Sprite2D.visible = atlas_coords == Constants.EMPTY

	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				var ip = get_grid_index()
				var atlas_coords = %TileMap.get_cell_atlas_coords(0, ip)
				if atlas_coords != Constants.EMPTY:
					if dragging == null:
						# start dragging:
						dragging = { "atlas_coords": atlas_coords, "previous_position": ip }
						$Sprite2D.set_region_rect(get_region(atlas_coords))
				else:
					if mode == MODE_TERRAIN:
						terrain_cells = []
			elif event.is_released():
				if dragging != null:
					# end dragging:
					var ip = get_grid_index()
					if ip != dragging["previous_position"]:
						%TileMap.set_cell(0, ip, 0, dragging["atlas_coords"])
						%TileMap.erase_cell(0, dragging["previous_position"])
					$Sprite2D.set_region_rect(get_region(current_tile))
					dragging = null
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				previous_mode = mode
				mode = MODE_ERASE
			elif event.is_released():
				mode = previous_mode
				previous_mode = null

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var ip = get_grid_index()
		if ip.x < 2 or ip.y < 2:
			pass
		elif dragging != null:
			pass
		elif mode == MODE_PAINT:
			var atlas_coords = %TileMap.get_cell_atlas_coords(0, ip)
			if atlas_coords == Constants.EMPTY:
				%TileMap.set_cell(0, ip, 0, current_tile)
		elif mode == MODE_TERRAIN:
			if ip not in terrain_cells:
			# if terrain_cells.size() == 0 or terrain_cells[-1] != ip:
				terrain_cells.append(ip)
				%TileMap.set_cells_terrain_connect(0, terrain_cells, Constants.TERRAIN_SETS[current_tile][0], Constants.TERRAIN_SETS[current_tile][1])
				# %TileMap.set_cells_terrain_path(0, terrain_cells, Constants.TERRAIN_SETS[current_tile][0], Constants.TERRAIN_SETS[current_tile][1])
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		$Sprite2D.visible = false
		if mode == MODE_ERASE:
			var ip = get_grid_index()
			%TileMap.erase_cell(0, ip)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		var ip = get_grid_index()
		var atlas_coords = %TileMap.get_cell_atlas_coords(0, ip)
		set_current_tile(atlas_coords)

