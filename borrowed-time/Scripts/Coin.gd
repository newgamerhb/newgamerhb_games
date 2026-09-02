extends Area2D

func _on_body_entered(_body : Node2D) -> void:
	_handle_coin_collected.call_deferred()

func  _handle_coin_collected() -> void:
	# Assumes the body is player
	# 1. Remove the coin
	queue_free()
	# 2. Change to win screen
	get_tree().change_scene_to_file("res://Scenes/Win_Screen.tscn")
	
