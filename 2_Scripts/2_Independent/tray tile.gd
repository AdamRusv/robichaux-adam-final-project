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
	button.button_down.connect(_click)
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

func _exit():
	pass

func _click():
	if currentTile == null:
		return
	
	mouseOffset = get_global_mouse_position() - currentTile.global_position
	GameManager._assign_current_tile(currentTile, self)
	isDragging = true

func _release():
	if currentTile == null:
		return
	
	isDragging = false
	releasedTile.emit()
	GameManager._clear_current_tile()

#----------------------------
##used for grid snap
var pauseDrag : bool
func _drag_tile():
	if currentTile == null || pauseDrag == true:
		return
	
	var mousePos : Vector2 = get_global_mouse_position()
	
	currentTile.global_position = floor(mousePos - mouseOffset)

#- - -
func _reset_drag():
	currentTile.position = Vector2.ZERO
