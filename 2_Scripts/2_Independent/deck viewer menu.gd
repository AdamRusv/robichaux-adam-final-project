@tool
extends HoverMenuManager

@export_category("References")
@export var trayManager : TrayManager
@export var blueDeckParent : Control
@export var redDeckParent : Control
@export var blueScrollContainer : ScrollContainer
@export var redScrollContainer : ScrollContainer
@export var blueDeckGrid : GridContainer
@export var redDeckGrid : GridContainer
@export var swapToBlueParent : Control
@export var swapToRedParent : Control
@export var swapToBlueButton : Button
@export var swapToRedButton : Button

var playerOneCards : Array[ViewDeckCard]
var playerTwoCards : Array[ViewDeckCard]

var cardRef : PackedScene = preload("res://1_Scenes/1_Objects/view deck card.tscn")

func _validate_property(property: Dictionary) -> void:
	if property.name == "textButtons":
		property.usage = PROPERTY_USAGE_NO_EDITOR
	if property.name == "texts":
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _ready() -> void:
	super._ready()
	_create_decks()
func _set_connections():
	swapToBlueButton.pressed.connect(_swap_to_blue)
	swapToRedButton.pressed.connect(_swap_to_red)
	
	for i in range(0, trayManager.trayTiles.size()):
		trayManager.trayTiles[i].releasedTile.connect(_update_decks)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	super._process(delta)

#-------------------------------------
func _create_decks():
	await get_tree().process_frame #wait for decks to be created
	_create_deck(blueDeckGrid, playerOneCards, trayManager.playerOneCurrentDeck)
	_create_deck(redDeckGrid, playerTwoCards, trayManager.playerTwoCurrentDeck)
	_swap_to_blue()
func _create_deck(deckGrid : GridContainer, playerCards : Array[ViewDeckCard], deckToCreate : Array[int]):
	await get_tree().process_frame #wait for card to be drawn
	var duplicates : int = 0
	for i in range(0, deckToCreate.size()):
		if deckToCreate.size() > 1:
			if deckToCreate[i] == deckToCreate[i - 1]:
				duplicates += 1
			else:
				duplicates = 0
		var newPlayerCard : ViewDeckCard = cardRef.instantiate()
		newPlayerCard.textRef.text = str(deckToCreate[i])
		playerCards.append(newPlayerCard)
		deckGrid.add_child(newPlayerCard)
		
		newPlayerCard.buttonRef.mouse_entered.connect(_hover_text.bind(newPlayerCard.textRef))
		newPlayerCard.buttonRef.mouse_exited.connect(_exit_text.bind(newPlayerCard.textRef))

func _update_decks():
	_clear_decks()
	_create_deck(blueDeckGrid, playerOneCards, trayManager.playerOneCurrentDeck)
	_create_deck(redDeckGrid, playerTwoCards, trayManager.playerTwoCurrentDeck)

func _clear_decks():
	for child in blueDeckGrid.get_children():
		child.queue_free()
	for child in redDeckGrid.get_children():
		child.queue_free()
	
	playerOneCards.clear()
	playerTwoCards.clear()

#- - -
func _swap_to_blue():
	blueDeckParent.visible = true
	redDeckParent.visible = false
	
	swapToBlueParent.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	swapToRedParent.size_flags_horizontal = Control.SIZE_FILL
func _swap_to_red():
	blueDeckParent.visible = false
	redDeckParent.visible = true

	swapToBlueParent.size_flags_horizontal = Control.SIZE_FILL
	swapToRedParent.size_flags_horizontal = Control.SIZE_EXPAND_FILL
