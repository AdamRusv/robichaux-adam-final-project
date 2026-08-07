extends Control

class_name GameSelectionManager

@export_category("References")
@export var introPanelParents : Array[Control]
@export var optionButtons : Array[Button]
@export var optionButtonBackgrounds : Array[NinePatchRect]
@export var optionTexts : Array[RichTextLabel]
@export_category("Parent Menu Panels")
@export var firstPanel : Control
@export_group("Solo")
@export var soloPanelParent : Control
@export var campaignButton : Button
@export var campaignText : RichTextLabel
@export var customCPUButton : Button
@export var customCPUText : RichTextLabel
@export_group("Custom vs CPU")
@export var customCPUPanelParent : Control
@export var cpuButton : Button
@export var cpuText : RichTextLabel
@export var cpuDifficultyPopupMenuParent : CustomCPUDifficultyAndColor
@export var mapCPUButton : Button
@export var mapCPUText : RichTextLabel
@export var cpuMapPopupMenuParent : CustomCPUMap
@export var deckCPUButton : Button
@export var deckCPUText : RichTextLabel
@export var playCPUButton : Button
@export var playCPUText : RichTextLabel
@export var returnCustomCPUButton : Button
@export var returnCustomCPUArrow : TextureRect
@export_group("Local")
@export var localPanelParent : Control
@export var mapLocalButton : Button
@export var mapLocalText : RichTextLabel
@export var decksLocalButton : Button
@export var decksLocalText : RichTextLabel
@export var playLocalButton : Button
@export var playLocalText : RichTextLabel
@export_group("Online")
@export var onlinePanelParent : Control
@export var steamLinkButton : Button
@export var steamLinkText : RichTextLabel

var isPanelMoving : bool = false
var currentPanel : Control = null

func _ready() -> void:
	_intro_panels()
	_set_connections()
	
	currentPanel = firstPanel
func _intro_panels():
	var delay : float = 0
	var delayIncrement : float = 0.07
	for panel in introPanelParents:
		var panelTween : Tween = TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, panel, 700, delay)
		delay += delayIncrement
func _set_connections():
	for i in range(0, optionButtons.size()):
		optionButtons[i].mouse_entered.connect(_hover_gamemode.bind(i))
		optionButtons[i].mouse_exited.connect(_exit_gamemode.bind(i))
		optionButtons[i].pressed.connect(_select_gamemode.bind(i))
	_solo_set_connections()
	_customCPU_set_connections()
	_local_set_connections()
	_online_set_connections()

#-------Gamemode Button Selection-------
func _hover_gamemode(i : int):
	_set_color_of_text_hovered(optionTexts[i])
func _exit_gamemode(i : int):
	_set_color_of_text_exited(optionTexts[i])

func _select_gamemode(i : int):
	if isPanelMoving == true:
		return
	
	_set_background_color_of_gamemode_buttons(i)
	
	match i:
		0:
			_set_current_panel(soloPanelParent)
		1:
			_set_current_panel(localPanelParent)
		2:
			_set_current_panel(onlinePanelParent)

#-------Solo-------
func _solo_set_connections():
	_setup_button_hover_connections(campaignButton, campaignText)
	
	_setup_button_hover_connections(customCPUButton, customCPUText)
	customCPUButton.pressed.connect(_set_current_panel.bind(customCPUPanelParent))


#-------Local-------
func _local_set_connections():
	_setup_button_hover_connections(mapLocalButton, mapLocalText)
	_setup_button_hover_connections(decksLocalButton, decksLocalText)
	_setup_button_hover_connections(playLocalButton, playLocalText)

#-------Custom CPU-------
var currentCPUGameSettings : CPUGameSettings
func _customCPU_set_connections():
	currentCPUGameSettings = CPUGameSettings.new()
	
	#difficulty / color
	_setup_button_hover_connections(cpuButton, cpuText)
	cpuButton.pressed.connect(_open_popup_menu.bind(cpuDifficultyPopupMenuParent))
	cpuButton.pressed.connect(cpuDifficultyPopupMenuParent._open_cpu_difficulty)
	
	#map
	_setup_button_hover_connections(mapCPUButton, mapCPUText)
	mapCPUButton.pressed.connect(_open_popup_menu.bind(cpuMapPopupMenuParent))
	mapCPUButton.pressed.connect(cpuMapPopupMenuParent._open)
	
	#deck
	_setup_button_hover_connections(deckCPUButton, deckCPUText)
	
	#play
	_setup_button_hover_connections(playCPUButton, playCPUText)
	
	_texture_setup_button_hover_connections(returnCustomCPUButton, returnCustomCPUArrow)
	returnCustomCPUButton.pressed.connect(_set_current_panel.bind(soloPanelParent))

#-------Online-------
func _online_set_connections():
	_setup_button_hover_connections(steamLinkButton, steamLinkText)

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
func _setup_button_hover_connections(newButton : Button, newText : RichTextLabel):
	newButton.mouse_entered.connect(_set_color_of_text_hovered.bind(newText))
	newButton.mouse_exited.connect(_set_color_of_text_exited.bind(newText))
func _set_color_of_text_hovered(newText : RichTextLabel):
	newText.add_theme_color_override("default_color", Color(0, 1, 1))
func _set_color_of_text_exited(newText : RichTextLabel):
	newText.add_theme_color_override("default_color", Color(0, 0, 0))

func _texture_setup_button_hover_connections(newButton : Button, newText : TextureRect):
	newButton.mouse_entered.connect(_texture_set_color_of_texture_hovered.bind(newText))
	newButton.mouse_exited.connect(_texture_set_color_of_texture_exited.bind(newText))
func _texture_set_color_of_texture_hovered(newTexture : TextureRect):
	newTexture.self_modulate = Color(0, 1, 1)
func _texture_set_color_of_texture_exited(newTexture : TextureRect):
	newTexture.self_modulate = Color(0, 0, 0)

func _set_background_color_of_gamemode_buttons(i : int):
	optionButtonBackgrounds[i].self_modulate = Color(1.0, 0.0, 1.0, 1.0)
	
	match i:
		0:
			optionButtonBackgrounds[1].self_modulate = Color(1.0, 1.0, 0.0, 1.0)
			optionButtonBackgrounds[2].self_modulate = Color(1.0, 1.0, 0.0, 1.0)
		1:
			optionButtonBackgrounds[0].self_modulate = Color(1.0, 1.0, 0.0, 1.0)
			optionButtonBackgrounds[2].self_modulate = Color(1.0, 1.0, 0.0, 1.0)
		2:
			optionButtonBackgrounds[0].self_modulate = Color(1.0, 1.0, 0.0, 1.0)
			optionButtonBackgrounds[1].self_modulate = Color(1.0, 1.0, 0.0, 1.0)

func _set_current_panel(newPanel : Control):
	if isPanelMoving == true:
		return
	
	isPanelMoving = true
	await TweenManager._offset_exit_to(TweenManager.ScreenSide.bottom, currentPanel, 700).finished
	currentPanel = newPanel
	currentPanel.visible = true
	await TweenManager._offset_enter_from(TweenManager.ScreenSide.right, currentPanel, 700, 0).finished
	isPanelMoving = false

#- - - - - - - - - -
var temporaryCPUSettings : CPUGameSettings

func _open_popup_menu(menuParent : Control):
	PopupMenuManager._open_popup_menu(menuParent)

func _close_popup_menu():
	temporaryCPUSettings = null
	PopupMenuManager._close_popup_menu()

func _apply_popup_menu():
	temporaryCPUSettings = null
	await PopupMenuManager._animate_close_popup_menu()
