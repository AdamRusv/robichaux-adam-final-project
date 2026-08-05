extends Node

var popupMenuRef : PackedScene = preload("res://1_Scenes/0_Screens/popup menu.tscn")

var currentPopupMenu : PopupMenuWindow = null

func _open_popup_menu(menuParent : Control):
	if currentPopupMenu != null:
		return
	
	currentPopupMenu = popupMenuRef.instantiate()
	currentPopupMenu._set_references(menuParent)
	get_tree().current_scene.add_child(currentPopupMenu)

func _close_popup_menu():
	if currentPopupMenu == null:
		return
	
	currentPopupMenu.menu.reparent(get_tree().current_scene)
	currentPopupMenu.menu.visible = false
	currentPopupMenu.queue_free()
