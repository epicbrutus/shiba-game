extends Node2D

@onready var direction: int = pow(-1, randi() % 2)

func _ready():
    scale.x *= direction