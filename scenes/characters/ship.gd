extends CharacterBody2D


@export var ROTATION_SPEED = 6.0
@export var BASE_SPEED = 0.0
@export var SPEED = 150.0
@export var DECELERATION = 10.0


func _physics_process(delta):
	var direction = $control.get_direction()
	if direction:
		rotation_degrees += direction * ROTATION_SPEED * delta * 70

	var speed = BASE_SPEED
	if $control.is_moving_forward():
		speed += SPEED
	else:
		speed = move_toward(velocity.length(), BASE_SPEED, DECELERATION)
	velocity = Vector2.RIGHT.rotated(rotation) * speed

	move_and_slide()
