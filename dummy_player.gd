extends "res://Scripts/CharacterBody2d.gd"

@export var auto_regen = true

@export var regen_cooldown_time: float = 2
var regen_cooldown_timer: float
@export var regen_amount: int = 20

func _ready() -> void:
	super._ready()
	regen_cooldown_timer = regen_cooldown_time

func get_input_vector() -> Vector2:
	return Vector2.ZERO

func _process(delta):
	super._process(delta)

	if regen_cooldown_timer <= 0:
		change_food(regen_amount, Vector2(-9999, -9999), false)
		regen_cooldown_timer = regen_cooldown_time
	else:
		regen_cooldown_timer -= delta