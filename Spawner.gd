extends Node2D
const Food = preload("res://Food.gd")

@export var food: PackedScene;
@export var cam: Camera2D;

var timeLeft: float = 2;

func _process(delta: float) -> void:
	timeLeft -= delta;

	if timeLeft <= 0:
		timeLeft = 0.4;

		var instance = food.instantiate();
		instance.get_node("Area2D").initialize(randomEnum())
		add_child(instance);
		var camera_width = cam.get_viewport_rect().size.x;
		var spawnDistance: float = (camera_width/2)*0.9;
		instance.position = Vector2(randf_range(-spawnDistance,spawnDistance), position.y);

func randomEnum() -> int:
	return Food.FoodType.DONUT if randf() < 0.5 else Food.FoodType.BROCOLLI
