extends Control

@export_category("References")
@export var introPanelParents : Array[Control]
@export var optionButtons : Array[Button]
@export var optionModulate : Array[Array]
@export var optionMenuParent : Array[Control]


func _ready() -> void:
	_intro_panels()
	_set_connections()
func _intro_panels():
	var delay : float = 0
	var delayIncrement : float = 0.07
	for panel in introPanelParents:
		var panelTween : Tween = TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, panel, 700, delay, false)
		delay += delayIncrement
func _set_connections():
	for i in range(0, optionButtons.size()):
		optionButtons[i].pressed.connect(_select_gamemode.bind(i))


#------------
func _select_gamemode(index : int):
	pass
