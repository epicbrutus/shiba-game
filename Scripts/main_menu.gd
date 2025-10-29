extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Game.tscn")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Tutorial.tscn")


func _on_gummies_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gummies.tscn")


func _on_extras_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Extras_Menu.tscn")
