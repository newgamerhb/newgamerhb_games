extends VBoxContainer

@export var resolution_option: OptionButton
@export var window_mode_option: OptionButton
@export var vsync_check: CheckBox

enum WindowMode { WINDOWED, BORDERLESS, FULLSCREEN }

func _ready():
	var resolutions = [
		Vector2i(1920, 1080),
		Vector2i(1600, 900),
		Vector2i(1280, 720),
		Vector2i(640, 360),
		Vector2i(320, 180)
	]
	for res in resolutions:
		resolution_option.add_item("%dx%d" % [res.x, res.y])

	window_mode_option.add_item("Windowed", WindowMode.WINDOWED)
	window_mode_option.add_item("Borderless", WindowMode.BORDERLESS)
	window_mode_option.add_item("Fullscreen", WindowMode.FULLSCREEN)

	load_current_settings()

	resolution_option.item_selected.connect(_on_resolution_selected)
	window_mode_option.item_selected.connect(_on_window_mode_selected)
	vsync_check.toggled.connect(_on_vsync_toggled)


func load_current_settings():
	var mode = DisplayServer.window_get_mode()
	var borderless = DisplayServer.window_get_flag(DisplayServer.WINDOW_FLAG_BORDERLESS)

	var current_mode: WindowMode
	if mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		current_mode = WindowMode.FULLSCREEN
	elif borderless:
		current_mode = WindowMode.BORDERLESS
	else:
		current_mode = WindowMode.WINDOWED

	for i in range(window_mode_option.item_count):
		if window_mode_option.get_item_id(i) == current_mode:
			window_mode_option.select(i)
			break

	vsync_check.set_pressed_no_signal(DisplayServer.window_get_vsync_mode() == DisplayServer.VSYNC_ENABLED)

	var window_size = DisplayServer.window_get_size()
	for i in range(resolution_option.item_count):
		var res_text = resolution_option.get_item_text(i)
		var parts = res_text.split("x")
		if parts.size() == 2 and int(parts[0]) == window_size.x and int(parts[1]) == window_size.y:
			resolution_option.select(i)
			break


func _on_resolution_selected(index: int):
	var text = resolution_option.get_item_text(index)
	var parts = text.split("x")
	if parts.size() == 2:
		DisplayServer.window_set_size(Vector2i(int(parts[0]), int(parts[1])))


func _on_window_mode_selected(index: int):
	var selected_id = window_mode_option.get_item_id(index)
	match selected_id:
		WindowMode.WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		WindowMode.BORDERLESS:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		WindowMode.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_vsync_toggled(enabled: bool):
	var mode = DisplayServer.VSYNC_ENABLED if enabled else DisplayServer.VSYNC_DISABLED
	DisplayServer.window_set_vsync_mode(mode)
