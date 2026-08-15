extends Node

class_name GameplayManager

@export_category("References")
@export var screenBlocker : Control
@export_group("panels")
@export var board : Control
@export var blueScore : Control
@export var redScore : Control
@export var tray : Control
@export var tray2 : Control
@export var viewDeck : Control
@export var optionsMenu : Control

var uiParent : Node

func _ready() -> void:
	_assign_self_to_gamemanager()
	
	uiParent = %UI
	
	_intro_sequence()

func _assign_self_to_gamemanager():
	GameManager.gameplayManager = self

#- - -
func _intro_sequence():
	screenBlocker.visible = true
	await _animate_into_frame()
	screenBlocker.visible = false

func _animate_into_frame():
	var delay : float = 0
	var delayIncrement : float = 0.07
	var lastTween : Tween = null
	
	TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, board, 700, delay)
	delay += delayIncrement
	TweenManager._offset_enter_from(TweenManager.ScreenSide.left, blueScore, 700, delay)
	TweenManager._offset_enter_from(TweenManager.ScreenSide.right, redScore, 1400, delay)
	delay += delayIncrement
	TweenManager._offset_enter_from(TweenManager.ScreenSide.top, viewDeck, 700, delay)
	delay += delayIncrement
	TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, optionsMenu, 700, delay)
	TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, tray2, 700, delay)
	delay += delayIncrement
	lastTween = TweenManager._offset_enter_from(TweenManager.ScreenSide.bottom, tray, 700, delay)
	
	await lastTween.finished
	#await get_tree().create_timer(0.5).timeout
