extends Control

class_name Tile

@export_category("References")
@export var visual : TextureRect
@export var valueText : RichTextLabel
@export var button : Button

@export_category("Settings")
@export var currentTeam : Team

var gridLocation : Vector2i = Vector2i.ZERO
var currentValue : int = 0

enum Team{
	none,
	player_one,
	player_two,
	other,
	hole
	}

func _setup_tile(newValue : int):
	currentValue = newValue
	valueText.text = str(currentValue)

#-----------
func _is_interactable() -> bool:
	if currentValue != 0 || currentTeam == Team.hole:
		return false
	return true
