extends Area2D

@export var enemy_1: PackedScene = preload("res://Scenes/Entities/enemy_1.tscn")
@onready var spawn_point: Marker2D = $Marker2D

var current_enemy: Node = null

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		call_deferred("spawn_enemy")

func spawn_enemy() -> void:
	# don't spawn a duplicate if one's already alive
	if is_instance_valid(current_enemy):
		return

	var enemy := enemy_1.instantiate()
	enemy.global_position = spawn_point.global_position
	get_tree().current_scene.get_node("Entities").add_child(enemy)
	current_enemy = enemy
