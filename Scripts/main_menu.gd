extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Game.tscn")


func _on_tutorial_pressed() -> void:
	pass # Replace with function body.


func _on_gummies_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Gummies.tscn")
