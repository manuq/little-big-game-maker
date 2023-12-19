@tool
extends EditorImportPlugin

func _get_importer_name():
	return "game.importer"

func _get_priority():
	return 1.0

func _get_import_order():
	return IMPORT_ORDER_SCENE

func _get_visible_name():
	return "Import game as scene"

func _get_recognized_extensions():
	return ["save"]

func _get_save_extension():
	return "tscn"

func _get_resource_type():
	return "PackedScene"

func _get_preset_count():
	return 1 #Presets.size()

func _get_preset_name(preset_index):
	return "Default"

func _get_import_options(path, preset_index):
	return []

func _get_option_visibility(path, option_name, options):
		return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
			return FileAccess.get_open_error()

	var json_string = file.get_line()
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
			return ERR_PARSE_ERROR

	var data = json.get_data()

	var scene = PackedScene.new()
	var root = Node2D.new()
	root.name = "Level"
	root.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var background = ColorRect.new()
	background.name = "Background"
	background.size = Vector2i(1427, 802)
	# FIXME set color to: Color(0.195968, 0.830298, 0.969361, 1)
	background.color = Color(0.195968, 0.830298, 0.969361, 1)
	root.add_child(background)
	background.owner = root
	
	# objects
	var objects = Node2D.new()
	objects.name = "Objects"
	root.add_child(objects)
	objects.owner = root

	var tile_map = preload("res://scenes/tile_map.tscn").instantiate()
	tile_map.clear()
	tile_map.name = "Tile Map"
	root.add_child(tile_map)
	tile_map.owner = root

	var camera = preload("res://scenes/camera_2d.tscn").instantiate()
	camera.name = "Camera"
	root.add_child(camera)
	camera.owner = root
	
	var manager = preload('res://scripts/GameManager.gd').new()
	manager.set_game_data(objects, camera, tile_map, data, root)

	var result = scene.pack(root)
	if not result == OK:
			return ERR_PARSE_ERROR
	print("saving!")
	return ResourceSaver.save(scene, "%s.%s" % [save_path, _get_save_extension()])
