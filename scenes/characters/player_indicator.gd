class_name PlayerIndicator
extends Node2D

func _ready():
	await get_tree().create_timer(2).timeout
	queue_free()

func _physics_process(delta):
	rotation = - get_parent().rotation
