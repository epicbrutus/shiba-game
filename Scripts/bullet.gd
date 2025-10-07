extends Area2D

var direction: Vector2
var initialized: bool = false
var speed: float = 900
var damage: float = 15

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func initialize(p_direction: Vector2) -> void:
	direction = p_direction
	initialized = true

func _physics_process(delta: float) -> void:
	if initialized:
		position += direction * delta * speed

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
		queue_free()