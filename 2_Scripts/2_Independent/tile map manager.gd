extends Control

class_name MapManager

@export_category("References")
@export var boardMouseDetection : Control
@export var mapGenerator : MapGenerator
@export var trayManager : TrayManager
@export var tileMap : TileMapLayer

func _place_tile(handIndex : int):
	var currentTile : Tile = trayManager._get_current_tile_of_hand_index(handIndex)
	
	var hoveredTilePos : Vector2i = _get_hovered_tile_pos()
	if _is_pos_valid(hoveredTilePos) == true:
		_add_tile_to_visual_parent(currentTile, hoveredTilePos)
		trayManager._place_tile_from_hand(handIndex)
	else:
		trayManager._return_hover_to_hand(handIndex)

func _add_tile_to_visual_parent(currentTile : Tile, hoveredTilePos : Vector2i):
	var newCurrentTile : Tile = trayManager._clone_tile(currentTile)
	newCurrentTile.gridLocation = hoveredTilePos
	mapGenerator._assign_value_to_map_tile(newCurrentTile.gridLocation, newCurrentTile.currentValue)

	tileMap.add_child(newCurrentTile)
	newCurrentTile.position = tileMap.map_to_local(newCurrentTile.gridLocation)
	newCurrentTile.position += Vector2(-19, -19)

#- - -
func _get_hovered_tile_pos() -> Vector2i:
	if _is_mouse_over_board() == false:
		return Vector2i(-1, -1)

	var mousePos : Vector2 = tileMap.get_local_mouse_position()
	var hoveredTile : Vector2i = tileMap.local_to_map(mousePos)

	return hoveredTile
func _is_mouse_over_board() -> bool:
	return get_viewport().gui_get_hovered_control() == boardMouseDetection

func _is_pos_valid(pos : Vector2i) -> bool:
	for tile in mapGenerator._get_all_tiles():
		if tile.gridLocation == pos: #exists in visible tiles grid
			if tile._is_interactable() == true:
				return true
			break
	return false
