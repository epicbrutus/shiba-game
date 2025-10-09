extends Sprite2D

var range: float = 5

@onready var savedPos: Vector2 = position

func _process(delta):
    position = Vector2(savedPos.x + randf_range(-range,range), savedPos.y + randf_range(-range,range))