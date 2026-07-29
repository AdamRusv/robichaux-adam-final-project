extends CursorShake

@export_category("References")
@export var lettersParent : Control
@export var letters : Array[Control]
@export var clickAnywhereText : RichTextLabel
@export var screenButton : Button

var introFinished : bool = false
var clicked : bool = false

func _ready() -> void:
	super._ready()
	
	_enter_title()
	_set_connections()
func _set_connections():
	screenButton.pressed.connect(_click)

func _enter_title():
	_oscillate(lettersParent)
	
	var delay : float = 0
	var delayIncrement : float = 0.1
	var lastLetter : Tween = null
	for i in range(0, letters.size()):
		if i == letters.size() - 1:
			lastLetter = TweenManager._enter_from(TweenManager.ScreenSide.top, letters[i], 200, delay)
		else:
			TweenManager._enter_from(TweenManager.ScreenSide.top, letters[i], 200, delay)
		delay += delayIncrement
	
	clickAnywhereText.scale = Vector2.ZERO
	await lastLetter.finished
	await TweenManager._scale_in(clickAnywhereText, 0.5).finished
	_blink(clickAnywhereText)
	
	introFinished = true

func _click():
	if introFinished == false || clicked == true:
		return
	
	clicked = true
	clickAnywhereText.visible = true
	
	await get_tree().create_timer(1).timeout
	clickAnywhereText.visible = true
	
	var endPosTop : Vector2 = TweenManager._get_outside_screen_pos(TweenManager.ScreenSide.top, lettersParent)
	var endPosBottom : Vector2 = TweenManager._get_outside_screen_pos(TweenManager.ScreenSide.bottom, clickAnywhereText)
	endPosTop.y += 100
	endPosBottom.y -= 100
	
	var newTween : Tween = create_tween().set_parallel()
	
	newTween.tween_property(lettersParent, "position", endPosTop, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	newTween.tween_property(clickAnywhereText, "position", endPosBottom, 1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

#--------------------------------------------------------
func _oscillate(nodeToOscillate : Control):
	var initalPositionY : float = nodeToOscillate.position.y
	var currentTotalMovement : int = 0
	var movingUp : bool = true
	while clicked == false:
		if currentTotalMovement >= 2:
			movingUp = false
		elif currentTotalMovement <= -2:
			movingUp = true
		
		if movingUp == true:
			currentTotalMovement += 1
			nodeToOscillate.position.y = initalPositionY + currentTotalMovement
			await get_tree().create_timer(0.6).timeout
		else:
			currentTotalMovement -= 1
			nodeToOscillate.position.y = initalPositionY + currentTotalMovement
			await get_tree().create_timer(0.6).timeout
func _blink(nodeToBlink : Control):
	while clicked == false:
		await get_tree().create_timer(0.7).timeout
		nodeToBlink.visible = false
		await get_tree().create_timer(0.7).timeout
		nodeToBlink.visible = true
