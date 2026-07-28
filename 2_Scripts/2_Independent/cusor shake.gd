extends Control

class_name CursorShake

@export var maxOffset : Vector2 = Vector2(2, 2)
@export var followSpeed : float = 2.0

var viewportSize : Vector2
var basePosition : Vector2


func _ready() -> void:
	viewportSize = get_viewport().get_visible_rect().size
	
	basePosition = global_position


func _process(delta : float) -> void:
	# Mouse position in viewport space
	var mousePos : Vector2 = get_viewport().get_mouse_position()
	var center : Vector2 = viewportSize * 0.5
	
	# Convert to range -1..1 based on screen center
	var normalized : Vector2 = (mousePos - center) / center
	
	# Clamp so going off-screen doesn't explode the offset
	normalized.x = clampf(normalized.x, -1.0, 1.0)
	normalized.y = clampf(normalized.y, -1.0, 1.0)
	
	# Final offset the camera will move by
	var targetOffset : Vector2 = Vector2(
		maxOffset.x * normalized.x,
		maxOffset.y * normalized.y
	)
	
	var targetPos : Vector2 = basePosition + targetOffset
	
	# Smoothly lerp camera toward target position
	var t : float = 1.0 - pow(0.001, delta * followSpeed)
	global_position = global_position.lerp(targetPos, t)
