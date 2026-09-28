extends CharacterBody2D

@onready var sfx_hit: AudioStreamPlayer2D = $sfx/sfx_hit
@onready var sfx_dead: AudioStreamPlayer2D = $sfx/sfx_dead

@onready var hurtbox: Hurtbox = $Sprite/Hurtbox
@onready var animation_tree: AnimationTree = $Sprite/AnimatedSprite2D/AnimationTree
@onready var health_bar: ProgressBar = $Health_Bar


var health: int = 50
var isDead: bool = false

func update_health_bar() -> void:
	health_bar.value = health

func _ready() -> void:
	health_bar.value = health
	animation_tree.active = true
	hurtbox.target_group = "player_hitbox"
	hurtbox.hit_received.connect(_on_hit_received)

func _physics_process(delta: float) -> void:
	if not is_on_floor() and not isDead:
		velocity += get_gravity() * delta
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

func despawn() -> void:
	await sfx_dead.finished
	queue_free()
