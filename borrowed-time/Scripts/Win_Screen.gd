extends Control


func _on_return_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Title_Screen.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
