extends Node

var _rng := RandomNumberGenerator.new()
var _seed: int = 0
var _streams := {}

func set_seed(seed: int) -> void:
    _seed = int(seed)
    _rng.seed = _seed
    _streams.clear()

func get_seed() -> int:
    return _seed

func randf() -> float: return _rng.randf()
func randi() -> int: return _rng.randi()
func randf_range(a:float, b: float) -> float: return _rng.randf_range(a, b)
func randi_range(a: int, b: int) -> int: return _rng.randi_range(a, b)

func choose(arr: Array):
    if arr.is_empty(): return null
    return arr[randi_range(0, arr.size() - 1)]

func get_rng(stream: String) -> RandomNumberGenerator:
    if not _streams.has(stream):
        var r := RandomNumberGenerator.new()

        r.seed = int(_seed ^ hash(stream))
        _streams[stream] = r

    return _streams[stream]