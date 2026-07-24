extends Node

class_name Screen

var uiParent : Node

func _ready() -> void:
	_assign_self_to_gamemanager()
	
	uiParent = %UI

func _assign_self_to_gamemanager():
	GameManager.screen = self
