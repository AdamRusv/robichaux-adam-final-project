extends Control

class_name TrayManager

@export_category("References")
@export var tileMap : MapManager
@export var otherHand : OtherHand
@export var mapTiles : Array[Tile]
@export var trayTiles : Array[TrayTile]

##cards not visible, must be in numarical order
var playerOneCurrentDeck : Array[int]
##cards not visible, must be in numarical order
var playerTwoCurrentDeck : Array[int]

##cards in Tray
var playerOneCurrentHand : Array[int]
##cards in Tray
var playerTwoCurrentHand : Array[int]

var currentTurn : Player = Player.one

enum Player{
	one,
	two
}

var playerOneTileRef : PackedScene = preload("res://1_Scenes/1_Objects/player 1 tile.tscn")
var playerTwoTileRef : PackedScene = preload("res://1_Scenes/1_Objects/player 2 tile.tscn")

func _ready() -> void:
	playerOneCurrentHand = [0, 0, 0, 0]
	playerTwoCurrentHand = [0, 0, 0, 0]
	
	_set_connections()
	_load_decks()
	_start_player_turn(playerOneCurrentDeck, playerOneCurrentHand)
func _set_connections():
	for i in range(0, trayTiles.size()):
		trayTiles[i].releasedTile.connect(tileMap._place_tile.bind(i))
func _load_decks():
	for card in GameManager.playerOneDeck.deck:
		playerOneCurrentDeck.append(card)
	
	for card in GameManager.playerTwoDeck.deck:
		playerTwoCurrentDeck.append(card)

#- - -
func _start_player_turn(playerDeck : Array[int], playerHand : Array[int]):
	_clear_hand()
	
	for i in range(0, trayTiles.size()):
		if playerHand[i] == 0:
			_populate_new_card_in_hand(playerHand, playerDeck, i)
		else:
			_populate_existing_card_in_hand(playerHand, i)

func _populate_new_card_in_hand(playerHand : Array[int], playerDeck : Array[int], playerCardIndex : int):
	if playerDeck.size() == 0:
		return
	
	var selectedCardValue : int = _take_card_in_deck(playerDeck)
	playerHand[playerCardIndex] = selectedCardValue
	
	_create_tile(playerCardIndex, selectedCardValue)
func _populate_existing_card_in_hand(playerHand : Array[int], playerCardIndex : int):
	var selectedCardValue : int = playerHand[playerCardIndex]
	playerHand[playerCardIndex] = selectedCardValue
	
	_create_tile(playerCardIndex, selectedCardValue)

#
func _create_tile(playerCardIndex : int, selectedCardValue : int):
	var newTileInTray : Tile = null
	if currentTurn == Player.one:
		newTileInTray = playerOneTileRef.instantiate()
	else:
		newTileInTray = playerTwoTileRef.instantiate()
	
	trayTiles[playerCardIndex].currentTile = newTileInTray
	newTileInTray._setup_tile(selectedCardValue)
	trayTiles[playerCardIndex].add_child(newTileInTray)
	newTileInTray.set_meta("trayparent", trayTiles[playerCardIndex])
	newTileInTray.position = Vector2.ZERO

func _clear_hand():
	for tile in trayTiles:
		if tile.currentTile == null:
			continue
		tile.currentTile.queue_free()

#
func _return_hover_to_hand(handIndex : int):
	var trayTile : TrayTile = trayTiles[handIndex]
	trayTile._reset_drag()

func _place_tile_from_hand(handIndex : int):
	if currentTurn == Player.one:
		playerOneCurrentHand[handIndex] = 0
	else:
		playerTwoCurrentHand[handIndex] = 0
	_swap_current_player()

func _swap_current_player():
	if currentTurn == Player.one:
		currentTurn = Player.two
		_start_player_turn(playerTwoCurrentDeck, playerTwoCurrentHand)
		otherHand._update_cards(playerOneCurrentHand)
	else:
		currentTurn = Player.one
		_start_player_turn(playerOneCurrentDeck, playerOneCurrentHand)
		otherHand._update_cards(playerTwoCurrentHand)

#- - -
func _take_card_in_deck(playerDeck : Array[int]) -> int:
	var randomIndex : int = randi_range(0, playerDeck.size() - 1)
	return playerDeck.pop_at(randomIndex)

func _get_current_tile_of_hand_index(handIndex : int) -> Tile:
	return trayTiles[handIndex].currentTile

func _clone_tile(currentTile : Tile) -> Tile:
	var clonedTile : Tile = null
	if currentTurn == Player.one:
		clonedTile = playerOneTileRef.instantiate()
	else:
		clonedTile = playerTwoTileRef.instantiate()
	
	clonedTile._setup_tile(currentTile.currentValue)
	return clonedTile
