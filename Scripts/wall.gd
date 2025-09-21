extends Area2D

@export var direction: Vector2

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:

		var speed = 600

		body.set_new_velocity(direction * speed)
		print("Direction: ", direction)
		body.change_food(-20)
