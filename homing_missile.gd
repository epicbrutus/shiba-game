extends Area2D

var damage: int = 20

var speed: float = 300
var turn_speed: float = 2

@export var target: CharacterBody2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	var direction_to_target = (target.global_position - global_position).normalized()

	var current_direction = Vector2.RIGHT.rotated(rotation)

	var new_direction = current_direction.lerp(direction_to_target, turn_speed * delta)

	rotation = new_direction.angle()
	global_position += new_direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
		queue_free()
