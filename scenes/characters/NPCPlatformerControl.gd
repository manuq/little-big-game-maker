extends Node2D
#  class_name NPCPlatformerControl

@export var flip_on_edges = false

var direction = -1	

func is_jumping():
	return false

func get_direction():
	# flip direction on walls:
	if get_parent().is_on_floor() and get_parent().is_on_wall():
		direction *= -1

	# flip direction on edges:
	elif flip_on_edges:
		if direction == -1 and not $RayCast2DLeft.get_collider():
			direction = 1
		elif direction == 1 and not $RayCast2DRight.get_collider():
			direction = -1
	
	return direction
