extends Node2D

@onready var direction: int = pow(-1, Determinism.randi_range(0,1))

func _ready():
    scale.x *= direction