extends Control

class_name Tile

@export_category("References")
@export var visuals : Array[TextureRect]
@export var valueText : RichTextLabel
@export var button : Button

@export_category("Settings")
@export var currentTeam : Team

var gridLocation : Vector2i = Vector2i.ZERO
var currentValue : int = 0

enum Team{
	none,
	player_one,
	player_two,
	other,
	hole
	}

func _setup_tile(newValue : int):
	currentValue = newValue
	valueText.text = str(currentValue)

#-----------
func _change_value(changedValue : int, scoreboard : ScoreboardManager):
	currentValue += changedValue
	_update_value()
	
	if currentTeam == Team.player_one:
		scoreboard._change_score(TrayManager.Player.one, changedValue)
	elif currentTeam == Team.player_two:
		scoreboard._change_score(TrayManager.Player.two, changedValue)

func _update_value():
	valueText.text = str(currentValue)

func _swap_team(scoreboard : ScoreboardManager):
	if currentTeam == Team.player_one: #change to two
		currentTeam = Team.player_two
		scoreboard._change_score(TrayManager.Player.one, -currentValue)
		scoreboard._change_score(TrayManager.Player.two, currentValue)
		visuals[0].self_modulate = Color(1, 0, 0)
		visuals[1].self_modulate = Color(0.804, 0.0, 0.0, 1.0)
		visuals[2].self_modulate = Color(0.608, 0.0, 0.0, 1.0)
		visuals[3].self_modulate = Color(0.412, 0.0, 0.0, 1.0)
		visuals[4].self_modulate = Color(0.216, 0.0, 0.0, 1.0)
	else: #change to one
		currentTeam = Team.player_one
		scoreboard._change_score(TrayManager.Player.one, currentValue)
		scoreboard._change_score(TrayManager.Player.two, -currentValue)
		visuals[0].self_modulate = Color(0, 0, 1)
		visuals[1].self_modulate = Color(0, 0.0, 0.804, 1.0)
		visuals[2].self_modulate = Color(0, 0.0, 0.608, 1.0)
		visuals[3].self_modulate = Color(0, 0.0, 0.412, 1.0)
		visuals[4].self_modulate = Color(0, 0.0, 0.216, 1.0)

#- - -
##can override this with subclass for different effects (currently default surrounding capture)
func _apply_effect(mapManager : MapManager,
		scoreBoardManager : ScoreboardManager, 
		mapGenerator : MapGenerator,
		trayManager : TrayManager,
		tileMap : TileMapLayer
	):
	
	scoreBoardManager._change_score(trayManager.currentTurn, currentValue)
	
	var surroundingCells : Array[Vector2i] = tileMap.get_surrounding_cells(gridLocation)
	for cell in surroundingCells:
		var tile : Tile = mapManager._get_tile_of_cell_pos(cell)
		if tile == null:
			continue

		if tile.currentTeam == currentTeam:
			tile._change_value(1, scoreBoardManager)
		else:
			if currentValue > tile.currentValue:
				tile._swap_team(scoreBoardManager)

#-----------
func _is_interactable() -> bool:
	if currentValue != 0 || currentTeam == Team.hole:
		return false
	return true
