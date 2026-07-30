extends Control

@export_category("References")
@export var leftPanelParent : Control


func _ready() -> void:
	_intro_left_panel()
func _intro_left_panel():
	TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, leftPanelParent, 700, 0, false)
