extends Control
class_name CustomCursor

@export var imageNode : AnimatedSprite2D
@export var hotspot : Vector2 = Vector2.ZERO	# pixel offset from the texture’s top-left to the “click point”
@export var followWhenHidden : bool = true		# if false, will auto-hide this when OS cursor is shown (e.g., alt-tab)

var wasHiddenByUs : bool = false

func _ready() -> void:

	# Render above everything/UI.
	z_index = 4096
	top_level = true
	set_anchors_preset(Control.PRESET_TOP_LEFT)
	pivot_offset = Vector2.ZERO
	
	# Hide OS cursor and remember we did it (so we can restore on exit).
	_hide_os_cursor()

	# Position immediately so there’s no one-frame pop.
	_update_cursor_position()
	
	#imageNode.material = imageNode.material.duplicate()

func _process(_delta : float) -> void:
	# Keep following the real mouse.
	_update_cursor_position()

	# Optional: if the OS cursor becomes visible (e.g., by the OS),
	# mirror that visibility to avoid double-cursor confusion.
	if not _is_os_cursor_hidden():
		if followWhenHidden:
			# Hide our scene if OS cursor is visible.
			visible = false
		else:
			# Force-hide OS cursor again.
			_hide_os_cursor()
			visible = true
	else:
		visible = true
	
	if Input.is_action_just_pressed("left click"):
		imageNode.frame = 1
		#imageNode.material.set_shader_parameter("shadowOffsetPx", Vector2(0, 0))
	
	if Input.is_action_just_released("left click"):
		imageNode.frame = 0
		#imageNode.material.set_shader_parameter("shadowOffsetPx", Vector2(0, -1))

func _update_cursor_position() -> void:
	# Viewport mouse position is already in UI (Control) coordinates.
	var mousePos : Vector2 = get_viewport().get_mouse_position()
	# Align the visual so the hotspot is the actual click point.
	var newPos = mousePos - hotspot
	global_position = floor(newPos)

func _notification(what : int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			# When the window loses focus, restore OS cursor so the desktop isn’t cursor-less.
			_show_os_cursor()
		NOTIFICATION_APPLICATION_FOCUS_IN:
			# Re-hide when we regain focus.
			_hide_os_cursor()
		NOTIFICATION_WM_CLOSE_REQUEST, NOTIFICATION_PREDELETE, NOTIFICATION_EXIT_TREE:
			# Always restore on shutdown.
			_show_os_cursor()

func _hide_os_cursor() -> void:
	if not _is_os_cursor_hidden():
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		wasHiddenByUs = true

func _show_os_cursor() -> void:
	# Only restore if we hid it, so we don’t fight other systems.
	if wasHiddenByUs and _is_os_cursor_hidden():
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		wasHiddenByUs = false

func _is_os_cursor_hidden() -> bool:
	return Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN
