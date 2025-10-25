extends Node
class_name GameState


var boss_every: int = 3

signal score_changed(value: int)

var _score: int = 1
var score: int:
    get: return _score
    set(value):
        if _score == value: return
        _score = value
        score_changed.emit(_score)
        if value % boss_every == 0:
            Utils.get_spawner().spawn_event(true)

func add_score(amount: int = 1) -> void:
    score += amount