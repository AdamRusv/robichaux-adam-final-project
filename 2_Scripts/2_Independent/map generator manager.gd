extends Node

class_name MapGenerator

@export_category("References")
@export var visualMap : VBoxContainer
@export var tileMap : TileMapLayer

var rows : Array[VisualTileRow]

var mapTileRef : PackedScene = preload("res://1_Scenes/1_Objects/map tile.tscn")
var holeTileRef : PackedScene = preload("res://1_Scenes/1_Objects/hole tile.tscn")

var standardRowRef : PackedScene = preload("res://1_Scenes/1_Objects/standard row.tscn")
var offsetRowRef : PackedScene = preload("res://1_Scenes/1_Objects/offset row.tscn")

func _ready() -> void:
	if GameManager.customMapPath == "":
		_generate_map()
	else:
		_load_map()

#- - -
##randomly generated map
func _generate_map():
	for y in range(0, GameManager.gridSize.y):
		var newRow : VisualTileRow = null
		if y % 2 == 0:
			newRow = standardRowRef.instantiate()
		else:
			newRow = offsetRowRef.instantiate()
		
		rows.append(newRow)
		visualMap.add_child(newRow)
		
		for x in range(0, GameManager.gridSize.x):
			var newTile : Tile = null
			if randf() < GameManager.holePercentage: #in the chance
				newTile = holeTileRef.instantiate()
			else:
				newTile = mapTileRef.instantiate()
			
			newTile.gridLocation = Vector2i(x, y)
			newRow.tiles.append(newTile)
			newRow.horizontalContainer.add_child(newTile)
	
	if _is_map_valid() == false:
		print("rerolled map")
		_clear_map()
		_generate_map()

func _clear_map():
	rows.clear()
	for child in visualMap.get_children():
		child.queue_free()

func _is_map_valid() -> bool:
	var allTiles : Array[Tile] = _get_all_map_tiles()
	
	var smallestDeckSize : int = -1
	if GameManager.playerTwoDeck.deck.size() >= GameManager.playerOneDeck.deck.size():
		smallestDeckSize = GameManager.playerOneDeck.deck.size()
	elif GameManager.playerTwoDeck.deck.size() <= GameManager.playerOneDeck.deck.size():
		smallestDeckSize = GameManager.playerTwoDeck.deck.size()
	
	if allTiles.size() > smallestDeckSize * 2:
		return true
	else:
		return false

##custom map
func _load_map():
	pass

#- - -
func _assign_value_to_map_tile(newGridLocation : Vector2i, newValue : int):
	var allTiles : Array[Tile] = _get_all_tiles()
	
	for tile in allTiles:
		if tile.gridLocation == newGridLocation:
			tile.currentValue = newValue

#------------
func _get_all_tiles() -> Array[Tile]:
	var allTiles : Array[Tile] = []
	for row in rows:
		for tile in row.tiles:
			allTiles.append(tile)
	return allTiles

func _get_all_map_tiles() -> Array[Tile]:
	var allMapTiles : Array[Tile] = []
	for row in rows:
		for tile in row.tiles:
			if tile.currentTeam != tile.Team.hole:
				allMapTiles.append(tile)
	return allMapTiles
