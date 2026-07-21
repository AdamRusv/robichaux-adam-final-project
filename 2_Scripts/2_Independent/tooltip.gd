extends Control

class_name ToolTip

@export_category("References")
@export var parentContainer : Container
@export var textRef : RichTextLabel
@export_category("Settings")
@export var mouseOffset : Vector2i = Vector2i.ZERO
@export var sizeIncrease : Vector2

var displayText : String = ""
var targetSize : Vector2 = Vector2.ZERO

func _ready() -> void:
	visible = false
	_set_visuals(displayText)
	
	await get_tree().process_frame
	await get_tree().process_frame
	_set_sizing()
	await get_tree().process_frame
	_intro_animation()
##able to override in subclasses
func _set_visuals(newText : String):
	textRef.theme = textRef.theme.duplicate()
	textRef.theme.default_font_size = 12
	
	textRef.text = newText
func _set_sizing():
	targetSize = parentContainer.size
	mouseOffset.x -= targetSize.x / 2
	size = targetSize

func _process(delta: float) -> void:
	_follow_mouse()
func _follow_mouse():
	var mousePos : Vector2 = get_global_mouse_position()
	var finalPos : Vector2 = mousePos + Vector2(mouseOffset)
	
	var screenSize : Vector2 = get_viewport().get_visible_rect().size
	var bounds : Vector2 = screenSize - size
	finalPos = finalPos.clamp(Vector2.ZERO, bounds)
	global_position = finalPos.floor()

#-------------------------------------------------
func _intro_animation():
	textRef.visible = false
	textRef.theme.default_font_size = 3
	await get_tree().process_frame
	
	visible = true
	var newTween : Tween = create_tween()
	var duration : float = 0.3
	
	newTween.tween_property(parentContainer, "custom_minimum_size", targetSize, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	newTween.tween_callback(_enable_text)
	newTween.tween_property(textRef, "theme:default_font_size", 12, 0.1)
	#newTween.tween_property(parentContainer, "custom_minimum_size", initalSize, 0.1)

func _enable_text():
	textRef.visible = true
