extends Area2D

var value: int;

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		var direction = (body.global_position - global_position).normalized();
		var speed = 600

		body.set_new_velocity(direction * speed);

func _process(delta: float) -> void:
	position.y -= 0 * delta;
