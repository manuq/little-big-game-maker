class_name PlayerPlatformerControl
extends Node2D

func is_jumping():
	return Input.is_action_just_pressed("ui_accept")

func get_direction():
	return Input.get_axis("ui_left", "ui_right")
