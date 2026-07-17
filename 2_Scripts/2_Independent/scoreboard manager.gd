extends Control

class_name ScoreboardManager

@export_category("References")
@export var playerOneText : RichTextLabel
@export var playerTwoText : RichTextLabel


func _ready() -> void:
	_update_score()

#------------------------------
func _update_score():
	playerOneText.text = str(GameManager.playerOneScore)
	playerTwoText.text = str(GameManager.playerTwoScore)

#- - -
##can be negative or positive
func _change_score(player : TrayManager.Player, changeValue : int):
	if player == TrayManager.Player.one:
		GameManager.playerOneScore += changeValue
	else:
		GameManager.playerTwoScore += changeValue
	
	_update_score()
