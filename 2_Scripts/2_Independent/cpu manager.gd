extends Control

class_name CpuManager

@export_category("References")
@export var mapManager : MapManager

var difficulty : CPUGameSettings.Difficulty = CPUGameSettings.Difficulty.easy

func _place_tile():
	difficulty = GameManager.currentCpu.difficulty
	await get_tree().create_timer(1).timeout
	
	_capture_tile()

#- - -
func _capture_tile():
	var eachHandTileBestPlacementLocationData : Array[EmptyTileData] = [null, null, null, null]
	var cpuhand : Array[int] = _get_trayManager_cpu_hand()
	for i in range(0, cpuhand.size()):
		var allBestPositions : Array[EmptyTileData] = []
		for opposingTile in _get_all_opposite_cpuColor_tiles():
			if opposingTile.currentValue < cpuhand[i]:
				var capturePosition : EmptyTileData = _get_best_capture_position(opposingTile)
				if capturePosition != null:
					allBestPositions.append(capturePosition)
		
		
		var bestCapturePosition : EmptyTileData = null
		if allBestPositions.size() == 0:
			continue
		bestCapturePosition = allBestPositions[0]
		for capturePosition in allBestPositions:
			if bestCapturePosition.numberOfEffectedTiles < capturePosition.numberOfEffectedTiles:
				bestCapturePosition = capturePosition
		eachHandTileBestPlacementLocationData[i] = bestCapturePosition
	
	var hasCapturableSpot : bool = false
	for i in range(0, eachHandTileBestPlacementLocationData.size()):
		if eachHandTileBestPlacementLocationData[i] != null:
			hasCapturableSpot = true
	if hasCapturableSpot == false:
		_develop_tile()
		return
	
	var bestHandTile : EmptyTileData = null
	for i in range(0, eachHandTileBestPlacementLocationData.size()):
		if eachHandTileBestPlacementLocationData[i] != null:
			bestHandTile = EmptyTileData.new(eachHandTileBestPlacementLocationData[i].centerTile, eachHandTileBestPlacementLocationData[i].numberOfEffectedTiles)
			bestHandTile.handIndex = i
			break
	
	for i in range(0, eachHandTileBestPlacementLocationData.size()):
		if eachHandTileBestPlacementLocationData[i] == null:
			continue
		eachHandTileBestPlacementLocationData[i].handIndex = i
		if bestHandTile.numberOfEffectedTiles < eachHandTileBestPlacementLocationData[i].numberOfEffectedTiles:
			bestHandTile = eachHandTileBestPlacementLocationData[i]
	
	mapManager._place_cpu_tile(bestHandTile.handIndex, bestHandTile.centerTile.gridLocation)

func _develop_tile():
	var cpuhand : Array[int] = _get_trayManager_cpu_hand()
	var lowestTileValueIndex : int = 0
	for i in range(0, cpuhand.size()):
		if cpuhand[i] < cpuhand[lowestTileValueIndex]:
			lowestTileValueIndex = i
	if cpuhand[lowestTileValueIndex] == 0:
		for i in range(0, cpuhand.size()):
			if cpuhand[i] != 0:
				lowestTileValueIndex = i
				break
	
	var allBestPositions : Array[EmptyTileData] = []
	for opposingTile in _get_all_same_cpuColor_tiles():
		var capturePosition : EmptyTileData = _get_best_capture_position(opposingTile)
		if capturePosition != null:
			allBestPositions.append(capturePosition)
	var bestCapturePosition : EmptyTileData = null
	if allBestPositions.size() == 0:
		_place_at_random_location()
		return
	bestCapturePosition = allBestPositions[0]
	for capturePosition in allBestPositions:
		if bestCapturePosition.numberOfEffectedTiles < capturePosition.numberOfEffectedTiles:
			bestCapturePosition = capturePosition
	bestCapturePosition.handIndex = lowestTileValueIndex
	
	mapManager._place_cpu_tile(bestCapturePosition.handIndex, bestCapturePosition.centerTile.gridLocation)

func _place_at_random_location():
	var possiblePositions : Array[Vector2i]
	for tile in mapManager.mapGenerator._get_all_tiles():
		if mapManager._is_pos_valid(tile.gridLocation):
			possiblePositions.append(tile.gridLocation)
	
	var cpuHandIndex : int = -1
	var cpuhand : Array[int] = _get_trayManager_cpu_hand()
	for i in range(0, cpuhand.size()):
		if cpuhand[i] != null:
			cpuHandIndex = i
	
	var randomValidPosition : Vector2i = possiblePositions[randi_range(0, possiblePositions.size() - 1)]
	
	mapManager._place_cpu_tile(cpuHandIndex, randomValidPosition)

#- - -
class EmptyTileData:
	var centerTile : Tile
	var numberOfEffectedTiles : int = 0
	var handIndex : int = -1
	
	func _init(newCenterTile : Tile, newNumberOfEffectedTiles : int) -> void:
		centerTile = newCenterTile
		numberOfEffectedTiles = newNumberOfEffectedTiles
func _get_best_capture_position(tile : Tile) -> EmptyTileData: #tile argument should be a capturable tile
	var emptyTiles : Array[Tile] = []
	emptyTiles = tile._get_empty_surrounding_tiles(mapManager, mapManager.tileMap)
	if emptyTiles.size() == 0:
		return null
	
	var allEmptyTileData : Array[EmptyTileData] = []
	for emptyTile in emptyTiles:
		var surroundingAllyTiles : Array[Tile] = tile._get_surrounding_ally_tiles(mapManager, mapManager.tileMap)
		var numberOfEffectedTiles : int = 0
		for allyTile in surroundingAllyTiles:
			if tile.currentValue > allyTile.currentValue:
				numberOfEffectedTiles += 1
		var capturePosition : EmptyTileData = EmptyTileData.new(emptyTile, numberOfEffectedTiles)
		allEmptyTileData.append(capturePosition)
	
	var highestCapturableTileCount : EmptyTileData = null
	highestCapturableTileCount = allEmptyTileData[0]
	for emptyTileData in allEmptyTileData:
		if highestCapturableTileCount.numberOfEffectedTiles < emptyTileData.numberOfEffectedTiles:
			highestCapturableTileCount = emptyTileData
	
	return highestCapturableTileCount

func _get_best_develop_position(tile : Tile) -> EmptyTileData:
	var emptyTiles : Array[Tile] = []
	emptyTiles = tile._get_empty_surrounding_tiles(mapManager, mapManager.tileMap)
	if emptyTiles.size() == 0:
		return null
	
	var allEmptyTileData : Array[EmptyTileData] = []
	for emptyTile in emptyTiles:
		var surroundingAllyTiles : Array[Tile] = tile._get_surrounding_ally_tiles(mapManager, mapManager.tileMap)
		var numberOfEffectedTiles : int = 0
		for allyTile in surroundingAllyTiles:
			numberOfEffectedTiles += 1
		var developPosition : EmptyTileData = EmptyTileData.new(emptyTile, numberOfEffectedTiles)
		allEmptyTileData.append(developPosition)
	
	var highestDevelopTileCount : EmptyTileData = null
	highestDevelopTileCount = allEmptyTileData[0]
	for emptyTileData in allEmptyTileData:
		if highestDevelopTileCount.numberOfEffectedTiles < emptyTileData.numberOfEffectedTiles:
			highestDevelopTileCount = emptyTileData
	
	return highestDevelopTileCount

#---------------------------------
func _get_trayManager_cpu_hand() -> Array[int]:
	if GameManager.cpuColor == GameManager.TeamColor.blue:
		return mapManager.trayManager.playerOneCurrentHand
	elif GameManager.cpuColor == GameManager.TeamColor.red:
		return mapManager.trayManager.playerTwoCurrentHand
	
	return []

func _get_all_opposite_cpuColor_tiles() -> Array[Tile]:
	if GameManager.cpuColor == GameManager.TeamColor.blue:
		return mapManager._get_all_red_tiles()
	elif GameManager.cpuColor == GameManager.TeamColor.red:
		return mapManager._get_all_blue_tiles()
	
	return []

func _get_all_same_cpuColor_tiles() -> Array[Tile]:
	if GameManager.cpuColor == GameManager.TeamColor.blue:
		return mapManager._get_all_blue_tiles()
	elif GameManager.cpuColor == GameManager.TeamColor.red:
		return mapManager._get_all_red_tiles()
	
	return []
