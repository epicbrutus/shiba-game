extends Node
class_name GameState

var boss_every: int = 3
var num_orientations: int = 2

var current_orientation: int = 1

signal score_changed(value: int)
signal switch_orientation(value: int)

func _ready():
	call_deferred("to_defer")

var _score: int = 2
var score: int:
	get: return _score
	set(value):
		if _score == value: return
		_score = value
		score_changed.emit(_score)
		if value % boss_every == 0:
			Utils.get_spawner().spawn_event(true)
		elif (value - 1) % boss_every == 0:
			current_orientation = wrapi(current_orientation + 1, 0, num_orientations)
			switch_orientation.emit(current_orientation)

func add_score(amount: int = 1) -> void:
	score += amount

func to_defer():
	switch_orientation.emit(current_orientation)
