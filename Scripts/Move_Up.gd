extends Node

@export var Def_Speed: float = 0
static var multiplier: float = 2

var speed: float

func _ready() -> void:
	speed = Def_Speed

func set_speed(p_speed: float):
	speed = p_speed

func _physics_process(delta: float) -> void:
	get_parent().position.y -= speed * delta * multiplier
