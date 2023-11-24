extends Node2D
class_name Game

var scenes = {
	Constants.COIN: preload("res://scenes/characters/coin.tscn"),
	Constants.PLAYER_PLATFORMER: preload("res://scenes/characters/player-platformer.tscn"),
	Constants.NPC_PLATFORMER: preload("res://scenes/characters/npc_platformer.tscn"),
	Constants.PLAYER_SHIP: preload("res://scenes/characters/player_ship.tscn"),
	Constants.NPC_SHIP: preload("res://scenes/characters/npc_ship.tscn"),
	Constants.PLAYER_SLUG: preload("res://scenes/characters/player_slug.tscn"),
	Constants.NPC_SLUG: preload("res://scenes/characters/npc_slug.tscn"),
}

var parameters = {
	Constants.NPC_PLATFORMER: { "SPEED": 50.0 },
	Constants.PLAYER_SLUG: { "SPEED": 50.0 },
	Constants.NPC_SHIP: { "SPEED": 100.0, "ROTATION_SPEED": 3.0 },
	# ROTATION_SPEED
}

func _ready():
	Engine.time_scale = 1 # 0.5

func _on_button_pressed():
	GameManager.switch_to_editor()

func grid_coords_to_pixels(coord: Vector2i):
	return coord * (Constants.GRID_SIZE) + Constants.GRID_SIZE / 2

func from_data(data):
	var tile_data = []
	%Camera2D.reparent(self)

	for n in %objects.get_children():
		%objects.remove_child(n)
		n.queue_free()

	for d in data:
		var v = Vector2i(d["tile_x"], d["tile_y"])
		if v in scenes.keys():
			var obj = scenes[v].instantiate()
			var params = parameters.get(v, {})
			for pk in params.keys():
				obj.set(pk, params[pk])
			obj.position = grid_coords_to_pixels(Vector2i(d["pos_x"], d["pos_y"]))
			%objects.add_child(obj)
			if v in Constants.PLAYERS:
				%Camera2D.reparent(obj)
				%Camera2D.position = Vector2.ZERO
		else:
			tile_data.append(d)

	%TileMap.clear()
	%TileMap.from_data(tile_data)
