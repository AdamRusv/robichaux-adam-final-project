extends HoverMenuManager

class_name OtherHand
@export var trayManager : TrayManager
@export var backgroundModulatesToSwap : Array[Control]
@export var cards : Array[ViewDeckCard]


func _ready() -> void:
	super._ready()
	
	_update_cards([0, 0, 0, 0])

func _open_menu():
	_clear_previous_tweens()
	var tween : Tween = create_tween()
	tweens.append(tween)
	
	var endPosX : float = closedPos.x - maxDistanceToMove
	
	var distance : float = self.position.distance_to(Vector2(endPosX, position.y))
	var duration : float = distance / speedModifier
	
	tween.tween_property(self, "position:x", endPosX, duration)
func _close_menu():
	_clear_previous_tweens()
	var tween : Tween = create_tween()
	tweens.append(tween)
	
	var distance : float = self.position.distance_to(Vector2(closedPos.x, position.y))
	var duration : float = distance / speedModifier
	
	tween.tween_property(self, "position:x", closedPos.x, duration)

#-----------------------------
func _update_cards(newCards : Array[int]):
	_set_background_color()
	for i in range(0, newCards.size()):
		if newCards[i] == 0:
			cards[i].textRef.text = "??"
		else:
			cards[i].textRef.text = str(newCards[i])

func _set_background_color():
	var playerColor : Color
	if trayManager.currentTurn == trayManager.Player.one:
		playerColor = Color(1, 0, 0)
	else:
		playerColor = Color(0, 0, 1)
	
	for node in backgroundModulatesToSwap:
		node.self_modulate = playerColor
