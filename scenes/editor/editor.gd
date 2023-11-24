extends Node2D
class_name Editor

var current_index = 0

func _ready():
	%EditorCanvas.set_current_tile(Constants.ALL[current_index])

func _input(event):

	if event.is_action_released("next-tool"):
		current_index = max(0, current_index - 1)
		%EditorCanvas.set_current_tile(Constants.ALL[current_index])

	elif event.is_action_released("previous-tool"):
		current_index = min(Constants.ALL.size() - 1, current_index + 1)
		%EditorCanvas.set_current_tile(Constants.ALL[current_index])

	elif event.is_action_released("clear"):
		%EditorCanvas.clear()
		
func _on_play_button_pressed():
	GameManager.switch_to_game()

func get_tilemap():
	return %EditorCanvas.get_tilemap()


func _on_tool_button_pressed(coords: Vector2i):
	%EditorCanvas.set_current_tile(coords)
