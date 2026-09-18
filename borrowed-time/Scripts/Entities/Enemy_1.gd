extends CharacterBody2D

@onready var hurtbox: Hurtbox = $Sprite/Hurtbox
@onready var animation_tree: AnimationTree = $Sprite/AnimatedSprite2D/AnimationTree

var health: int = 30

func _ready() -> void:
	animation_tree.active = true
	hurtbox.target_group = "player_hitbox"
	hurtbox.hit_received.connect(_on_hit_received)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

func _on_hit_received(damage: int, _source: Hitbox) -> void:
	health -= damage
	print("Enemy hit for ", damage, ", health: ", health)
	if health <= 0:
		queue_free()
