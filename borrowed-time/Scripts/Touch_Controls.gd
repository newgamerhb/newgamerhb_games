extends CanvasLayer


@onready var buttons: Array[TouchScreenButton] = [$Left, $Right, $Jump]

func _ready() -> void:
	for btn in buttons:
		btn.pressed.connect(func(): btn.modulate.a = 0.5)
		btn.released.connect(func(): btn.modulate.a = 1.0)

@onready var pause_menu: CanvasLayer = $"../Pause_Menu"
@onready var pause: TouchScreenButton = $Pause
func _on_pause_pressed() -> void:
	get_tree().paused = true
	pause_menu.visible = true
