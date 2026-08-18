extends MenuPanel

class_name OptionsMenu

@export_category("References")
@export var fullscreenButton : Button
@export var fullscreenText : RichTextLabel
@export var masterButton : Button
@export var masterText : RichTextLabel
@export var musicButton : Button
@export var musicText : RichTextLabel
@export var sfxButton : Button
@export var sfxText : RichTextLabel

@export var returnButton : Button
@export var returnTexture : TextureRect

@export var creditsOpenButton : Button
@export var creditsOpenText : RichTextLabel
@export_group("Credits Popup")
@export var creditsParent : Control
@export var creditsCloseButton : Button
@export var creditsCloseText : RichTextLabel

func _ready():
	_set_connections()
func _set_connections():
	_popup_setup_button_hover_connections(fullscreenButton, fullscreenText)
	fullscreenButton.pressed.connect(_change_fullscreen)
	_popup_setup_button_hover_connections(masterButton, masterText)
	masterButton.pressed.connect(_change_master)
	_popup_setup_button_hover_connections(musicButton, musicText)
	musicButton.pressed.connect(_change_music)
	_popup_setup_button_hover_connections(sfxButton, sfxText)
	sfxButton.pressed.connect(_change_sfx)
	
	_popup_setup_button_hover_connections(creditsOpenButton, creditsOpenText)
	creditsOpenButton.pressed.connect(PopupMenuManager._secondary_open_popup_menu.bind(creditsParent))
	_popup_setup_button_hover_connections(creditsCloseButton, creditsCloseText)
	creditsCloseButton.pressed.connect(PopupMenuManager._secondary_close_popup_menu)
	
	_texture_popup_setup_button_hover_connections(returnButton, returnTexture)
	returnButton.pressed.connect(PopupMenuManager._animate_close_popup_menu)

func _process(delta: float) -> void: #for keybinds
	_update_visuals()

#
func _update_visuals():
	match Settings.settingsJSON.fullscreen:
		true:
			fullscreenText.text = "On"
		false:
			fullscreenText.text = "Off"
	
	match Settings.settingsJSON.masterVolume:
		0:
			masterText.text = "0/5"
		1:
			masterText.text = "1/5"
		2:
			masterText.text = "2/5"
		3:
			masterText.text = "3/5"
		4:
			masterText.text = "4/5"
		5:
			masterText.text = "5/5"
	
	match Settings.settingsJSON.musicVolume:
		0:
			musicText.text = "0/5"
		1:
			musicText.text = "1/5"
		2:
			musicText.text = "2/5"
		3:
			musicText.text = "3/5"
		4:
			musicText.text = "4/5"
		5:
			musicText.text = "5/5"
	
	match Settings.settingsJSON.sfxVolume:
		0:
			sfxText.text = "0/5"
		1:
			sfxText.text = "1/5"
		2:
			sfxText.text = "2/5"
		3:
			sfxText.text = "3/5"
		4:
			sfxText.text = "4/5"
		5:
			sfxText.text = "5/5"
#-
func _change_fullscreen():
	Settings._toggle_fullscreen()
	_update_visuals()

func _change_master():
	Settings._increase_master()
	_update_visuals()

func _change_music():
	Settings._increase_music()
	_update_visuals()

func _change_sfx():
	Settings._increase_sfx()
	_update_visuals()
