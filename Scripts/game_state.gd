extends Node
class_name GameState

@onready var spawner = get_tree().get_first_node_in_group("spawner")

signal score_changed(value: int)

var _score: int = 1
var score: int:
    get: return _score
    set(value):
        if _score == value: return
        _score = value
        score_changed.emit(_score)
        if value % 3 == 0:
            spawner.spawn_event(true)

func add_score(amount: int = 1) -> void:
    score += amount