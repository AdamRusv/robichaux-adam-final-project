extends MenuPanel

class_name CustomCPUMap

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
	var temporaryCPUSettings : CPUGameSettings = gameSelectionManager.temporaryCPUSettings
	match temporaryCPUSettings.mapLayout:
		CPUGameSettings.MapLayout.x7x7:
			layoutText.text = displayLayout10x10
			temporaryCPUSettings.mapLayout = CPUGameSettings.MapLayout.x10x10
		CPUGameSettings.MapLayout.x10x10:
			layoutText.text = displayLayout15x15
			temporaryCPUSettings.mapLayout = CPUGameSettings.MapLayout.x15x15
		CPUGameSettings.MapLayout.x15x15:
			layoutText.text = displayLayoutCustom
			temporaryCPUSettings.mapLayout = CPUGameSettings.MapLayout.custom
		CPUGameSettings.MapLayout.custom:
			layoutText.text = displayLayout7x7
			temporaryCPUSettings.mapLayout = CPUGameSettings.MapLayout.x7x7
func _change_holes():
	var temporaryCPUSettings : CPUGameSettings = gameSelectionManager.temporaryCPUSettings
	match temporaryCPUSettings.holePercent:
		CPUGameSettings.HolePercent.x5:
			holesText.text = displayHoles20
			temporaryCPUSettings.holePercent = CPUGameSettings.HolePercent.x20
		CPUGameSettings.HolePercent.x20:
			holesText.text = displayHoles35
			temporaryCPUSettings.holePercent = CPUGameSettings.HolePercent.x35
		CPUGameSettings.HolePercent.x35:
			holesText.text = displayHolesNone
			temporaryCPUSettings.holePercent = CPUGameSettings.HolePercent.none
		CPUGameSettings.HolePercent.none:
			holesText.text = displayHoles5
			temporaryCPUSettings.holePercent = CPUGameSettings.HolePercent.x5
func _change_stray_tiles():
	var temporaryCPUSettings : CPUGameSettings = gameSelectionManager.temporaryCPUSettings
	match temporaryCPUSettings.strayTiles:
		true:
			strayTilesText.text = displayStrayTileFalse
			temporaryCPUSettings.strayTiles = false
		false:
			strayTilesText.text = displayStrayTileTrue
			temporaryCPUSettings.strayTiles = true

#- - - - - - - -
func _open():
	gameSelectionManager.temporaryCPUSettings = CPUGameSettings.new()
	gameSelectionManager.temporaryCPUSettings.mapLayout = gameSelectionManager.currentCPUGameSettings.mapLayout
	gameSelectionManager.temporaryCPUSettings.holePercent = gameSelectionManager.currentCPUGameSettings.holePercent
	gameSelectionManager.temporaryCPUSettings.strayTiles = gameSelectionManager.currentCPUGameSettings.strayTiles
	_update()
func _update():
	match gameSelectionManager.currentCPUGameSettings.mapLayout:
		CPUGameSettings.MapLayout.x7x7:
			layoutText.text = displayLayout7x7
		CPUGameSettings.MapLayout.x10x10:
			layoutText.text = displayLayout10x10
		CPUGameSettings.MapLayout.x15x15:
			layoutText.text = displayLayout15x15
		CPUGameSettings.MapLayout.custom:
			layoutText.text = displayLayoutCustom
	
	match gameSelectionManager.currentCPUGameSettings.holePercent:
		CPUGameSettings.HolePercent.x5:
			holesText.text = displayHoles5
		CPUGameSettings.HolePercent.x20:
			holesText.text = displayHoles20
		CPUGameSettings.HolePercent.x35:
			holesText.text = displayHoles35
		CPUGameSettings.HolePercent.none:
			holesText.text = displayHolesNone
	
	match gameSelectionManager.currentCPUGameSettings.strayTiles:
		true:
			strayTilesText.text = displayStrayTileTrue
		false:
			strayTilesText.text = displayStrayTileFalse

func _apply():
	gameSelectionManager.currentCPUGameSettings.mapLayout = gameSelectionManager.temporaryCPUSettings.mapLayout
	gameSelectionManager.currentCPUGameSettings.holePercent = gameSelectionManager.temporaryCPUSettings.holePercent
	gameSelectionManager.currentCPUGameSettings.strayTiles = gameSelectionManager.temporaryCPUSettings.strayTiles
	
	await gameSelectionManager._apply_popup_menu()
	
	var mapLayoutPanelText : String = ""
	match gameSelectionManager.currentCPUGameSettings.mapLayout:
		CPUGameSettings.MapLayout.x7x7:
			mapLayoutPanelText = displayLayout7x7
		CPUGameSettings.MapLayout.x10x10:
			mapLayoutPanelText = displayLayout10x10
		CPUGameSettings.MapLayout.x15x15:
			mapLayoutPanelText = displayLayout15x15
		CPUGameSettings.MapLayout.custom:
			mapLayoutPanelText = displayLayoutCustom
	
	var holesPanelText : String = ""
	match gameSelectionManager.currentCPUGameSettings.holePercent:
		CPUGameSettings.HolePercent.x5:
			holesPanelText = displayHoles5
		CPUGameSettings.HolePercent.x20:
			holesPanelText = displayHoles20
		CPUGameSettings.HolePercent.x35:
			holesPanelText = displayHoles35
		CPUGameSettings.HolePercent.none:
			holesPanelText = displayHolesNone
	
	var strayTilesPanelText : String = ""
	match gameSelectionManager.currentCPUGameSettings.strayTiles:
		true:
			strayTilesPanelText = displayStrayTileTrue
		false:
			strayTilesPanelText = displayStrayTileFalse
	
	gameSelectionManager.mapCPUText.text = mapLayoutPanelText + " / " + holesPanelText + " / " + strayTilesPanelText
