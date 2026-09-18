extends Area2D
class_name Hurtbox

signal hit_received(damage: int, source: Hitbox)

@export var target_group: String = "hitbox"  # generic; filter further via owner if needed

var overlapping_hitboxes: Array[Hitbox] = []
var already_hit: Array[Hitbox] = []

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and area.is_in_group(target_group):
		overlapping_hitboxes.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Hitbox:
		overlapping_hitboxes.erase(area)
		already_hit.erase(area)

func _physics_process(_delta: float) -> void:
	for hitbox: Hitbox in overlapping_hitboxes:
		if hitbox.is_active() and hitbox not in already_hit:
			already_hit.append(hitbox)
			hit_received.emit(hitbox.damage, hitbox)
