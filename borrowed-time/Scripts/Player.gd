extends CharacterBody2D

@onready var sfx_jump: AudioStreamPlayer = $sfx/sfx_jump

const  FRICTION = 800.0
const SPEED = 150.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()

	# Get the input direction and handle the movement/deceleration, -1, 0, 1
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
