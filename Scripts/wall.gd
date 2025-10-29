extends Area2D

@export var direction: Vector2
@export var speed: float = 600
@export var damage: int = 10
@export var play_sound: bool = true

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:


		body.set_new_velocity(direction * speed, play_sound)
		print("Direction: ", direction)
		body.change_food(-damage)
