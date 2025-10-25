extends Sprite2D

func _ready() -> void:
	var parent = get_parent()
	if parent is Sprite2D:
		texture = parent.texture
		offset = parent.offset
		parent.texture_changed.connect(_on_sprite_2d_texture_changed)
	else:
		push_warning("Drop shadow on non-sprite!")

func _on_sprite_2d_texture_changed() -> void:
	texture = get_parent().texture
