extends CanvasLayer

# ======== Pause Menu Panels ========
@onready var panels := {
	"menu": %Main_Menu,
	"options": %Options,
	"controls": %Controls,
	"video": %Video,
	"audio": %Audio,
}

var panel_history: Array[String] = []
var current_panel: String = "menu"

@onready var current_menu_label: Label = $Pause_Menu_BG/Current_Menu_Label
@onready var back: Button = $Pause_Menu_BG/Back
# ======== Menu ========
@onready var options: Button = $Pause_Menu_BG/MarginContainer/Menu/Options
# ======== Options ========
@onready var controls: Button = $Pause_Menu_BG/MarginContainer/Options/Controls
@onready var video: Button = $Pause_Menu_BG/MarginContainer/Options/Video
@onready var audio: Button = $Pause_Menu_BG/MarginContainer/Options/Audio
# ======== Controls ========
@onready var touch_controls: CheckButton = $Pause_Menu_BG/MarginContainer/Controls/Touch_Controls
# ======== Video ========

# ======== Audio ========


func pause() -> void:
	visible = true
	get_tree().paused = true

func unpause() -> void:
	visible = false
	get_tree().paused = false
	reset_menu_state()

func reset_menu_state() -> void:
	panel_history.clear()
	show_panel("menu", false)

# check minimize condition
func _notification(minimized: int) -> void:
	if minimized == NOTIFICATION_APPLICATION_FOCUS_OUT and not get_tree().paused:
		pause()

# check pause condition
func  _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("stop"):
		if get_tree().paused:
			unpause()
		else:
			pause()

# touch controls toggle
func _on_touch_controls_toggled(toggled_on: bool) -> void:
	var touch_control_tree := get_tree().get_first_node_in_group("HUD")
	if touch_control_tree != null:
		touch_control_tree.visible = toggled_on

func _ready() -> void:
	unpause()
	show_panel("menu", false)

func show_panel(panel_name: String, push_history: bool = true) -> void:
	if push_history and current_panel != panel_name:
		panel_history.append(current_panel)
	
	for key in panels:
		panels[key].visible = (key == panel_name)
	
	current_panel = panel_name
	current_menu_label.text = panel_name.capitalize()

func go_back() -> void:
	if panel_history.size() > 0:
		var previous: String = panel_history.pop_back()
		show_panel(previous, false)
	else:
		unpause()

# ======== process user input ========
func _on_back_pressed() -> void:
	go_back()

func _on_return_pressed() -> void: ##############################
	unpause() 

func _on_options_pressed() -> void:
	show_panel("options")

func _on_controls_pressed() -> void:
	show_panel("controls")

func _on_video_pressed() -> void:
	show_panel("video")

func _on_audio_pressed() -> void:
	show_panel("audio")








func _on_quit_pressed() -> void:
	get_tree().quit()
