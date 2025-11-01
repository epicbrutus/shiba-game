extends Node2D

@export var homing_missile_prefab: PackedScene

@export var num_missiles: int = 3
var missiles_fired: int = 0

var time_between_missiles: float = 0.15
var timer: float = time_between_missiles


func _physics_process(delta: float) -> void:
	if missiles_fired < num_missiles:
		if timer <= 0:

			if homing_missile_prefab:
				var missile = homing_missile_prefab.instantiate()
				
				if get_viewport() is SubViewport:
					get_parent().get_parent().add_child(missile)
				else:
					get_tree().current_scene.add_child(missile)

				missile.global_position = global_position
				missile.add_to_group("obstacles")
				
				var rand_angle: float = rotation + Determinism.randf_range(-PI/3, PI/3)

				missile.initialize(rand_angle, true)

			missiles_fired += 1
			timer = time_between_missiles
		else:
			timer -= delta
	else:
		get_parent().queue_free()
