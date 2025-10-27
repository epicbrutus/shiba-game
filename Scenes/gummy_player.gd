extends "res://Scripts/CharacterBody2d.gd"

@export var gummies: Node

var eaten_gummies: Array[String] = []

var eat_range: float = 100

func _ready():
	change_food(0)

func _unhandled_input(event: InputEvent) -> void:
	if not event.is_pressed():
		return


	if event.is_action_pressed("eat_gummy"):
		var gummy_list := gummies.get_children()
		if gummy_list.is_empty() || food_eaten >= max_food:
			return

		var closest_gummy: RigidBody2D = null
		var closest_distance: float = eat_range
		for gummy in gummy_list:
			if gummy.global_position.distance_to(global_position) < closest_distance:
				closest_gummy = gummy
				closest_distance = gummy.global_position.distance_to(global_position)
		
		if !closest_gummy:
			return

		print("Gummy scene path: ", closest_gummy.scene_file_path)
		print("Gummy prefab: ", closest_gummy.prefab_path)

		change_food(20, closest_gummy.global_position)
		eaten_gummies.append(closest_gummy.prefab_path)
		closest_gummy.queue_free()

	elif event.is_action_pressed("spit_gummy"):
		if eaten_gummies.is_empty():
			return
		
		var gummy_scene: PackedScene = load(eaten_gummies.back())
		var new_gummy = gummy_scene.instantiate()
		gummies.add_child(new_gummy)
		new_gummy.global_position = global_position + Vector2.DOWN * 30

		eaten_gummies.pop_back()
		change_food(-20, new_gummy.global_position, false)
