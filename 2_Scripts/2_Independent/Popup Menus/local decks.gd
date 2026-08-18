extends MenuPanel

class_name LocalDecks

@export_category("References")
@export var gameSelectionManager : GameSelectionManager
@export var viewDeckPopupParent : ViewDeckPopup

@export var blueDeckButton : Button
@export var blueDeckText : RichTextLabel
@export var blueViewButton : Button
@export var blueViewText : RichTextLabel

@export var redDeckButton : Button
@export var redDeckText : RichTextLabel
@export var redViewButton : Button
@export var redViewText : RichTextLabel

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
	_popup_setup_button_hover_connections(blueDeckButton, blueDeckText)
	blueDeckButton.pressed.connect(_change_blue_deck)
	blueDeckButton.pressed.connect(_play_click_sound)
	_popup_setup_button_hover_connections(blueViewButton, blueViewText)
	
	_popup_setup_button_hover_connections(redDeckButton, redDeckText)
	redDeckButton.pressed.connect(_change_red_deck)
	redDeckButton.pressed.connect(_play_click_sound)
	_popup_setup_button_hover_connections(redViewButton, redViewText)
	
	_popup_setup_button_hover_connections(applyButton, applyText)
	applyButton.pressed.connect(_apply)
	
	_texture_popup_setup_button_hover_connections(returnButton, returnTexture)
	returnButton.pressed.connect(gameSelectionManager._close_popup_menu)

func _view_player_deck():
	var deckName : String = _get_deck_name(gameSelectionManager.temporaryLocalSettings.blueDeck)
	var newDeck : Deck = gameSelectionManager.temporaryLocalSettings._get_deck(gameSelectionManager.temporaryLocalSettings.blueDeck)
	viewDeckPopupParent._open_menu(newDeck)
	viewDeckPopupParent._set_up(deckName, newDeck)
func _view_cpu_deck():
	var deckName : String = _get_deck_name(gameSelectionManager.temporaryLocalSettings.redDeck)
	var newDeck : Deck = gameSelectionManager.temporaryLocalSettings._get_deck(gameSelectionManager.temporaryLocalSettings.redDeck)
	viewDeckPopupParent._open_menu(newDeck)
	viewDeckPopupParent._set_up(deckName, newDeck)
func _get_deck_name(newDeck : LocalGameSettings.Decks) -> String:
	var deckName : String = "?"
	match newDeck:
		CPUGameSettings.Decks.standard:
			deckName = displayStandard
		CPUGameSettings.Decks.half:
			deckName = displayHalf
		CPUGameSettings.Decks.doubled:
			deckName = displayDoubled
		CPUGameSettings.Decks.low:
			deckName = displayLow
		CPUGameSettings.Decks.high:
			deckName = displayHigh
		CPUGameSettings.Decks.custom:
			deckName = displayCustom
	return deckName

func _change_blue_deck():
	var temporaryLocalSettings : LocalGameSettings = gameSelectionManager.temporaryLocalSettings
	match temporaryLocalSettings.blueDeck:
		LocalGameSettings.Decks.standard:
			blueDeckText.text = displayHalf
			temporaryLocalSettings.blueDeck = LocalGameSettings.Decks.half
		LocalGameSettings.Decks.half:
			blueDeckText.text = displayDoubled
			temporaryLocalSettings.blueDeck = LocalGameSettings.Decks.doubled
		LocalGameSettings.Decks.doubled:
			blueDeckText.text = displayLow
			temporaryLocalSettings.blueDeck = LocalGameSettings.Decks.low
		LocalGameSettings.Decks.low:
			blueDeckText.text = displayHigh
			temporaryLocalSettings.blueDeck = LocalGameSettings.Decks.high
		LocalGameSettings.Decks.high:
			blueDeckText.text = displayCustom
			temporaryLocalSettings.blueDeck = LocalGameSettings.Decks.custom
		LocalGameSettings.Decks.custom:
			blueDeckText.text = displayStandard
			temporaryLocalSettings.blueDeck = LocalGameSettings.Decks.standard
	if temporaryLocalSettings.blueDeck == LocalGameSettings.Decks.custom:
		blueViewText.text = "Edit"
	else:
		blueViewText.text = "View"
func _change_red_deck():
	var temporaryLocalSettings : LocalGameSettings = gameSelectionManager.temporaryLocalSettings
	match temporaryLocalSettings.redDeck:
		LocalGameSettings.Decks.standard:
			redDeckText.text = displayHalf
			temporaryLocalSettings.redDeck = LocalGameSettings.Decks.half
		LocalGameSettings.Decks.half:
			redDeckText.text = displayDoubled
			temporaryLocalSettings.redDeck = LocalGameSettings.Decks.doubled
		LocalGameSettings.Decks.doubled:
			redDeckText.text = displayLow
			temporaryLocalSettings.redDeck = LocalGameSettings.Decks.low
		LocalGameSettings.Decks.low:
			redDeckText.text = displayHigh
			temporaryLocalSettings.redDeck = LocalGameSettings.Decks.high
		LocalGameSettings.Decks.high:
			redDeckText.text = displayCustom
			temporaryLocalSettings.redDeck = LocalGameSettings.Decks.custom
		LocalGameSettings.Decks.custom:
			redDeckText.text = displayStandard
			temporaryLocalSettings.redDeck = LocalGameSettings.Decks.standard
	if temporaryLocalSettings.redDeck == LocalGameSettings.Decks.custom:
		redViewText.text = "Edit"
	else:
		redViewText.text = "View"

#- - - - - - - -
var beenOpened : bool = false
func _open():
	gameSelectionManager.temporaryLocalSettings = LocalGameSettings.new()
	gameSelectionManager.temporaryLocalSettings.blueDeck = gameSelectionManager.currentLocalGameSettings.blueDeck
	gameSelectionManager.temporaryLocalSettings.redDeck = gameSelectionManager.currentLocalGameSettings.redDeck
	
	if beenOpened == false:
		beenOpened = true
		blueViewButton.pressed.connect(_view_player_deck)
		redViewButton.pressed.connect(_view_cpu_deck)
	
	_update()
func _update():
	match gameSelectionManager.currentLocalGameSettings.blueDeck:
		LocalGameSettings.Decks.standard:
			blueDeckText.text = displayStandard
		LocalGameSettings.Decks.half:
			blueDeckText.text = displayHalf
		LocalGameSettings.Decks.doubled:
			blueDeckText.text = displayDoubled
		LocalGameSettings.Decks.low:
			blueDeckText.text = displayLow
		LocalGameSettings.Decks.high:
			blueDeckText.text = displayHigh
		LocalGameSettings.Decks.custom:
			blueDeckText.text = displayCustom
	
	match gameSelectionManager.currentLocalGameSettings.redDeck:
		LocalGameSettings.Decks.standard:
			redDeckText.text = displayStandard
		LocalGameSettings.Decks.half:
			redDeckText.text = displayHalf
		LocalGameSettings.Decks.doubled:
			redDeckText.text = displayDoubled
		LocalGameSettings.Decks.low:
			redDeckText.text = displayLow
		LocalGameSettings.Decks.high:
			redDeckText.text = displayHigh
		LocalGameSettings.Decks.custom:
			redDeckText.text = displayCustom
	
	if gameSelectionManager.temporaryLocalSettings.blueDeck == LocalGameSettings.Decks.custom:
		blueViewText.text = "Edit"
	else:
		blueViewText.text = "View"
	
	if gameSelectionManager.temporaryLocalSettings.redDeck == LocalGameSettings.Decks.custom:
		redViewText.text = "Edit"
	else:
		redViewText.text = "View"

func _apply():
	gameSelectionManager.currentLocalGameSettings.blueDeck = gameSelectionManager.temporaryLocalSettings.blueDeck
	gameSelectionManager.currentLocalGameSettings.redDeck = gameSelectionManager.temporaryLocalSettings.redDeck
	
	await gameSelectionManager._apply_popup_menu()
	
	var blueText : String = ""
	match gameSelectionManager.currentLocalGameSettings.blueDeck:
		LocalGameSettings.Decks.standard:
			blueText = displayStandard
		LocalGameSettings.Decks.half:
			blueText = displayHalf
		LocalGameSettings.Decks.doubled:
			blueText = displayDoubled
		LocalGameSettings.Decks.low:
			blueText = displayLow
		LocalGameSettings.Decks.high:
			blueText = displayHigh
		LocalGameSettings.Decks.custom:
			blueText = displayCustom
	
	var redText : String = ""
	match gameSelectionManager.currentLocalGameSettings.redDeck:
		LocalGameSettings.Decks.standard:
			redText = displayStandard
		LocalGameSettings.Decks.half:
			redText = displayHalf
		LocalGameSettings.Decks.doubled:
			redText = displayDoubled
		LocalGameSettings.Decks.low:
			redText = displayLow
		LocalGameSettings.Decks.high:
			redText = displayHigh
		LocalGameSettings.Decks.custom:
			redText = displayCustom
	
	gameSelectionManager.decksLocalText.text = blueText + " / " + redText
