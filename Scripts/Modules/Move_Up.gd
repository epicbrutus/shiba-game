extends Node

@onready var game_state = get_tree().get_first_node_in_group("GameState")
@onready var spawner = Utils.get_spawner()

@export var Def_Speed: float = 0
@export var acceleration: float = 0
@export var jerk: float = 0

var orientation_index: int = 0

var multipliers: Array[float] = [
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
	multiplier = multipliers[orientation_index]

	if game_state.score_changed.is_connected(Callable(self, "_on_score_changed")):
		game_state.score_changed.disconnect(Callable(self, "_on_score_changed"))
	game_state.score_changed.connect(Callable(self, "_on_score_changed"))


func set_speed(p_speed: float):
	speed = p_speed

func _on_score_changed(value: int):
	pass #multiplier = multipliers[orientation_index] + multipliers[orientation_index] * (value * 0.5)

func _physics_process(delta: float) -> void:
	get_parent().position += speed * delta * multiplier * spawner.direction
	speed += acceleration * delta
	acceleration += jerk * delta
