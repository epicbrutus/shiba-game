extends Node2D

@export var speed: float = 500

func _physics_process(delta: float) -> void:
    global_position += Vector2.RIGHT * delta * speed