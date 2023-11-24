extends Node2D

@onready var GRID_SIZE = %TileMap.tile_set.tile_size

const COLUMNS = 36
const ROWS = 27

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _draw():
	var w = ProjectSettings.get_setting("display/window/size/viewport_width")
	var h = ProjectSettings.get_setting("display/window/size/viewport_height")
	var d = GRID_SIZE.x
	var offset = Vector2() # %Camera2D.get_screen_center_position() - Vector2(w/2, h/2)
	for x in range(COLUMNS):
		for y in range(ROWS):
			draw_line(offset + Vector2(0, GRID_SIZE.y * y), offset + Vector2(w, GRID_SIZE.y * y), Color.WHITE, -1, false)
			draw_line(offset + Vector2(GRID_SIZE.x * x, 0), offset + Vector2(GRID_SIZE.x * x, h), Color.WHITE, -1, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
