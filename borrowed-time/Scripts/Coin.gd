extends Area2D


func _on_body_entered(_play: Node2D) -> void:
	_handle_coin_collected()

func _handle_coin_collected() -> void:
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")
