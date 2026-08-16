extends Button

class_name BoardMoveManager

@export var board : Control
@export var boardBounds : Control

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
	
	var rawPostion : Vector2 = mousePos - mouseOffset
	var xclamp : float = clamp(rawPostion.x, -boardBounds.size.x + boardBounds.size.x/2, boardBounds.size.x - boardBounds.size.x/2)
	var yclamp : float = clamp(rawPostion.y, -boardBounds.size.x + boardBounds.size.x/2, boardBounds.size.y - boardBounds.size.x/2)
	board.global_position = Vector2(xclamp, yclamp)
	print(boardBounds.size.x)

func _center_at_global_position(tileGlobalPosition : Vector2):
	var newTween : Tween = create_tween()
	
	var viewportCenter : Vector2 = get_viewport_rect().size * 0.5 
	var distanceToCenter : Vector2 = viewportCenter - tileGlobalPosition
	var offset : Vector2 = Vector2(-19, -30)
	var endPos : Vector2 = board.global_position + (distanceToCenter + offset)
	
	var distance : float = board.global_position.distance_to(endPos)
	var duration : float = distance / 100
	
	newTween.tween_property(board, "global_position", endPos, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	await newTween.finished
	get_tree().current_scene.screenBlocker.visible = false
