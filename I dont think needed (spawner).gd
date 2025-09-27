extends Node2D
const FoodScript = preload("res://Scripts//Food.gd")

@export var food: PackedScene;
@export var gate: PackedScene

@export var cam: Camera2D;

@export var distanceBar: TextureProgressBar

var gateCooldown: float = 20
var gateTimer: float = gateCooldown

var foodCooldown: float = 1
var foodTimer: float = foodCooldown

var obstacleCooldown: float = 2
var obstacleTimer: float = obstacleCooldown

func _process(delta: float) -> void:
	gate_loop(delta)
	food_loop(delta)

		

# func randomEnum() -> int:
# 	return Food.FoodType.DONUT if randf() < 0.5 else Food.FoodType.BROCOLLI

func gate_loop(delta: float) -> void:
	gateTimer -= delta

	distanceBar.value = gateTimer/gateCooldown * 100

	if gateTimer <= 0:
		spawnGate()
		gateTimer = gateCooldown

func food_loop(delta: float) -> void:
	foodTimer -= delta

	if foodTimer <= 0:
		foodTimer = foodCooldown;

		var instance = food.instantiate();
		instance.get_node("Area2D").initialize(get_random_food_type())
		add_child(instance);
		var camera_width = cam.get_viewport_rect().size.x;
		var spawnDistance: float = (camera_width/2)*0.9;
		instance.position = Vector2(randf_range(-spawnDistance,spawnDistance), position.y);

func get_random_food_type() -> int:
	randf();
	var food_presets = FoodScript.food_presets
	var total_chance = 0.0
	for key in food_presets.keys():
		total_chance += FoodScript.food_presets[key].chance

	var r = randf() * total_chance
	var acc = 0.0
	for key in food_presets.keys():
		acc += food_presets[key].chance
		if r < acc:
			return key
	return food_presets.keys()[-1]

func obstacle_loop(delta: float):
	obstacleTimer -= delta

	if obstacleTimer <= 0:
		pass

func spawnGate() -> void:
	var instance = gate.instantiate()
	add_child(instance);
	instance.position = Vector2(position.x, 400)
