extends MenuPanel

class_name EndPopup

@export var boardManager : BoardMoveManager
@export var uiReturnParent : Control
@export var uiReturnButton : Button
@export var uiReturnText : RichTextLabel

var gameplaySceneRef : String = "res://1_Scenes/0_Screens/gameplay.tscn"
var gameSelectionSceneRef : String = "res://1_Scenes/0_Screens/game selection.tscn"

func _connect_return_button():
	_setup_button_hover_connections(uiReturnButton, uiReturnText)
	uiReturnButton.pressed.connect(_toggle_map_view)

func _play_again():
	GameManager._clear_score()
	get_tree().change_scene_to_file(gameplaySceneRef)

func _return():
	GameManager._clear_score()
	get_tree().change_scene_to_file(gameSelectionSceneRef)

var viewingMap : bool = false
func _toggle_map_view():
	viewingMap = !viewingMap
	
	if viewingMap == true:
		PopupMenuManager.currentPopupMenu.visible = false
		get_tree().current_scene.screenBlocker.visible = false
		boardManager.disableDrag = false
		uiReturnParent.visible = true
	else:
		PopupMenuManager.currentPopupMenu.visible = true
		get_tree().current_scene.screenBlocker.visible = true
		boardManager.disableDrag = true
		uiReturnParent.visible = false
