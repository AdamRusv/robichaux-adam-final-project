extends MenuPanel

class_name LocalMap

@export_category("References")
@export var gameSelectionManager : GameSelectionManager
@export var layoutButton : Button
@export var layoutText : RichTextLabel
@export var holesButton : Button
@export var holesText : RichTextLabel
@export var strayTilesButton : Button
@export var strayTilesText : RichTextLabel
@export var applyButton : Button
@export var applyText : RichTextLabel
@export var returnButton : Button
@export var returnTexture : TextureRect

var displayLayout7x7 : String = "7 x 7"
var displayLayout10x10 : String = "10 x 10"
var displayLayout15x15 : String = "15 x 15"
var displayLayoutCustom : String = "Custom"

var displayHoles5 : String = "5%"
var displayHoles20 : String = "20%"
var displayHoles35 : String = "35%"
var displayHolesNone : String = "None"

var displayStrayTileTrue : String = "On"
var displayStrayTileFalse : String = "Off"

func _ready():
	_set_connections()
func _set_connections():
	_popup_setup_button_hover_connections(layoutButton, layoutText)
	layoutButton.pressed.connect(_change_layout)
	
	_popup_setup_button_hover_connections(holesButton, holesText)
	holesButton.pressed.connect(_change_holes)
	
	_popup_setup_button_hover_connections(strayTilesButton, strayTilesText)
	strayTilesButton.pressed.connect(_change_stray_tiles)
	
	_popup_setup_button_hover_connections(applyButton, applyText)
	applyButton.pressed.connect(_apply)
	
	_texture_popup_setup_button_hover_connections(returnButton, returnTexture)
	returnButton.pressed.connect(gameSelectionManager._close_popup_menu)

func _change_layout():
	var temporaryLocalSettings : LocalGameSettings = gameSelectionManager.temporaryLocalSettings
	match temporaryLocalSettings.mapLayout:
		LocalGameSettings.MapLayout.x7x7:
			layoutText.text = displayLayout10x10
			temporaryLocalSettings.mapLayout = LocalGameSettings.MapLayout.x10x10
		LocalGameSettings.MapLayout.x10x10:
			layoutText.text = displayLayout15x15
			temporaryLocalSettings.mapLayout = LocalGameSettings.MapLayout.x15x15
		LocalGameSettings.MapLayout.x15x15:
			layoutText.text = displayLayoutCustom
			temporaryLocalSettings.mapLayout = LocalGameSettings.MapLayout.custom
		LocalGameSettings.MapLayout.custom:
			layoutText.text = displayLayout7x7
			temporaryLocalSettings.mapLayout = LocalGameSettings.MapLayout.x7x7
func _change_holes():
	var temporaryLocalSettings : LocalGameSettings = gameSelectionManager.temporaryLocalSettings
	match temporaryLocalSettings.holePercent:
		LocalGameSettings.HolePercent.x5:
			holesText.text = displayHoles20
			temporaryLocalSettings.holePercent = LocalGameSettings.HolePercent.x20
		LocalGameSettings.HolePercent.x20:
			holesText.text = displayHoles35
			temporaryLocalSettings.holePercent = LocalGameSettings.HolePercent.x35
		LocalGameSettings.HolePercent.x35:
			holesText.text = displayHolesNone
			temporaryLocalSettings.holePercent = LocalGameSettings.HolePercent.none
		LocalGameSettings.HolePercent.none:
			holesText.text = displayHoles5
			temporaryLocalSettings.holePercent = LocalGameSettings.HolePercent.x5
func _change_stray_tiles():
	var temporaryLocalSettings : LocalGameSettings = gameSelectionManager.temporaryLocalSettings
	match temporaryLocalSettings.strayTiles:
		true:
			strayTilesText.text = displayStrayTileFalse
			temporaryLocalSettings.strayTiles = false
		false:
			strayTilesText.text = displayStrayTileTrue
			temporaryLocalSettings.strayTiles = true

#- - - - - - - -
func _open():
	gameSelectionManager.temporaryLocalSettings = LocalGameSettings.new()
	gameSelectionManager.temporaryLocalSettings.mapLayout = gameSelectionManager.currentLocalGameSettings.mapLayout
	gameSelectionManager.temporaryLocalSettings.holePercent = gameSelectionManager.currentLocalGameSettings.holePercent
	gameSelectionManager.temporaryLocalSettings.strayTiles = gameSelectionManager.currentLocalGameSettings.strayTiles
	_update()
func _update():
	match gameSelectionManager.currentLocalGameSettings.mapLayout:
		LocalGameSettings.MapLayout.x7x7:
			layoutText.text = displayLayout7x7
		LocalGameSettings.MapLayout.x10x10:
			layoutText.text = displayLayout10x10
		LocalGameSettings.MapLayout.x15x15:
			layoutText.text = displayLayout15x15
		LocalGameSettings.MapLayout.custom:
			layoutText.text = displayLayoutCustom
	
	match gameSelectionManager.currentLocalGameSettings.holePercent:
		LocalGameSettings.HolePercent.x5:
			holesText.text = displayHoles5
		LocalGameSettings.HolePercent.x20:
			holesText.text = displayHoles20
		LocalGameSettings.HolePercent.x35:
			holesText.text = displayHoles35
		LocalGameSettings.HolePercent.none:
			holesText.text = displayHolesNone
	
	match gameSelectionManager.currentLocalGameSettings.strayTiles:
		true:
			strayTilesText.text = displayStrayTileTrue
		false:
			strayTilesText.text = displayStrayTileFalse

func _apply():
	gameSelectionManager.currentLocalGameSettings.mapLayout = gameSelectionManager.temporaryLocalSettings.mapLayout
	gameSelectionManager.currentLocalGameSettings.holePercent = gameSelectionManager.temporaryLocalSettings.holePercent
	gameSelectionManager.currentLocalGameSettings.strayTiles = gameSelectionManager.temporaryLocalSettings.strayTiles
	
	await gameSelectionManager._apply_popup_menu()
	
	var mapLayoutPanelText : String = ""
	match gameSelectionManager.currentLocalGameSettings.mapLayout:
		LocalGameSettings.MapLayout.x7x7:
			mapLayoutPanelText = displayLayout7x7
		LocalGameSettings.MapLayout.x10x10:
			mapLayoutPanelText = displayLayout10x10
		LocalGameSettings.MapLayout.x15x15:
			mapLayoutPanelText = displayLayout15x15
		LocalGameSettings.MapLayout.custom:
			mapLayoutPanelText = displayLayoutCustom
	
	var holesPanelText : String = ""
	match gameSelectionManager.currentLocalGameSettings.holePercent:
		LocalGameSettings.HolePercent.x5:
			holesPanelText = displayHoles5
		LocalGameSettings.HolePercent.x20:
			holesPanelText = displayHoles20
		LocalGameSettings.HolePercent.x35:
			holesPanelText = displayHoles35
		LocalGameSettings.HolePercent.none:
			holesPanelText = displayHolesNone
	
	var strayTilesPanelText : String = ""
	match gameSelectionManager.currentLocalGameSettings.strayTiles:
		true:
			strayTilesPanelText = displayStrayTileTrue
		false:
			strayTilesPanelText = displayStrayTileFalse
	
	#gameSelectionManager.mapLocalText.text = mapLayoutPanelText + " / " + holesPanelText + " / " + strayTilesPanelText
	gameSelectionManager.mapLocalText.text = mapLayoutPanelText + " / " + holesPanelText
