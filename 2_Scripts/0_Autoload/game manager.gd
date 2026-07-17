extends Node

#these change in "create game" screen (once working, set all manual values here to zero)
var gridSize : Vector2i = Vector2i(11, 10)
var holePercentage : float = 0.15

var playerOneDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
var playerTwoDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")

var customMapPath : String = "" #NOTE: map editor? (smaller visualization of map), must set back to "" after assigning path

#-----

#these are fleeting local varaible used to connect scripts together
##clicked and dragged tile
var currentTile : Tile = null

var playerOneScore : int = 0
var playerTwoScore : int = 0

#
func _ready() -> void:
	randomize()

#-------------------------------------------------
func _assign_current_tile(newCurrentTile : Tile):
	currentTile = newCurrentTile
func _clear_current_tile():
	currentTile = null
