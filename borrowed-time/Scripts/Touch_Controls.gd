extends CanvasLayer

@onready var buttons: Array[TouchScreenButton] = [$Left, $Right, $Jump]

func _ready() -> void:
	for btn in buttons:
		btn.pressed.connect(func(): btn.modulate.a = 0.5)
		btn.released.connect(func(): btn.modulate.a = 1.0)
