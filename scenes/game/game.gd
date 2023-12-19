extends Node2D
class_name Game

var scenes = {}

func _ready():
	Engine.time_scale = 1 # 0.5

func _on_button_pressed():
	GameManager.switch_to_editor()

func grid_coords_to_pixels(coord: Vector2i):
	return coord * (Constants.GRID_SIZE) + Constants.GRID_SIZE / 2

func clear():
	%Camera2D.reparent(self)

	for n in %objects.get_children():
		%objects.remove_child(n)
		n.queue_free()

	%TileMap.clear()

func from_data(data):
	clear()
	GameManager.set_game_data(%objects, %Camera2D, %TileMap, data)
