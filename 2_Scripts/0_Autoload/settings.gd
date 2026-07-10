extends Node

var fullscreen : bool = false #TODO: change to true in full version


var settingsJSON : SettingsJSON = SettingsJSON.new()

signal togglefullscreen

func _ready() -> void:
	togglefullscreen.connect(_toggle_fullscreen)

func _process(delta: float) -> void:
	_fullscreen_manager()

#---------------------------------------------------------
func _toggle_fullscreen():
	settingsJSON.fullscreen = !settingsJSON.fullscreen

func _fullscreen_manager():
	if settingsJSON.fullscreen != fullscreen:
		fullscreen = settingsJSON.fullscreen
		if fullscreen == false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
