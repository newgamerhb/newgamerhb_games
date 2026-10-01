extends Area2D
class_name Hurtbox

signal hit_received(damage: int, source: Hitbox)
signal knockback_applied(vector: Vector2)

@export var target_group: String = "hitbox"  # generic; filter further via owner if needed

var overlapping_hitboxes: Array[Hitbox] = []
var already_hit: Array[Hitbox] = []
var flash_tween: Tween

@export var sprite: CanvasItem

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	_reset_flash()

func _reset_flash() -> void:
	if sprite == null:
		return
	var mat := sprite.material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("flash_amount", 0.0)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox and area.is_in_group(target_group):
		overlapping_hitboxes.append(area)

func _on_area_exited(area: Area2D) -> void:
	if area is Hitbox:
		overlapping_hitboxes.erase(area)
		already_hit.erase(area)

@export var body: CharacterBody2D 

func _apply_knockback(hitbox: Hitbox) -> void:
	if body == null:
		return
	var knockback := hitbox.get_knockback_vector(body.global_position)
	knockback_applied.emit(knockback)

func _physics_process(_delta: float) -> void:
	for hitbox: Hitbox in overlapping_hitboxes:
		if hitbox.is_active() and hitbox not in already_hit:
			already_hit.append(hitbox)
			flash_white()
			_apply_knockback(hitbox)
			hit_received.emit(hitbox.damage, hitbox)


func flash_white() -> void:
	var mat := sprite.material as ShaderMaterial
	if mat == null:
		return
	
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	
	mat.set_shader_parameter("flash_amount", 1.0)
	flash_tween = create_tween()
	flash_tween.tween_method(
		func(value): mat.set_shader_parameter("flash_amount", value),
		1.0, 0.0, 0.15
	)
