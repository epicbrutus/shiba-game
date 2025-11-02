extends Node

@onready var game_state = get_tree().get_first_node_in_group("GameState")
@onready var spawner = Utils.get_spawner()

@export var Def_Speed: float = 0
@export var acceleration: float = 0
@export var jerk: float = 0

@export var unique_direction: bool = false
@export var spec_direction: Vector2

var orientation_index: int = 0

var multipliers: Array[float] = [
	2,
	3,
	2,
	3
]

var multiplier: float = 2

var speed: float

func _ready() -> void:
	speed = Def_Speed

	if !game_state:
		return

	orientation_index = game_state.current_orientation
	_on_score_changed(game_state.score)

	if game_state.score_changed.is_connected(Callable(self, "_on_score_changed")):
		game_state.score_changed.disconnect(Callable(self, "_on_score_changed"))
	game_state.score_changed.connect(Callable(self, "_on_score_changed"))


func set_speed(p_speed: float):
	speed = p_speed

func _on_score_changed(value: int):
	multiplier = multipliers[orientation_index] + (value * 0.05) #* multipliers[orientation_index]

func _physics_process(delta: float) -> void:
	if !spawner:
		return
	
	var the_direction: Vector2 = spec_direction if unique_direction else spawner.direction


	# originally used position. Monitor for problems
	get_parent().global_position += speed * delta * multiplier * the_direction
	speed += acceleration * delta
	acceleration += jerk * delta
