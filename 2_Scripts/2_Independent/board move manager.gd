extends Button

class_name BoardMoveManager

@export var board : Control
@export var tileMapBoard : Control

var isDragging : bool = false

func _ready() -> void:
	_set_connections()
func _set_connections():
	button_down.connect(_enable_drag)
	button_up.connect(_disable_drag)

func _process(delta: float) -> void:
	if isDragging == true:
		_drag_board()

#---------------------
var mouseOffset : Vector2 = Vector2.ZERO
func _enable_drag():
	mouseOffset = get_global_mouse_position() - board.global_position
	isDragging = true

func _disable_drag():
	isDragging = false

#- - -
func _drag_board():
	var mousePos : Vector2 = get_global_mouse_position()
	
	board.global_position = mousePos - mouseOffset
	tileMapBoard.global_position = mousePos - mouseOffset
