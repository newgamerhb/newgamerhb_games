extends CharacterBody2D

@onready var sfx_jump: AudioStreamPlayer = $sfx/sfx_jump
@onready var sfx_sword_swing_1: AudioStreamPlayer = $sfx/sfx_sword_swing1
@onready var sfx_sword_swing_2: AudioStreamPlayer = $sfx/sfx_sword_swing2
@onready var sfx_sword_swing_3: AudioStreamPlayer = $sfx/sfx_sword_swing3

@onready var sprite: Node2D = $Sprite
@onready var animation_tree: AnimationTree = $Sprite/AnimatedSprite2D/AnimationTree
@onready var attack_buffer_timer: Timer = $attack_buffer_timer
@onready var hurtbox: Hurtbox = $Sprite/Hurtbox


const FRICTION = 800.0
const MAX_WALK_SPEED = 50.0
const MAX_RUN_SPEED = 150.0
const JUMP_VELOCITY = -300.0


var jump : bool
var attack_buffer : bool = false

func _on_attack_buffer_timer_timeout() -> void:
	attack_buffer = false

func _ready() -> void:
	animation_tree.active = true
	hurtbox.target_group = "enemy_hitbox"
	hurtbox.hit_received.connect(_on_hit_received)

func _on_hit_received(damage: int, _source: Hitbox) -> void:
	print("Player hit for ", damage)
	# reduce player health, trigger hurt animation, etc.


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	jump = Input.is_action_just_pressed("move_up") and is_on_floor() and not attack_buffer
	if jump:
		velocity.y = JUMP_VELOCITY
		sfx_jump.play()
	
	# Get the input direction and handle the movement/deceleration, -1, 0, 1
	var direction : int = int(Input.get_axis("move_left", "move_right"))
	
	if attack_buffer:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	else:
		# flip the sprite
		if direction > 0:
			sprite.scale.x = 1
		elif direction < 0:
			sprite.scale.x = -1
		
		
		if direction:
			if Input.is_action_pressed("run"):
				velocity.x = direction * MAX_RUN_SPEED
			else:
				velocity.x = direction * MAX_WALK_SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
	
	move_and_slide()
	
	
	# ========== Animations ===========
	
	# blend space with velocity.x, walk-run
	var speed: float = absf(velocity.x)
	var speed_blend_value: float
	
	
	if speed < 1.0:
		speed_blend_value = -1.0
	elif speed <= MAX_WALK_SPEED:
		speed_blend_value = lerpf(-1.0, 0.0, speed / MAX_WALK_SPEED)
	else:
		speed_blend_value = lerpf(0.0, 1.0, clamp((speed - MAX_WALK_SPEED) / (MAX_RUN_SPEED - MAX_WALK_SPEED), 0.0, 1.0))
	animation_tree.set("parameters/PlayerStates/move/blend_position", speed_blend_value)
	
	# attack
	if Input.is_action_just_pressed("attack"):
		attack_buffer = true
		attack_buffer_timer.start()

# ========== attackes ==========
func on_attack_1() -> void:
	sfx_sword_swing_1.play()

func on_attack_2() -> void:
	sfx_sword_swing_2.play()

func on_attack_3() -> void:
	sfx_sword_swing_3.play()
