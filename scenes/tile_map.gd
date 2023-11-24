extends TileMap
class_name GameTileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func from_data(data):
	for d in data:
		set_cell(0, Vector2i(d["pos_x"], d["pos_y"]), 0, Vector2i(d["tile_x"], d["tile_y"]))


func to_data():
	var data = []
	for cell in get_used_cells(0):
		var atlas_coords = get_cell_atlas_coords(0, cell)
		data.append({
			"pos_x": cell.x,
			"pos_y": cell.y,
			"tile_x": atlas_coords.x,
			"tile_y": atlas_coords.y,
		})
	return data
