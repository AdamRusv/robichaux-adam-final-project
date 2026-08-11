extends MenuPanel

class_name CustomCPUDecks

@export_category("References")
@export var gameSelectionManager : GameSelectionManager

@export var playerDeckButton : Button
@export var playerDeckText : RichTextLabel
@export var playerViewButton : Button
@export var playerViewText : RichTextLabel

@export var cpuDeckButton : Button
@export var cpuDeckText : RichTextLabel
@export var cpuViewButton : Button
@export var cpuViewText : RichTextLabel

@export var applyButton : Button
@export var applyText : RichTextLabel
@export var returnButton : Button
@export var returnTexture : TextureRect

var displayStandard : String = "Standard"
var displayHalf : String = "Half"
var displayDoubled : String = "Doubled"
var displayLow : String = "Low"
var displayHigh : String = "High"
var displayCustom : String = "Custom"

var displayView : String = "View"
var displayEdit : String = "Edit"

func _ready():
	_set_connections()
func _set_connections():
	_popup_setup_button_hover_connections(playerDeckButton, playerDeckText)
	playerDeckButton.pressed.connect(_change_player_deck)
	_popup_setup_button_hover_connections(playerViewButton, playerViewText)
	#playerViewButton.pressed.connect(_change_holes)
	
	_popup_setup_button_hover_connections(cpuDeckButton, cpuDeckText)
	cpuDeckButton.pressed.connect(_change_cpu_deck)
	_popup_setup_button_hover_connections(cpuViewButton, cpuViewText)
	#cpuViewButton.pressed.connect(_change_stray_tiles)
	
	_popup_setup_button_hover_connections(applyButton, applyText)
	applyButton.pressed.connect(_apply)
	
	_texture_popup_setup_button_hover_connections(returnButton, returnTexture)
	returnButton.pressed.connect(gameSelectionManager._close_popup_menu)

func _change_player_deck():
	var temporaryCPUSettings : CPUGameSettings = gameSelectionManager.temporaryCPUSettings
	match temporaryCPUSettings.playerDeck:
		CPUGameSettings.Decks.standard:
			playerDeckText.text = displayHalf
			temporaryCPUSettings.playerDeck = CPUGameSettings.Decks.half
		CPUGameSettings.Decks.half:
			playerDeckText.text = displayDoubled
			temporaryCPUSettings.playerDeck = CPUGameSettings.Decks.doubled
		CPUGameSettings.Decks.doubled:
			playerDeckText.text = displayLow
			temporaryCPUSettings.playerDeck = CPUGameSettings.Decks.low
		CPUGameSettings.Decks.low:
			playerDeckText.text = displayHigh
			temporaryCPUSettings.playerDeck = CPUGameSettings.Decks.high
		CPUGameSettings.Decks.high:
			playerDeckText.text = displayCustom
			temporaryCPUSettings.playerDeck = CPUGameSettings.Decks.custom
		CPUGameSettings.Decks.custom:
			playerDeckText.text = displayStandard
			temporaryCPUSettings.playerDeck = CPUGameSettings.Decks.standard
func _change_cpu_deck():
	var temporaryCPUSettings : CPUGameSettings = gameSelectionManager.temporaryCPUSettings
	match temporaryCPUSettings.cpuDeck:
		CPUGameSettings.Decks.standard:
			cpuDeckText.text = displayHalf
			temporaryCPUSettings.cpuDeck = CPUGameSettings.Decks.half
		CPUGameSettings.Decks.half:
			cpuDeckText.text = displayDoubled
			temporaryCPUSettings.cpuDeck = CPUGameSettings.Decks.doubled
		CPUGameSettings.Decks.doubled:
			cpuDeckText.text = displayLow
			temporaryCPUSettings.cpuDeck = CPUGameSettings.Decks.low
		CPUGameSettings.Decks.low:
			cpuDeckText.text = displayHigh
			temporaryCPUSettings.cpuDeck = CPUGameSettings.Decks.high
		CPUGameSettings.Decks.high:
			cpuDeckText.text = displayCustom
			temporaryCPUSettings.cpuDeck = CPUGameSettings.Decks.custom
		CPUGameSettings.Decks.custom:
			cpuDeckText.text = displayStandard
			temporaryCPUSettings.cpuDeck = CPUGameSettings.Decks.standard

#- - - - - - - -
func _open():
	gameSelectionManager.temporaryCPUSettings = CPUGameSettings.new()
	gameSelectionManager.temporaryCPUSettings.playerDeck = gameSelectionManager.currentCPUGameSettings.playerDeck
	gameSelectionManager.temporaryCPUSettings.cpuDeck = gameSelectionManager.currentCPUGameSettings.cpuDeck
	_update()
func _update():
	match gameSelectionManager.currentCPUGameSettings.playerDeck:
		CPUGameSettings.Decks.standard:
			playerDeckText.text = displayStandard
		CPUGameSettings.Decks.half:
			playerDeckText.text = displayHalf
		CPUGameSettings.Decks.doubled:
			playerDeckText.text = displayDoubled
		CPUGameSettings.Decks.low:
			playerDeckText.text = displayLow
		CPUGameSettings.Decks.high:
			playerDeckText.text = displayHigh
		CPUGameSettings.Decks.custom:
			playerDeckText.text = displayCustom
	
	match gameSelectionManager.currentCPUGameSettings.cpuDeck:
		CPUGameSettings.Decks.standard:
			cpuDeckText.text = displayStandard
		CPUGameSettings.Decks.half:
			cpuDeckText.text = displayHalf
		CPUGameSettings.Decks.doubled:
			cpuDeckText.text = displayDoubled
		CPUGameSettings.Decks.low:
			cpuDeckText.text = displayLow
		CPUGameSettings.Decks.high:
			cpuDeckText.text = displayHigh
		CPUGameSettings.Decks.custom:
			cpuDeckText.text = displayCustom

func _apply():
	gameSelectionManager.currentCPUGameSettings.playerDeck = gameSelectionManager.temporaryCPUSettings.playerDeck
	gameSelectionManager.currentCPUGameSettings.cpuDeck = gameSelectionManager.temporaryCPUSettings.cpuDeck
	
	await gameSelectionManager._apply_popup_menu()
	
	var playerText : String = ""
	match gameSelectionManager.currentCPUGameSettings.playerDeck:
		CPUGameSettings.Decks.standard:
			playerText = displayStandard
		CPUGameSettings.Decks.half:
			playerText = displayHalf
		CPUGameSettings.Decks.doubled:
			playerText = displayDoubled
		CPUGameSettings.Decks.low:
			playerText = displayLow
		CPUGameSettings.Decks.high:
			playerText = displayHigh
		CPUGameSettings.Decks.custom:
			playerText = displayCustom
	
	var cpuText : String = ""
	match gameSelectionManager.currentCPUGameSettings.cpuDeck:
		CPUGameSettings.Decks.standard:
			cpuText = displayStandard
		CPUGameSettings.Decks.half:
			cpuText = displayHalf
		CPUGameSettings.Decks.doubled:
			cpuText = displayDoubled
		CPUGameSettings.Decks.low:
			cpuText = displayLow
		CPUGameSettings.Decks.high:
			cpuText = displayHigh
		CPUGameSettings.Decks.custom:
			cpuText = displayCustom
	
	gameSelectionManager.deckCPUText.text = playerText + " / " + cpuText
