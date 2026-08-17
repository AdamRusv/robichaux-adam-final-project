extends MenuPanel

class_name ViewDeckPopup

@export_category("References")
@export var gameSelectionManager : GameSelectionManager
@export var headerText : RichTextLabel
@export var closeButton : Button
@export var closeText : RichTextLabel
@export var gridParent : GridContainer
@export_group("Edit Deck")
@export var editDeckParent : Control
@export var editCloseButton : Button
@export var editCloseText : RichTextLabel

var tileValueRef : PackedScene = preload("res://1_Scenes/1_Objects/view deck tile value.tscn")

func _ready():
	_set_connections()
func _set_connections():
	_popup_setup_button_hover_connections(closeButton, closeText)
	closeButton.pressed.connect(PopupMenuManager._secondary_close_popup_menu)
	
	_popup_setup_button_hover_connections(editCloseButton, editCloseText)
	editCloseButton.pressed.connect(PopupMenuManager._secondary_close_popup_menu)
	#closeButton.pressed.connect(_clear)

func _set_up(deckName : String, newDeck : Deck):
	if newDeck == null:
		return
	_clear()
	_set_title(deckName)
	_fill_grid(newDeck)

func _open_menu(newDeck : Deck):
	if newDeck.deck.size() == 3:
		PopupMenuManager._secondary_open_popup_menu(editDeckParent)
	else:
		PopupMenuManager._secondary_open_popup_menu(self)

#
func _set_title(deckName : String):
	headerText.text = "- Viewing Deck  \"" + deckName + "\" -"

func _fill_grid(newDeck : Deck):
	for value in newDeck.deck:
		var newTileValue : Control = tileValueRef.instantiate()
		newTileValue.get_child(0).text = str(value)
		gridParent.add_child(newTileValue)

#--
func _clear():
	for child in gridParent.get_children():
		child.queue_free()
