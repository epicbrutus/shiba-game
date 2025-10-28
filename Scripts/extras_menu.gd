extends Control

@export var info_box: RichTextLabel
@export var title_box: RichTextLabel
@export var preview_viewport: SubViewport

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
	set_preview(info_data)

func set_preview(info_data: ButtonInfo):
	for child in preview_viewport.get_children():
		child.queue_free()
	
	var the_preview := info_data.preview.instantiate()
	preview_viewport.add_child(the_preview)
	
