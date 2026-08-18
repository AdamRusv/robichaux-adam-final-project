extends Node

var settingsJSON : SettingsJSON = SettingsJSON.new()

signal togglefullscreen

func _ready() -> void:
	togglefullscreen.connect(_toggle_fullscreen)

func _increase_master():
	if settingsJSON.masterVolume == 5:
		settingsJSON.masterVolume = 0
	else:
		settingsJSON.masterVolume += 1

func _increase_music():
	if settingsJSON.musicVolume == 5:
		settingsJSON.musicVolume = 0
	else:
		settingsJSON.musicVolume += 1

func _increase_sfx():
	if settingsJSON.sfxVolume == 5:
		settingsJSON.sfxVolume = 0
	else:
		settingsJSON.sfxVolume += 1

#---------------------------------------------------------
func _toggle_fullscreen():
	settingsJSON.fullscreen = !settingsJSON.fullscreen
	if settingsJSON.fullscreen == false:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
