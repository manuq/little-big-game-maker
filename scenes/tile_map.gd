extends TileMap
class_name GameTileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
