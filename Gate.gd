extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		if body.getCurrentWeight() >= 3:
			get_parent().queue_free()
		else:
			print("DIEEEE")


func _process(delta: float) -> void:
	get_parent().position.y -= 1800 * delta;