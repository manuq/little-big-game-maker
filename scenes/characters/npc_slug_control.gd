extends Node2D

func is_jumping():
	return false

func get_direction():
	if get_parent().is_on_floor():
		return -1
	return 0
