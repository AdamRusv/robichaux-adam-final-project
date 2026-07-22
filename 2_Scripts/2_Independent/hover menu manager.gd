extends Control

class_name HoverMenuManager

@export_category("References")
@export var hoverZone : TextureButton
@export var textButtons : Array[Button]
@export var texts : Array[RichTextLabel]
@export var bitMapPath : String
@export_category("Settings")
@export var maxDistanceToMove : int
@export var speedModifier : float = 150

var isMenuOpen : bool = false
var closedPos : Vector2 = Vector2.ZERO

func _ready() -> void:
	_set_connections()
	_create_bitmap()
	
	closedPos = position
func _set_connections():
	for i in range(0, texts.size()):
		textButtons[i].mouse_entered.connect(_hover_text.bind(texts[i]))
		textButtons[i].mouse_exited.connect(_exit_text.bind(texts[i]))

func _process(delta: float) -> void:
	var isMouseInside : bool = _is_mouse_over_hover_bitmap()
	
	if isMouseInside == true && isMenuOpen == false && _is_mouse_over_other() == false:
		isMenuOpen = true
		_open_menu()
	elif isMouseInside == false && isMenuOpen == true:
		isMenuOpen = false
		_close_menu()
func _is_mouse_over_hover_bitmap() -> bool:
	var clickMask : BitMap = hoverZone.texture_click_mask

	if clickMask == null:
		return false

	var localMousePos : Vector2 = hoverZone.get_local_mouse_position()

	if localMousePos.x < 0.0 \
	|| localMousePos.y < 0.0 \
	|| localMousePos.x >= hoverZone.size.x \
	|| localMousePos.y >= hoverZone.size.y:
		return false

	var bitmapSize : Vector2i = clickMask.get_size()

	if bitmapSize.x <= 0 || bitmapSize.y <= 0:
		return false

	var normalizedPos : Vector2 = Vector2(
		localMousePos.x / hoverZone.size.x,
		localMousePos.y / hoverZone.size.y
	)

	var bitmapPos : Vector2i = Vector2i(
		clampi(int(normalizedPos.x * bitmapSize.x), 0, bitmapSize.x - 1),
		clampi(int(normalizedPos.y * bitmapSize.y), 0, bitmapSize.y - 1)
	)

	return clickMask.get_bitv(bitmapPos)

func _create_bitmap():
	var newBitmap : BitMap = BitMap.new()
	var bitMapTexture : Image = Image.load_from_file(bitMapPath)
	newBitmap.create_from_image_alpha(bitMapTexture)
	hoverZone.texture_click_mask = newBitmap

#----------------------------------
var tweens : Array[Tween]
func _clear_previous_tweens():
	for tween in tweens:
		tween.kill()

func _open_menu():
	_clear_previous_tweens()
	var tween : Tween = create_tween()
	tweens.append(tween)
	
	var endPosY : float = closedPos.y - maxDistanceToMove
	
	var distance : float = self.position.distance_to(Vector2(position.x, endPosY))
	var duration : float = distance / speedModifier
	
	tween.tween_property(self, "position:y", endPosY, duration)

func _close_menu():
	_clear_previous_tweens()
	var tween : Tween = create_tween()
	tweens.append(tween)
	
	var distance : float = self.position.distance_to(Vector2(position.x, closedPos.y))
	var duration : float = distance / speedModifier
	
	tween.tween_property(self, "position:y", closedPos.y, duration)

#----------------------------------
func _hover_text(currentText : RichTextLabel):
	currentText.add_theme_color_override("default_color", Color(0, 1, 1))

func _exit_text(currentText : RichTextLabel):
	currentText.add_theme_color_override("default_color", Color(0, 0, 0))

#- - -
func _is_mouse_over_other() -> bool:
	return get_viewport().gui_get_hovered_control() != hoverZone
