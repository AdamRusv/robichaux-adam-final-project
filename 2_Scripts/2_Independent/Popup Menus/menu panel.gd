extends Control

class_name MenuPanel

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

#-
func _setup_button_hover_connections(newButton : Button, newText : RichTextLabel):
	newButton.mouse_entered.connect(_set_color_of_text_hovered.bind(newText))
	newButton.mouse_exited.connect(_set_color_of_text_exited.bind(newText))
func _set_color_of_text_hovered(newText : RichTextLabel):
	newText.add_theme_color_override("default_color", Color(0, 1, 1))
func _set_color_of_text_exited(newText : RichTextLabel):
	newText.add_theme_color_override("default_color", Color(0.0, 0.0, 0.0, 1.0))
