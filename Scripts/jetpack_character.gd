extends "res://Scripts/CharacterBody2d.gd"

func _ready():
	super._ready()
	movement_presets = {
	MovementPreset.SKINNY: MovementData.new(400, 0, 3600),
	MovementPreset.NORMAL: MovementData.new(800, 0, 2700),
	MovementPreset.OVERWEIGHT: MovementData.new(1000, 0, 1800),
	MovementPreset.FAT: MovementData.new(1200, 0.0, 1350),
	MovementPreset.OBESE: MovementData.new(1400, 0.0, 800)
	}

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	if Input.get_action_strength("move_up") > 0:
		input_vector = Vector2.UP
	else:
		input_vector = Vector2.DOWN
	
	
	return input_vector.normalized()
