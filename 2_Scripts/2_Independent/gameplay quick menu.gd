extends HoverMenuManager

@export var optionsButton : Button
@export var helpButton : Button
@export var quitButton : Button
@export_group("Rules Menu")
@export var rulesParent : MenuPanel
@export var rulesCloseButton : Button
@export var rulesCloseText : RichTextLabel
@export_group("Quit Menu")
@export var quitParent : MenuPanel
@export var quitConfirmButton : Button
@export var quitConfirmText : RichTextLabel
@export var quitReturnButton : Button
@export var quitReturnText : RichTextLabel


func _ready() -> void:
	super._ready()
	_connect_buttons()
func _connect_buttons():
	optionsButton.pressed.connect(_open_options_menu)
	helpButton.pressed.connect(_open_help_menu)
	quitButton.pressed.connect(_open_quit_menu)
	
	rulesParent._popup_setup_button_hover_connections(rulesCloseButton, rulesCloseText)
	rulesCloseButton.pressed.connect(PopupMenuManager._animate_close_popup_menu)
	quitParent._popup_setup_button_hover_connections(quitConfirmButton, quitConfirmText)
	quitConfirmButton.pressed.connect(_quit)
	quitParent._popup_setup_button_hover_connections(quitReturnButton, quitReturnText)
	quitReturnButton.pressed.connect(PopupMenuManager._animate_close_popup_menu)

func _process(delta: float) -> void:
	super._process(delta)
	if Input.is_action_just_pressed("quit"):
		_open_quit_menu()

#- - -
func _open_options_menu():
	PopupMenuManager._open_options_menu()

func _open_help_menu():
	PopupMenuManager._open_popup_menu(rulesParent)

func _open_quit_menu():
	PopupMenuManager._open_popup_menu(quitParent)

#-
var gameSelectionSceneRef : String = "res://1_Scenes/0_Screens/game selection.tscn"
func _quit():
	GameManager._clear_score()
	get_tree().change_scene_to_file(gameSelectionSceneRef)
