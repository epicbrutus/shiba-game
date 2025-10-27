extends RigidBody2D

@export var prefab_path: String

var saved_collision_layer: int = collision_layer
var saved_collision_mask: int = collision_mask

func _ready():
    disable_collisions()
    await get_tree().create_timer(0.2).timeout
    enable_collisions()

func disable_collisions():
    collision_layer = 0
    collision_mask = 0

func enable_collisions():
    collision_layer = saved_collision_layer
    collision_mask = saved_collision_mask