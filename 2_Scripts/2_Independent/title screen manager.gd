extends CursorShake

@export_category("References")
@export var lettersParent : Control
@export var letters : Array[Control]
@export var clickAnywhereText : RichTextLabel

func _ready() -> void:
	super._ready()
	
	_enter_title()

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


#--------------------------------------------------------
func _oscillate(nodeToOscillate : Control):
	var initalPositionY : float = nodeToOscillate.position.y
	var currentTotalMovement : int = 0
	var movingUp : bool = true
	while true:
		if currentTotalMovement >= 2:
			movingUp = false
		elif currentTotalMovement <= -2:
			movingUp = true
		
		if movingUp == true:
			currentTotalMovement += 1
			nodeToOscillate.position.y = initalPositionY + currentTotalMovement
			await get_tree().create_timer(0.8).timeout
		else:
			currentTotalMovement -= 1
			nodeToOscillate.position.y = initalPositionY + currentTotalMovement
			await get_tree().create_timer(0.8).timeout
func _blink(nodeToBlink : Control):
	while true:
		await get_tree().create_timer(0.7).timeout
		nodeToBlink.visible = false
		await get_tree().create_timer(0.7).timeout
		nodeToBlink.visible = true
