extends MenuPanel

class_name CPUVictoryPopup

@export_category("References")
@export var scoreboard : ScoreboardManager

@export var blueScoreButton : Button
@export var blueScoreText : RichTextLabel
@export var redScoreButton : Button
@export var redScoreText : RichTextLabel

@export var playAgainButton : Button
@export var playAgainText : RichTextLabel

@export var returnButton : Button
@export var returnText : RichTextLabel

func _ready():
	_set_connections()
	
	_set_score()
func _set_connections():
	_popup_setup_button_hover_connections(blueScoreButton, blueScoreText)
	_popup_setup_button_hover_connections(redScoreButton, redScoreText)
	
	_popup_setup_button_hover_connections(playAgainButton, playAgainText)
	playAgainButton.pressed.connect(_play_again)
	
	_popup_setup_button_hover_connections(returnButton, returnText)
	returnButton.pressed.connect(_return)

func _set_score():
	pass

#- - -
func _play_again():
	pass

func _return():
	pass
