extends CanvasLayer

func pause() -> void:
	visible = true
	get_tree().paused = true

@onready var options: Button = $pause_background/MarginContainer/VBoxContainer/Options
func unpause() -> void:
	visible = false
	get_tree().paused = false
	options.text = "Options" # temp



func _ready() -> void:
	unpause()


# check pause condition
func  _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("stop"):
		if get_tree().paused:
			unpause()
		else:
			pause()

# check minimize condition
func _notification(minimized: int) -> void:
	if minimized == NOTIFICATION_APPLICATION_FOCUS_OUT:
		if not get_tree().paused:
			pause()


func _on_return_pressed() -> void:
	unpause()

func _on_options_pressed() -> void:
	options.text = "WIP" # temp



func _on_quit_pressed() -> void:
	get_tree().quit()
