extends Node
class_name GameState

signal score_changed(value: int)

var _score: int = 1
var score: int:
    get: return _score
    set(value):
        if _score == value: return
        _score = value
        score_changed.emit(_score)

func add_score(amount: int = 1) -> void:
    score += amount