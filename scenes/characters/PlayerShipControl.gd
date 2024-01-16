class_name PlayerShipControl
extends Node2D

func is_moving_forward():
	return Input.is_action_pressed("ui_up")

func get_direction():
	return Input.get_axis("ui_left", "ui_right")
