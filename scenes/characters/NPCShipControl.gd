class_name NPCShipControl
extends Node2D

var direction = -1

func is_moving_forward():
	return true

func get_direction():
	if get_parent().rotation < -PI /2 or get_parent().rotation > PI /2:
		direction *= -1
	return direction
