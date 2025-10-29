extends Node2D

@export var acceleration: float = 200
@export var speed: float = 100

var sign: int = 1

func _ready() -> void:
    sign = pow(-1, Determinism.randi_range(0,1))

    speed *= sign

    scale.x *= sign

func _physics_process(delta: float) -> void:
    speed += acceleration * delta * sign
    global_position += Vector2.RIGHT * delta * speed