extends EndPopup

class_name CPUVictoryPopup

@export_category("References")
@export var scoreboard : ScoreboardManager
@export var starExplosion : OneShotParticle

@export var blueScoreButton : Button
@export var blueScoreText : RichTextLabel
@export var redScoreButton : Button
@export var redScoreText : RichTextLabel

@export var playAgainButton : Button
@export var playAgainText : RichTextLabel

@export var viewMapParent : Control
@export var viewMapButton : Button
@export var viewMapText : RichTextLabel

@export var returnButton : Button
@export var returnText : RichTextLabel

func _ready():
	_set_connections()
func _set_connections():
	_popup_setup_button_hover_connections(blueScoreButton, blueScoreText)
	_popup_setup_button_hover_connections(redScoreButton, redScoreText)
	
	_popup_setup_button_hover_connections(playAgainButton, playAgainText)
	playAgainButton.pressed.connect(_play_again)
	
	_popup_setup_button_hover_connections(viewMapButton, viewMapText)
	viewMapButton.pressed.connect(_toggle_map_view)
	
	_popup_setup_button_hover_connections(returnButton, returnText)
	returnButton.pressed.connect(_return)

func _set_score():
	blueScoreText.text = str(GameManager.playerOneScore)
	redScoreText.text = str(GameManager.playerTwoScore)

func _trigger_stars():
	starExplosion.reparent(PopupMenuManager.currentPopupMenu)
	starExplosion._trigger_sameTiming()
	await get_tree().create_timer(0.1).timeout
	SoundManager._create_sfx(SoundManager.starVictory)

#
func _set_up():
	_set_score()
	_connect_return_button()
