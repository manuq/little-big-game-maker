extends Node

const FILENAME = "user://game-01.save"

var editor_scene: Editor = null
var game_scene: Game = preload("res://scenes/game/game.tscn").instantiate()

func quit():
	save_game(editor_scene.get_tilemap())
	get_tree().quit()

func on_window_quit(event):
	if event == DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
		quit()

func _ready():
	var root = get_tree().root
	editor_scene = root.get_child(root.get_child_count() - 1)
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


func save_game(tilemap: GameTileMap):
	var file = FileAccess.open(FILENAME, FileAccess.WRITE)
	var data = tilemap.to_data()
	var json_string = JSON.stringify(data)
	file.store_line(json_string)
