extends Control

class_name CustomCPUDifficultyAndColor

@export_category("References")
@export var gameSelectionManager : GameSelectionManager
@export var cpuDifficultyPopupDifficultyButton : Button
@export var cpuDifficultyPopupDifficultyText : RichTextLabel
@export var cpuDifficultyPopupColorButton : Button
@export var cpuDifficultyPopupColorText : RichTextLabel
@export var cpuDifficultyPopupApplyButton : Button
@export var cpuDifficultyPopupApplyText : RichTextLabel
@export var cpuDifficultyPopupReturnButton : Button
@export var cpuDifficultyPopupReturnTexture : TextureRect

func _ready():
	_set_connections()
func _set_connections():
	_popup_setup_button_hover_connections(cpuDifficultyPopupDifficultyButton, cpuDifficultyPopupDifficultyText)
	cpuDifficultyPopupDifficultyButton.pressed.connect(_change_cpu_difficulty)
	
	_popup_setup_button_hover_connections(cpuDifficultyPopupColorButton, cpuDifficultyPopupColorText)
	cpuDifficultyPopupColorButton.pressed.connect(_change_cpu_color)
	
	_popup_setup_button_hover_connections(cpuDifficultyPopupApplyButton, cpuDifficultyPopupApplyText)
	cpuDifficultyPopupApplyButton.pressed.connect(_apply_cpu_difficulty)
	
	_texture_popup_setup_button_hover_connections(cpuDifficultyPopupReturnButton, cpuDifficultyPopupReturnTexture)
	cpuDifficultyPopupReturnButton.pressed.connect(gameSelectionManager._close_popup_menu)

func _change_cpu_difficulty():
	var temporaryCPUSettings : CPUGameSettings = gameSelectionManager.temporaryCPUSettings
	match temporaryCPUSettings.difficulty:
		CPUGameSettings.Difficulty.easy:
			cpuDifficultyPopupDifficultyText.text = "Medium"
			temporaryCPUSettings.difficulty = CPUGameSettings.Difficulty.medium
		CPUGameSettings.Difficulty.medium:
			cpuDifficultyPopupDifficultyText.text = "Hard"
			temporaryCPUSettings.difficulty = CPUGameSettings.Difficulty.hard
		CPUGameSettings.Difficulty.hard:
			cpuDifficultyPopupDifficultyText.text = "Easy"
			temporaryCPUSettings.difficulty = CPUGameSettings.Difficulty.easy
func _change_cpu_color():
	var temporaryCPUSettings : CPUGameSettings = gameSelectionManager.temporaryCPUSettings
	match temporaryCPUSettings.cpuColor:
		CPUGameSettings.CPUColor.blue:
			cpuDifficultyPopupColorText.text = "Red"
			temporaryCPUSettings.cpuColor = CPUGameSettings.CPUColor.red
		CPUGameSettings.CPUColor.red:
			cpuDifficultyPopupColorText.text = "Random"
			temporaryCPUSettings.cpuColor = CPUGameSettings.CPUColor.random
		CPUGameSettings.CPUColor.random:
			cpuDifficultyPopupColorText.text = "Blue"
			temporaryCPUSettings.cpuColor = CPUGameSettings.CPUColor.blue

#- - - - - - - -
func _open_cpu_difficulty():
	gameSelectionManager.temporaryCPUSettings = CPUGameSettings.new()
	gameSelectionManager.temporaryCPUSettings.difficulty = gameSelectionManager.currentCPUGameSettings.difficulty
	gameSelectionManager.temporaryCPUSettings.cpuColor = gameSelectionManager.currentCPUGameSettings.cpuColor
	_update_cpu()
func _update_cpu():
	match gameSelectionManager.currentCPUGameSettings.difficulty:
		CPUGameSettings.Difficulty.easy:
			cpuDifficultyPopupDifficultyText.text = "Easy"
		CPUGameSettings.Difficulty.medium:
			cpuDifficultyPopupDifficultyText.text = "Medium"
		CPUGameSettings.Difficulty.hard:
			cpuDifficultyPopupDifficultyText.text = "Hard"
	
	match gameSelectionManager.currentCPUGameSettings.cpuColor:
		CPUGameSettings.CPUColor.blue:
			cpuDifficultyPopupColorText.text = "Blue"
		CPUGameSettings.CPUColor.red:
			cpuDifficultyPopupColorText.text = "Red"
		CPUGameSettings.CPUColor.random:
			cpuDifficultyPopupColorText.text = "Random"

func _apply_cpu_difficulty():
	gameSelectionManager.currentCPUGameSettings.difficulty = gameSelectionManager.temporaryCPUSettings.difficulty
	gameSelectionManager.currentCPUGameSettings.cpuColor = gameSelectionManager.temporaryCPUSettings.cpuColor
	
	await gameSelectionManager._apply_popup_menu()
	
	var difficultyText : String = ""
	match gameSelectionManager.currentCPUGameSettings.difficulty:
		CPUGameSettings.Difficulty.easy:
			difficultyText = "Easy"
		CPUGameSettings.Difficulty.medium:
			difficultyText = "Medium"
		CPUGameSettings.Difficulty.hard:
			difficultyText = "Hard"
	
	var colorText : String = ""
	match gameSelectionManager.currentCPUGameSettings.cpuColor:
		CPUGameSettings.CPUColor.blue:
			colorText = "Blue"
		CPUGameSettings.CPUColor.red:
			colorText = "Red"
		CPUGameSettings.CPUColor.random:
			colorText = "Random"
	
	gameSelectionManager.cpuText.text = difficultyText + " / " + colorText

#----------------------------
func _popup_setup_button_hover_connections(newButton : Button, newText : RichTextLabel):
	newButton.mouse_entered.connect(_popup_set_color_of_text_hovered.bind(newText))
	newButton.mouse_exited.connect(_popup_set_color_of_text_exited.bind(newText))
func _popup_set_color_of_text_hovered(newText : RichTextLabel):
	newText.add_theme_color_override("default_color", Color(0, 1, 1))
func _popup_set_color_of_text_exited(newText : RichTextLabel):
	newText.add_theme_color_override("default_color", Color(0.0, 0.196, 0.0, 1.0))
func _texture_popup_setup_button_hover_connections(newButton : Button, newText : TextureRect):
	newButton.mouse_entered.connect(_texture_popup_set_color_of_texture_hovered.bind(newText))
	newButton.mouse_exited.connect(_texture_popup_set_color_of_texture_exited.bind(newText))
func _texture_popup_set_color_of_texture_hovered(newTexture : TextureRect):
	newTexture.self_modulate = Color(0, 1, 1)
func _texture_popup_set_color_of_texture_exited(newTexture : TextureRect):
	newTexture.self_modulate = Color(0.0, 0.196, 0.0, 1.0)
