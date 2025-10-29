extends Sprite2D

var range: float = 5
@onready var rng:= Determinism.get_rng("cosmetic")

@onready var savedPos: Vector2 = position

func _process(delta):
    position = Vector2(savedPos.x + rng.randf_range(-range,range), savedPos.y + rng.randf_range(-range,range))