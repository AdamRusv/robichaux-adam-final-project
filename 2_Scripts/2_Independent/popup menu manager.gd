extends Window

class_name PopupMenuWindow

@export_category("References")
@export var darkBackground : CanvasLayer

var menu : Control

func _ready() -> void:
	_open_menu()
	menu.reparent(self)
func _set_references(newMenu : Control):
	menu = newMenu

##menus have main as child 0 and return button as child 1
func _open_menu():
	menu.visible = true
	var delay : float = 0.2
	TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, menu.get_children()[0], 600, delay, Tween.TRANS_QUINT)
	TweenManager._offset_enter_from(TweenManager.ScreenSide.top, menu.get_children()[1], 600, delay, Tween.TRANS_QUINT)
