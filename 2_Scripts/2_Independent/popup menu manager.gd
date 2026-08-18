extends Window

class_name PopupMenuWindow

@export_category("References")
@export var darkBackground : CanvasLayer

var menu : Control

func _set_references(newMenu : Control):
	menu = newMenu
	menu.reparent(self)

##menus have main as child 0 and return button as child 1
func _open_menu():
	menu.visible = true
	var delay : float = 0.2
	SoundManager._create_sfx(SoundManager.menuOpen)
	TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, menu.get_children()[0], 600, delay, Tween.TRANS_QUINT, true)
	TweenManager._offset_enter_from(TweenManager.ScreenSide.top, menu.get_children()[1], 600, delay, Tween.TRANS_QUINT, true)

func _close_menu() -> Tween:
	_delay_dark_background_removal()
	SoundManager._create_sfx(SoundManager.menuClose)
	TweenManager._offset_exit_to(TweenManager.ScreenSide.top, menu.get_children()[1], 600, 0, Tween.TRANS_QUINT, true)
	return TweenManager._offset_exit_to(TweenManager.ScreenSide.bottom, menu.get_children()[0], 600, 0, Tween.TRANS_QUINT, true)

func _delay_dark_background_removal():
	await get_tree().create_timer(0.55).timeout
	darkBackground.visible = false
