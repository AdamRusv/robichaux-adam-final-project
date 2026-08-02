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
	nodeToMove.position = _get_outside_screen_pos(sideToEnterFrom, nodeToMove)
	
	var newTween : Tween = create_tween()
	
	if delay > 0:
		newTween.tween_interval(delay)
	
	var distance : float = nodeToMove.position.distance_to(endPos)
	var duration : float = distance / speed
	
	newTween.tween_property(nodeToMove, "position", endPos, duration).set_custom_interpolator(_tween_curve)
	
	return newTween
func _offset_enter_from(sideToEnterFrom : ScreenSide, nodeToMove : Control, speed : float = 300, delay : float = 0, customCurve : bool = true) -> Tween:
	nodeToMove.offset_transform_enabled = true
	var endPos : Vector2 = nodeToMove.position
	nodeToMove.offset_transform_position = _get_outside_screen_pos(sideToEnterFrom, nodeToMove)
	
	var newTween : Tween = create_tween()
	
	if delay > 0:
		newTween.tween_interval(delay)
	
	var distance : float = nodeToMove.offset_transform_position.distance_to(endPos)
	var duration : float = distance / speed
	
	if customCurve == true:
		newTween.tween_property(nodeToMove, "offset_transform_position", Vector2.ZERO, duration).set_custom_interpolator(_tween_curve)
	else:
		newTween.tween_property(nodeToMove, "offset_transform_position", Vector2.ZERO, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	return newTween

func _exit_to(sideToExitTo : ScreenSide, nodeToMove : Control, speed : float = 300, delay : float = 0) -> Tween:
	var endPos : Vector2 = _get_outside_screen_pos(sideToExitTo, nodeToMove)
	
	var newTween : Tween = create_tween()
	
	if delay > 0:
		newTween.tween_interval(delay)
	
	var distance : float = nodeToMove.position.distance_to(endPos)
	var duration : float = distance / speed
	
	newTween.tween_property(nodeToMove, "position", endPos, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	
	return newTween
func _offset_exit_to(sideToExitTo : ScreenSide, nodeToMove : Control, speed : float = 300, delay : float = 0) -> Tween:
	nodeToMove.offset_transform_enabled = true
	var endPos : Vector2 = _get_outside_screen_pos(sideToExitTo, nodeToMove)
	endPos = Vector2(0, endPos.y)
	
	var newTween : Tween = create_tween()
	
	if delay > 0:
		newTween.tween_interval(delay)
	
	var distance : float = nodeToMove.position.distance_to(endPos)
	var duration : float = distance / speed

	newTween.tween_property(nodeToMove, "offset_transform_position", endPos, duration).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	
	return newTween

#-
func _scale_in(nodeToFade : Control, duration : float = 1, delay : float = 0) -> Tween:
	nodeToFade.pivot_offset = nodeToFade.size / 2
	nodeToFade.scale = Vector2.ZERO
	
	var newTween : Tween = create_tween()
	
	if delay > 0:
		newTween.tween_interval(delay)
	
	newTween.tween_property(nodeToFade, "scale", Vector2.ONE, duration).set_custom_interpolator(_tween_curve)
	
	return newTween

#------------------------------
func _get_outside_screen_pos(sideToEnterFrom : ScreenSide, nodeToMove : Control) -> Vector2:
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
