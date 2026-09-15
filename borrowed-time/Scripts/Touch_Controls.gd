extends CanvasLayer


@onready var buttons: Array[TouchScreenButton] = [$Left, $Right, $Jump, $Attack]

func _ready() -> void:
	for btn in buttons:
		btn.pressed.connect(func(): btn.modulate.a = 0.5)
		btn.released.connect(func(): btn.modulate.a = 1.0)

@onready var pause_menu: CanvasLayer = $"../Pause_Menu"
@onready var pause: TouchScreenButton = $Pause
func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_menu.visible = true


@onready var run: Button = $Run
func _on_run_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Input.action_press("run")
		run.modulate.a = 0.5
	else:
		Input.action_release("run")
		run.modulate.a = 1.0
