extends Node2D

@export var spawn_cooldown: float = 1
@onready var spawn_timer: float = 0

@export var to_instantiate: PackedScene 
@export var direction: Vector2
@export var spawn_range: float = 0

var is_viewport: bool = true

func _process(delta):
	if spawn_timer <= 0:
		var instantiated := to_instantiate.instantiate()
		get_parent().add_child(instantiated)
		
		if spawn_range > 0:

			var xPos = randf_range(spawn_range * .1, spawn_range * 0.9)

			if direction.x != 0:
				instantiated.global_position = Vector2(global_position.x, xPos)
			elif direction.y != 0:
				instantiated.global_position = Vector2(xPos, global_position.y)
		else:
			instantiated.global_position = global_position

		spawn_timer = spawn_cooldown
	else:
		spawn_timer -= delta