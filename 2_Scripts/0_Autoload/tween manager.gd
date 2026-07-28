extends Node

enum ScreenSide{
	top,
	right,
	bottom,
	left
}

##moves control to starting postition from the given screenSide
func _enter_from(sideToEnterFrom : ScreenSide, nodeToMove : Control, speed : float = 300, delay : float = 0) -> Tween:
	var endPos : Vector2 = nodeToMove.position
	nodeToMove.position = _get_starting_pos(sideToEnterFrom, nodeToMove)
	
	var newTween : Tween = create_tween()
	
	if delay > 0:
		newTween.tween_interval(delay)
	
	var distance : float = nodeToMove.position.distance_to(endPos)
	var duration : float = distance / speed
	
	newTween.tween_property(nodeToMove, "position", endPos, duration).set_custom_interpolator(_tween_curve)
	
	return newTween

func _scale_in(nodeToFade : Control, duration : float = 1, delay : float = 0) -> Tween:
	nodeToFade.pivot_offset = nodeToFade.size / 2
	nodeToFade.scale = Vector2.ZERO
	
	var newTween : Tween = create_tween()
	
	if delay > 0:
		newTween.tween_interval(delay)
	
	newTween.tween_property(nodeToFade, "scale", Vector2.ONE, duration).set_custom_interpolator(_tween_curve)
	
	return newTween

#------------------------------
func _get_starting_pos(sideToEnterFrom : ScreenSide, nodeToMove : Control) -> Vector2:
	var startingPos : Vector2
	
	match sideToEnterFrom:
		ScreenSide.top:
			startingPos = Vector2(nodeToMove.position.x, -180)
		ScreenSide.right:
			startingPos = Vector2(640, nodeToMove.position.y)
		ScreenSide.bottom:
			startingPos = Vector2(nodeToMove.position.x, 360)
		ScreenSide.left:
			startingPos = Vector2(-320, nodeToMove.position.y)
	
	return startingPos

var doubleBackCurve : Curve = load("res://6_Other/tween curve double back.tres")
func _tween_curve(v):
	return doubleBackCurve.sample_baked(v)
