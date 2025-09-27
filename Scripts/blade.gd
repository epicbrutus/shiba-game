extends Area2D

var damage: int = 20

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)

func _physics_process(delta: float) -> void:
	rotation += 3 * delta
