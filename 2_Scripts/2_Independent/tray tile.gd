extends Control

class_name TrayTile

@export_category("References")
@export var button : Button

var currentTile : Tile

func _ready() -> void:
	_set_connections()
func _set_connections():
	button.mouse_entered.connect(_hover)
	button.mouse_exited.connect(_exit)
	button.button_down.connect(_click_down)
	button.button_up.connect(_release)

func _process(delta: float) -> void:
	if isDragging == true:
		_drag_tile()

#- - -
var isDragging : bool = false
var mouseOffset : Vector2 = Vector2.ZERO
signal releasedTile

func _hover():
	pass
	#SoundManager._create_sfx(SoundManager.tileHover)

func _exit():
	pass

func _click_down():
	if currentTile == null:
		return
	if _is_cpu() == true:
		return
	
	SoundManager._create_sfx(SoundManager.tileClick)
	mouseOffset = get_global_mouse_position() - currentTile.global_position
	GameManager._assign_current_tile(currentTile, self)
	currentTile.reparent(GameManager.gameplayManager.uiParent)
	isDragging = true

func _release():
	if currentTile == null:
		return
	if _is_cpu() == true:
		return
	
	SoundManager._create_sfx(SoundManager.tilePlace)
	isDragging = false
	currentTile.reparent(currentTile.get_meta("trayparent"))
	releasedTile.emit()
	GameManager._clear_current_tile()

#----------------------------
##used for grid snap
var pauseDrag : bool
func _drag_tile():
	if currentTile == null || pauseDrag == true:
		return
	if _is_cpu() == true:
		return
	
	var mousePos : Vector2 = get_global_mouse_position()
	
	currentTile.global_position = floor(mousePos - mouseOffset)

#- - -
func _reset_drag():
	currentTile.position = Vector2.ZERO

#- - -
##disables mouse interaction
func _is_cpu() -> bool:
	if currentTile == null || GameManager.currentCpu == null:
		return false
	
	if currentTile.currentTeam == currentTile.Team.player_one &&\
	GameManager.cpuColor == GameManager.TeamColor.blue:
		return true
	elif currentTile.currentTeam == currentTile.Team.player_two &&\
	GameManager.cpuColor == GameManager.TeamColor.red:
		return true
	
	return false
