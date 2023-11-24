extends CharacterBody2D


@export var ROTATION_SPEED = 6.0
@export var BASE_SPEED = 0.0
@export var SPEED = 100.0
@export var DECELERATION = 10.0


func _ready():
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)

func _physics_process(delta):
	

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"):
		pass

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		rotation_degrees += direction * ROTATION_SPEED

	var speed = BASE_SPEED
	if Input.is_action_pressed("ui_up"):
		speed += SPEED
	else:
		speed = move_toward(velocity.length(), BASE_SPEED, DECELERATION)
	velocity = Vector2.UP.rotated(rotation) * speed

	move_and_slide()
