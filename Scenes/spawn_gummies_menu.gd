extends Control

@export var gummy_prefabs: Array[PackedScene]
@export var gummies: Node
@export var player: Node2D

var menu_open: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return


	if event.is_action_pressed("gummy_menu"):
		if menu_open:
			menu_open = false
		else:
			menu_open = true
		visible = menu_open

func _on_skinny_pressed() -> void:
	spawn_gummy(0)
	release_focus()

func _on_normal_pressed() -> void:
	spawn_gummy(1)
	release_focus()

func _on_overweight_pressed() -> void:
	spawn_gummy(2)
	release_focus()

func _on_fat_pressed() -> void:
	spawn_gummy(3)
	release_focus()

func _on_obese_pressed() -> void:
	spawn_gummy(4)
	release_focus()

func spawn_gummy(num: int):
	if !menu_open:
		return

	var gummy_scene: PackedScene = gummy_prefabs[num]
	var new_gummy = gummy_scene.instantiate()
	gummies.add_child(new_gummy)
	new_gummy.global_position = player.global_position
