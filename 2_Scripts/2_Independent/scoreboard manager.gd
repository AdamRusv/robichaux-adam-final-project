extends Control

class_name ScoreboardManager

@export_category("References")
@export var gameplayManager : GameplayManager
@export var boardModeManager : BoardMoveManager
@export var playerOneText : RichTextLabel
@export var playerTwoText : RichTextLabel
@export var playerOneScoreParent : Control
@export var playerTwoScoreParent : Control
@export_group("End Screens")
@export var cpuVictory : CPUVictoryPopup
@export var cpuDefeat : CPUDefeatPopup
@export var tie : TiePopup
@export var blueWins : ColorWinsPopup
@export var redWins : ColorWinsPopup


func _ready() -> void:
	_update_score()

#------------------------------
func _update_score():
	_manage_bounce(int(playerOneText.text), GameManager.playerOneScore, playerOneScoreParent)
	_manage_bounce(int(playerTwoText.text), GameManager.playerTwoScore, playerTwoScoreParent)
	playerOneText.text = str(GameManager.playerOneScore)
	playerTwoText.text = str(GameManager.playerTwoScore)

func _manage_bounce(previousValue : int, newValue : int, parentControl : Control):
	if previousValue < newValue:
		TweenManager._up_bounce(parentControl)
	elif previousValue > newValue:
		TweenManager._down_bounce(parentControl)

#- - -
##can be negative or positive
func _change_score(player : TrayManager.Player, changeValue : int):
	if player == TrayManager.Player.one:
		GameManager.playerOneScore += changeValue
	else:
		GameManager.playerTwoScore += changeValue
	
	_update_score()

#-----------------------------------
func _end_game():
	boardModeManager.disableDrag = true
	if GameManager.currentCpu != null:
		if GameManager.cpuColor == GameManager.TeamColor.blue:
			if GameManager.playerTwoScore > GameManager.playerOneScore:
				_cpu_victory_popup()
			elif GameManager.playerTwoScore < GameManager.playerOneScore:
				_cpu_defeat_popup()
			else:
				_tie_popup()
		elif GameManager.cpuColor == GameManager.TeamColor.red:
			if  GameManager.playerOneScore > GameManager.playerTwoScore:
				_cpu_victory_popup()
			elif GameManager.playerOneScore < GameManager.playerTwoScore:
				_cpu_defeat_popup()
			else:
				_tie_popup()
	else:
		if GameManager.playerOneScore > GameManager.playerTwoScore:
			_blue_wins_popup()
		elif GameManager.playerTwoScore > GameManager.playerOneScore:
			_red_wins_popup()
		else:
			_tie_popup()
	

func _cpu_victory_popup():
	await get_tree().create_timer(1).timeout
	PopupMenuManager._preload_window()
	cpuVictory._trigger_stars()
	gameplayManager.screenBlocker.visible = true
	
	await get_tree().create_timer(2.5).timeout
	cpuVictory._set_up()
	PopupMenuManager._open_popup_menu(cpuVictory)

func _cpu_defeat_popup():
	await get_tree().create_timer(1).timeout
	PopupMenuManager._preload_window()
	cpuDefeat._trigger_x_rain()
	gameplayManager.screenBlocker.visible = true
	
	await get_tree().create_timer(2.5).timeout
	cpuDefeat._set_up()
	PopupMenuManager._open_popup_menu(cpuDefeat)

func _blue_wins_popup():
	await get_tree().create_timer(1).timeout
	PopupMenuManager._preload_window()
	blueWins._trigger_particle()
	gameplayManager.screenBlocker.visible = true
	
	await get_tree().create_timer(2.5).timeout
	blueWins._set_up()
	PopupMenuManager._open_popup_menu(blueWins)

func _red_wins_popup():
	await get_tree().create_timer(1).timeout
	PopupMenuManager._preload_window()
	redWins._trigger_particle()
	gameplayManager.screenBlocker.visible = true
	
	await get_tree().create_timer(2.5).timeout
	redWins._set_up()
	PopupMenuManager._open_popup_menu(redWins)

func _tie_popup():
	gameplayManager.screenBlocker.visible = true
	
	await get_tree().create_timer(1).timeout
	tie._set_up()
	PopupMenuManager._open_popup_menu(tie)
