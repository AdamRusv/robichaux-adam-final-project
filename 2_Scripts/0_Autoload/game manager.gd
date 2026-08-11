extends Node

#these change in "create game" screen (once working, set all manual values here to zero)
var gridSize : Vector2i = Vector2i(11, 10)
var holePercentage : float = 0.20

var playerOneDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
var playerTwoDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")

var customMapPath : String = "" #NOTE: map editor? (smaller visualization of map), must set back to "" after assigning path

#-----

#these are fleeting local varaible used to connect scripts together
var gameplayManager : GameplayManager = null

##clicked and dragged tile
var currentTile : Tile = null
##selected tile's TrayTile
var currentTrayTile : TrayTile = null

var playerOneScore : int = 0
var playerTwoScore : int = 0

#
func _ready() -> void:
	randomize()

#-------------------------------------------------
func _assign_current_tile(newCurrentTile : Tile, newCurrentTrayTile : TrayTile):
	currentTile = newCurrentTile
	currentTrayTile = newCurrentTrayTile
func _clear_current_tile():
	currentTile = null
	currentTrayTile = null

#- - - - - - - - - - - - - - -
var currentCpu : CPUGameSettings
var cpuColor : TeamColor = TeamColor.none
enum TeamColor{
	none,
	blue,
	red
}

func _apply_cpuGameSettings(newCpuGameSettings : CPUGameSettings):
	currentCpu = newCpuGameSettings
	
	gridSize = currentCpu._get_map_layout()
	holePercentage = currentCpu._get_hole_percent()
	
	match currentCpu.cpuColor:
		CPUGameSettings.CPUColor.blue:
			_assign_cpu_blue()
		CPUGameSettings.CPUColor.red:
			_assign_cpu_red()
		CPUGameSettings.CPUColor.random:
			var newRandom : int = randi_range(0, 1)
			if newRandom == 0:
				_assign_cpu_blue()
			else:
				_assign_cpu_red()
func _assign_cpu_blue():
	cpuColor = TeamColor.blue
	playerOneDeck = currentCpu._get_deck(currentCpu.cpuDeck)
	playerTwoDeck = currentCpu._get_deck(currentCpu.playerDeck)
func _assign_cpu_red():
	cpuColor = TeamColor.red
	playerOneDeck = currentCpu._get_deck(currentCpu.playerDeck)
	playerTwoDeck = currentCpu._get_deck(currentCpu.cpuDeck)
