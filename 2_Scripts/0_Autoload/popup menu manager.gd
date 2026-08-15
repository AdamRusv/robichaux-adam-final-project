extends Node

var popupMenuRef : PackedScene = preload("res://1_Scenes/0_Screens/popup menu.tscn")

var currentPopupMenu : PopupMenuWindow = null

func _open_popup_menu(menuParent : Control):
	if windowPreloaded == false:
		if currentPopupMenu != null:
			return
		currentPopupMenu = popupMenuRef.instantiate()
		get_tree().current_scene.add_child(currentPopupMenu)
	else:
		windowPreloaded = false
	
	currentPopupMenu._set_references(menuParent)
	currentPopupMenu._open_menu()

func _close_popup_menu():
	if currentPopupMenu == null:
		return
	
	currentPopupMenu.menu.reparent(get_tree().current_scene)
	currentPopupMenu.menu.visible = false
	currentPopupMenu.queue_free()

func _animate_close_popup_menu():
	if currentPopupMenu == null:
		return
	
	await currentPopupMenu._close_menu().finished
	currentPopupMenu.menu.reparent(get_tree().current_scene)
	currentPopupMenu.menu.visible = false
	currentPopupMenu.queue_free()

#-
var windowPreloaded : bool = false
func _preload_window():
	currentPopupMenu = popupMenuRef.instantiate()
	get_tree().current_scene.add_child(currentPopupMenu)
	windowPreloaded = true
