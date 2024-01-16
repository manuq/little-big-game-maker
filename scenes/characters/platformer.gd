class_name Platformer
extends CharacterBody2D


@export var SPEED = 130.0
@export var JUMP_VELOCITY = -340.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if $control.is_jumping() and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = $control.get_direction()
	if direction != 0:
		$Sprite2D.flip_h = direction == -1
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
