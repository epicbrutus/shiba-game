extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		var main_scene = ProjectSettings.get_setting("application/run/main_scene")
		get_tree().change_scene_to_file(main_scene)
