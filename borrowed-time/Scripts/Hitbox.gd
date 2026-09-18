extends Area2D
class_name Hitbox

@export var damage: int = 10
@export var knockback_force: float = 200.0

@onready var collision_shape: CollisionShape2D = $hit

func _ready() -> void:
	# starts disabled; enabled/disabled via AnimationPlayer keyframes on attack frames
	collision_shape.disabled = true

func is_active() -> bool:
	return not collision_shape.disabled
