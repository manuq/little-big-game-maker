extends Node

const FILENAME = "user://game-01.save"

var scenes = {}
var parameters = {
	Constants.NPC_PLATFORMER: { "SPEED": 50.0 },
	Constants.PLAYER_SLUG: { "SPEED": 50.0 },
	Constants.NPC_SHIP: { "SPEED": 100.0, "ROTATION_SPEED": 3.0 },
	# ROTATION_SPEED
}

var editor_pack = preload("res://scenes/editor/editor.tscn")
var game_pack = preload("res://scenes/game/game.tscn")
var editor_scene: Editor = null
var game_scene: Game = null

func quit():
	save_game(editor_scene.get_tilemap())
	get_tree().quit()

func on_window_quit(event):
	if event == DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
		quit()

func _ready():
	var root = get_tree().root
	var main_scene = root.get_child(root.get_child_count() - 1)
	if main_scene is Editor:
		editor_scene = main_scene
		game_scene = game_pack.instantiate()
	elif main_scene is Game:
		game_scene = main_scene
		editor_scene = editor_pack.instantiate()
	DisplayServer.window_set_window_event_callback(on_window_quit)

func _input(event):
	if event.is_action_released("ui_cancel"):
		quit()

func switch_to_editor():
	call_deferred("_deferred_switch_to_editor")

func switch_to_game():
	call_deferred("_deferred_switch_to_game")

func _deferred_switch_to_editor():
	get_tree().root.remove_child(game_scene)
	get_tree().root.add_child(editor_scene)
	get_tree().current_scene = editor_scene

func _deferred_switch_to_game():
	save_game(editor_scene.get_tilemap())
	get_tree().root.remove_child(editor_scene)
	game_scene.from_data(load_game())
	get_tree().root.add_child(game_scene)
	get_tree().current_scene = game_scene

func load_game():
	if not FileAccess.file_exists(FILENAME):
		return
	var file = FileAccess.open(FILENAME, FileAccess.READ)
	while file.get_position() < file.get_length():
		var json_string = file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var data = json.get_data()
		return data

func grid_coords_to_pixels(coord: Vector2i):
	return coord * (Constants.GRID_SIZE) + Constants.GRID_SIZE / 2

func set_game_data(objects: Node2D, camera: Camera2D, tile_map: GameTileMap, data: Array, root: Node2D = null):
	var tile_data = []

	for d in data:
		var v = Vector2i(d["tile_x"], d["tile_y"])
		if v in Constants.RESOURCE_FOR_OBJECT.keys():
			if v not in scenes.keys():
				scenes[v] = load(Constants.RESOURCE_FOR_OBJECT[v])
			var obj = scenes[v].instantiate()
			var params = parameters.get(v, {})
			for pk in params.keys():
				obj.set(pk, params[pk])
			obj.position = grid_coords_to_pixels(Vector2i(d["pos_x"], d["pos_y"]))
			objects.add_child(obj)
			if root:
				obj.owner = root
			if v in Constants.PLAYERS:
				camera.reparent(obj)
				camera.position = Vector2.ZERO
		else:
			tile_data.append(d)
		
		set_tilemap_data(tile_map, tile_data)

func set_tilemap_data(tile_map: GameTileMap, data: Array):
	for d in data:
		tile_map.set_cell(0, Vector2i(d["pos_x"], d["pos_y"]), 0, Vector2i(d["tile_x"], d["tile_y"]))

func save_game(tilemap: GameTileMap):
	var file = FileAccess.open(FILENAME, FileAccess.WRITE)
	var data = tilemap.to_data()
	var json_string = JSON.stringify(data)
	file.store_line(json_string)
