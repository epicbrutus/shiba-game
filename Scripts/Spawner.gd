extends Node2D

const FoodScript = preload("res://Scripts//Food.gd")
@onready var game_state = get_tree().get_first_node_in_group("GameState")

@export var obstacle_configs: Array[ObstacleConfig] = []
@export var event_configs: Array[EventConfig] = []
@export var boss_configs: Array[EventConfig] = []

@export var food: PackedScene
@export var gate: PackedScene

@onready var cam: Camera2D = get_viewport().get_camera_2d();

@export var distanceBar: TextureProgressBar

@export var counter_reference: RichTextLabel

@export var direction: Vector2 = Vector2.UP

@export var in_tutorial: bool = false

@export_group("Settings")
@export var gateCooldown: float = 30 #30
@export var gateTimer: float = 69420 #/3
var mid_gate: bool = false

@export var foodCooldown: float = 0.75
var foodTimer: float = foodCooldown

@export var obstacleCooldown: float = 1.25
var obstacleTimer: float = obstacleCooldown
@export var obstacleCooldownIncrement: float = 0.1
@export var minObstacleCooldown: float = 0.4

var midEvent: bool = false
@export var eventCooldown: float = 15 #15
var eventTimer: float = eventCooldown

var midBoss: bool = false
var currentBoss: Node2D

var mid_event_bad_food_multiplier: float = 0.5

var area_safe: float


func _ready() -> void:
	if gateTimer == 69420:
		gateTimer = gateCooldown
		
	foodTimer = foodCooldown
	obstacleTimer = obstacleCooldown
	eventTimer = eventCooldown
	#randomize()

	if direction.x != 0:
		area_safe = cam.get_viewport_rect().size.y * 0.7 * 0.5
	elif direction.y != 0:
		area_safe = cam.get_viewport_rect().size.x * 0.8 * 0.5
		

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
			if midBoss:
				currentBoss.gate_action()
			else:
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
		instance.position = get_spawn_pos()
func get_random_food_type() -> int:
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

	var r = Determinism.randf() * total_chance
	var acc = 0.0
	for key in food_presets.keys():
		acc += temp_weights[key]
		if r < acc:
			return key
	return food_presets.keys()[-1]

func obstacle_loop(delta: float):

	if midEvent || mid_gate || midBoss:
		#print("midEvent: " + str(midEvent) + "; mid_gate: " + str(mid_gate) + "; midBoss: " + str(midBoss))
		return

	obstacleTimer -= delta

	if obstacleTimer <= 0:
		spawn_obstacle()
		obstacleTimer = calculateObstacleCountdown()

func event_loop(delta: float):
	if midEvent || mid_gate || midBoss:
		return

	eventTimer -= delta

	if eventTimer <= 0:
		spawn_event()
		eventTimer = eventCooldown


func spawn_obstacle() -> void:

	var total_chance = 0
	for config in obstacle_configs:
		total_chance += config.chance

	var r = Determinism.randf() * total_chance
	var acc = 0

	for config in obstacle_configs:
		acc += config.chance
		if r < acc:

			var spawn_position: Vector2 = get_spawn_pos(config.innerCushion, config.outerCushion, config.negativeOffset)

			instantiate_obstacle(config, spawn_position)
			return

func get_spawn_pos(innerCushion: float = 0, outerCushion: float = 0, negativeOffset: float = 0) -> Vector2:
	var w = area_safe

	w *= 1 - outerCushion

	var side: int = pow(-1, Determinism.randi_range(0,1))
	var xPos: float = Determinism.randf_range(w * innerCushion, w) * side
	
	if direction.x != 0:
		return  Vector2(position.x - negativeOffset, -xPos)
	elif direction.y != 0:
		return Vector2(xPos, position.y + negativeOffset)

	return Vector2.ZERO

func instantiate_obstacle(config: ObstacleConfig, pos: Vector2) -> void:
	var obs = config.scene.instantiate()
	obs.position = pos
	add_child(obs)

	obs.add_to_group("obstacles")

func spawn_event(spawn_boss: bool = false):
	call_deferred("_spawn_event_impl", spawn_boss)

func _spawn_event_impl(spawn_boss: bool = false) -> void:

	var total_chance = 0


	var spawn_configs: Array

	if !spawn_boss:
		spawn_configs = event_configs
	else:
		spawn_configs = boss_configs

	for config in spawn_configs:
		total_chance += config.chance

	var r = Determinism.randf() * total_chance
	var acc = 0

	for config in spawn_configs:
		acc += config.chance
		if r < acc:
			var event = config.scene.instantiate()
			get_tree().current_scene.add_child(event)

			if spawn_boss:
				midBoss = true
				currentBoss = event
				get_tree().call_group("events", "queue_free")
			else:
				midEvent = true
				event.add_to_group("events")

			return

	print_debug("SPAWNED EVENT!!")
	

func end_event() -> void:
	midEvent = false
	eventTimer = eventCooldown
	obstacleTimer = 0
	print_debug("ENDED EVENT!!")

func spawnGate() -> void:
	var instance = gate.instantiate()
	add_child(instance);
	instance.position = direction * -400
	instance.get_node("Area2D").initialize(counter_reference)

func reset_gate_timer() -> void:
	gateTimer = gateCooldown
	mid_gate = false
	
	midBoss = false
	midEvent = false
	currentBoss = null
	print("Waht thate aofnie")

	get_tree().call_group("obstacles", "queue_free")

func calculateObstacleCountdown() -> float:
	print("gumble")
	print(maxf(obstacleCooldown - obstacleCooldownIncrement * (game_state.score - 1), minObstacleCooldown))
	return maxf(obstacleCooldown - obstacleCooldownIncrement * (game_state.score - 1), minObstacleCooldown)
