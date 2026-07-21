extends Node

#these change in "create game" screen (once working, set all manual values here to zero)
var gridSize : Vector2i = Vector2i(11, 10)
var holePercentage : float = 0.15

var playerOneDeck : Deck = load("res://5_Resources/0_Premade Decks/standard deck.tres")
var playerTwoDeck : Deck = load("res://5_Resources/0_Premade Decks/test deck.tres")

var customMapPath : String = "" #NOTE: map editor? (smaller visualization of map), must set back to "" after assigning path

#-----

#these are fleeting local varaible used to connect scripts together
var currentToolTip : Control = null

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
var simpleToolTipRef : PackedScene = preload("res://1_Scenes/1_Objects/simple tooltip.tscn")
##returns a created tooltip || for tooltipRef, make it a PackedScene = preload() on the script that this function is called on
func _create_tooltip(tooltipRef : PackedScene = simpleToolTipRef) -> ToolTip:
	_destroy_tooltip()

	var toolTip : ToolTip = tooltipRef.instantiate()
	currentToolTip = toolTip
	return toolTip
##used to attatch the created tooltip to scene after assigning variables
func _add_tooltip_to_scene(toolTip : ToolTip):
	var screenParent : Screen = get_tree().current_scene
	screenParent.uiParent.add_child(toolTip)
func _destroy_tooltip():
	if currentToolTip != null:
		currentToolTip.queue_free()

func _assign_current_tile(newCurrentTile : Tile, newCurrentTrayTile : TrayTile):
	currentTile = newCurrentTile
	currentTrayTile = newCurrentTrayTile
func _clear_current_tile():
	currentTile = null
	currentTrayTile = null
