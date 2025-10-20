extends Node2D

const FoodScript = preload("res://Scripts//Food.gd")
@onready var game_state = get_tree().get_first_node_in_group("GameState")

@export var obstacle_configs: Array[ObstacleConfig] = []
@export var event_configs: Array[EventConfig] = []

@export var food: PackedScene
@export var gate: PackedScene

@onready var cam: Camera2D = get_viewport().get_camera_2d();

@export var distanceBar: TextureProgressBar

@export var counter_reference: RichTextLabel

var gateCooldown: float = 30
var gateTimer: float = gateCooldown
var mid_gate: bool = false

var foodCooldown: float = 0.5
var foodTimer: float = foodCooldown

var obstacleCooldown: float = 1.2
var obstacleTimer: float = obstacleCooldown
var obstacleCooldownIncrement: float = 0.1
var minObstacleCooldown: float = 0.5

var midEvent: bool = false
var eventCooldown: float = 5 #15
var eventTimer: float = eventCooldown

var midBoss: bool = false

var mid_event_bad_food_multiplier: float = 0.5

@onready var area_safe = cam.get_viewport_rect().size.x * 0.8 * 0.5

func _ready() -> void:
	randomize()
	print(area_safe)
	print(cam.get_viewport_rect().size)

func _process(delta: float) -> void:
	gate_loop(delta)
	food_loop(delta)
	obstacle_loop(delta)
	event_loop(delta)

	

func gate_loop(delta: float) -> void:
	if gateTimer <= 0:
		if !mid_gate:
			spawnGate()
			mid_gate = true
	else:
		gateTimer -= delta

		distanceBar.value = gateTimer/gateCooldown * 100

func food_loop(delta: float) -> void:
	foodTimer -= delta

	if foodTimer <= 0:
		foodTimer = foodCooldown;

		var instance = food.instantiate();
		instance.get_node("Area2D").initialize(get_random_food_type())
		add_child(instance);
		var spawnDistance: float = area_safe #(camera_width/2)*0.9;
		instance.position = Vector2(randf_range(-spawnDistance,spawnDistance), position.y);

func get_random_food_type() -> int:
	randf();
	var food_presets = FoodScript.food_presets

	var temp_weights: Dictionary = {}

	var total_chance = 0.0
	for key in food_presets.keys():
		var entry = food_presets[key]
		var weight: float = entry.chance

		if midEvent and key == FoodScript.FoodType.BAD:
			weight *= mid_event_bad_food_multiplier
		temp_weights[key] = weight
		total_chance += weight

	var r = randf() * total_chance
	var acc = 0.0
	for key in food_presets.keys():
		acc += temp_weights[key]
		if r < acc:
			return key
	return food_presets.keys()[-1]

func obstacle_loop(delta: float):
	if midEvent:
		return

	obstacleTimer -= delta

	if obstacleTimer <= 0:
		spawn_obstacle()
		obstacleTimer = calculateObstacleCountdown()

func event_loop(delta: float):
	if midEvent:
		return

	eventTimer -= delta

	if eventTimer <= 0:
		spawn_event()
		eventTimer = eventCooldown


func spawn_obstacle() -> void:

	var total_chance = 0
	for config in obstacle_configs:
		total_chance += config.chance

	var r = randf() * total_chance
	var acc = 0

	for config in obstacle_configs:
		acc += config.chance
		if r < acc:
			var w = area_safe #(camera_width/2)*0.9;

			w *= 1 - config.outerCushion

			var side: int = pow(-1, randi() % 2)
			var xPos: float = randf_range(w * config.innerCushion, w) * side


			var spawn_position := Vector2(xPos, position.y + config.negativeOffset)

			instantiate_obstacle(config, spawn_position)
			return

func instantiate_obstacle(config: ObstacleConfig, pos: Vector2) -> void:
	var obs = config.scene.instantiate()
	add_child(obs)
	obs.position = pos

func spawn_event() -> void:
	midEvent = true

	var total_chance = 0
	for config in event_configs:
		total_chance += config.chance

	var r = randf() * total_chance
	var acc = 0

	for config in event_configs:
		acc += config.chance
		if r < acc:
			var event = config.scene.instantiate()
			get_tree().current_scene.add_child(event)

			if config.isBoss:
				midBoss = true

			return

	print_debug("SPAWNED EVENT!!")
	

func end_event() -> void:
	midEvent = false
	eventTimer = eventCooldown
	obstacleCooldown = 0
	print_debug("ENDED EVENT!!")

func spawnGate() -> void:
	var instance = gate.instantiate()
	add_child(instance);
	instance.position = Vector2(position.x, 400)
	instance.get_node("Area2D").initialize(counter_reference)

func reset_gate_timer() -> void:
	gateTimer = gateCooldown
	mid_gate = false

func calculateObstacleCountdown() -> float:
	return maxf(obstacleCooldown - obstacleCooldownIncrement * (game_state.score - 1), minObstacleCooldown)
