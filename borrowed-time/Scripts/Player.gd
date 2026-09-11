extends CharacterBody2D

@onready var sfx_jump: AudioStreamPlayer = $sfx/sfx_jump
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_tree: AnimationTree = $AnimationTree

const FRICTION = 800.0
const SPEED = 50.0
const JUMP_VELOCITY = -300.0

var jump : bool

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	jump = Input.is_action_just_pressed("move_up") and is_on_floor()
	if jump:
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()
	
	# Get the input direction and handle the movement/deceleration, -1, 0, 1
	var direction : int = int(Input.get_axis("move_left", "move_right"))
	# flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()

func _ready() -> void:
	animation_tree.active = true
