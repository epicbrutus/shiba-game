extends Control

@export var info_box: RichTextLabel
@export var title_box: RichTextLabel

func _ready() -> void:
	if not title_box or not info_box:
		return

	for button in get_tree().get_nodes_in_group("info_buttons"):
		if button is Button and button.info_data:
			button.pressed.connect(_on_button_pressed.bind(button.info_data))

func _on_button_pressed(info_data: ButtonInfo):
	title_box.text = info_data.title
	info_box.text = info_data.body
	info_box.bbcode_enabled = true
	