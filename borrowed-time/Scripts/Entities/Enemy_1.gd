extends CharacterBody2D

@onready var sfx_hit: AudioStreamPlayer2D = $sfx/sfx_hit
@onready var sfx_dead: AudioStreamPlayer2D = $sfx/sfx_dead

@onready var sprite: Node2D = $Sprite
@onready var vision_ray: RayCast2D = $Sprite/Rays/vision_ray
@onready var wall_ray: RayCast2D = $Sprite/Rays/wall_ray
@onready var hurtbox: Hurtbox = $Sprite/Hurtbox
@onready var animation_tree: AnimationTree = $Sprite/AnimatedSprite2D/AnimationTree
@onready var health_bar: ProgressBar = $Health_Bar


var health: int = 50
var isDead: bool = false

var is_knocked_back: bool = false
var knockback_timer: float = 0.0
const KNOCKBACK_DURATION := 0.2

var direction:= -1.0

const FRICTION = 800.0
const SPEED = 50.0

func update_health_bar() -> void:
	health_bar.value = health

func _ready() -> void:
	health_bar.value = health
	animation_tree.active = true
	hurtbox.target_group = "player_hitbox"
	hurtbox.hit_received.connect(_on_hit_received)
	hurtbox.knockback_applied.connect(_on_knockback_applied)

func _on_knockback_applied(vector: Vector2) -> void:
	velocity = vector  # overwrite, not add — ensures knockback is felt immediately
	is_knocked_back = true
	knockback_timer = KNOCKBACK_DURATION

func flip_self() -> void:
	direction *= -1.0
	sprite.scale.x *= -1.0

func _physics_process(delta: float) -> void:
	if not is_on_floor() and not isDead:
		velocity += get_gravity() * delta
	
	if vision_ray.is_colliding():
		var entity = vision_ray.get_collider()
		if entity.is_in_group("player"):
			pass # temp, add chase
	
	if wall_ray.is_colliding():
		flip_self()
	
	if is_knocked_back:
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			is_knocked_back = false
		# skip normal movement input entirely while staggered
	elif not isDead:
		# ...existing movement/jump/attack input handling goes here...
		
		#velocity.x += direction * SPEED * delta
		velocity.x = move_toward(velocity.x, SPEED * direction, SPEED*delta)
		#velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		
	
	
	move_and_slide()

func _on_hit_received(damage: int, _source: Hitbox) -> void:
	health -= damage
	update_health_bar()
	
	sfx_hit.pitch_scale = randf_range(0.9, 1.1)
	sfx_hit.play()
	
	if health <= 0:
		sfx_dead.play()
		health_bar.visible = false
		play_death_anim()

func play_death_anim() -> void:
	isDead = true
	velocity.x = 0.0
	velocity.y = 0.0

func despawn() -> void:
	await sfx_dead.finished
	queue_free()
