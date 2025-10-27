extends Node2D

@export var hitbox: Area2D

func _ready():
    var go_direction: Vector2 =  Utils.get_spawner().direction
    rotation = go_direction.angle() + PI/2

    if hitbox:
        hitbox.direction = go_direction