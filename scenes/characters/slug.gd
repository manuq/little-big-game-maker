class_name Slug
extends CharacterBody2D

@export var SPEED = 10.0
@export var AIR_SPEED = 100.0
@export var JUMP_VELOCITY = -340.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const NOT_ON_FLOOR_COUNT = 2

var not_on_floor_wait = NOT_ON_FLOOR_COUNT

func set_up_from_angle():
		up_direction = Vector2.from_angle(rotation-PI/2)

func get_orientation():
	var direction = $control.get_direction()
	if direction == 0:
		return Vector2.ZERO
	elif direction == 1:
		return up_direction.rotated(PI/2)
	elif direction == -1:
		return up_direction.rotated(-PI/2)
	
func _ready():
	set_up_from_angle()

func floor_ended():
	var direction = $control.get_direction()
	if direction == -1:
		return not $RayCast2DLeft.get_collider() and $RayCast2DRight.get_collider()
	elif direction == 1:
		return $RayCast2DLeft.get_collider() and not $RayCast2DRight.get_collider()
	else:
		return false

func _physics_process(delta):
	var direction = $control.get_direction()
	if not is_on_floor():
		apply_floor_snap()
		if not_on_floor_wait > 0:
			not_on_floor_wait -= 1
		elif is_on_ceiling():
			rotation = -PI
			set_up_from_angle()
		elif is_on_wall():
			var normal = get_wall_normal()
			# print_tree_pretty()
			rotation = normal.angle() # normal.rotated(PI).angle()
			set_up_from_angle()
			# var collision = get_slide_collision(0)
			# for i in get_slide_collision_count():
			# 	var collision = get_slide_collision(i)
			# 	print("Collided with: ", collision.get_collider().name)
		else:
			rotation = 0
			set_up_from_angle()
			velocity.y += gravity * delta
			
			if direction:
				velocity.x = direction * AIR_SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, AIR_SPEED)
			# velocity.x = 10.0 * $control.get_direction()
	elif $control.is_jumping():
		
		velocity = up_direction * -JUMP_VELOCITY
		rotation = 0
		set_up_from_angle()
	else:
		not_on_floor_wait = NOT_ON_FLOOR_COUNT
		var orientation = get_orientation()
		if is_on_wall():
			rotation -= PI/2 * direction
			set_up_from_angle()
		else:
			if floor_ended():
				rotation += PI/2 * direction
				# FIXME arbitrary numbers:
				position += orientation * 9.0 + up_direction * -10.0
				set_up_from_angle()
			else:
				velocity = orientation * SPEED

	if direction != 0:
		$Sprite2D.flip_h = direction == -1
	
	move_and_slide()
