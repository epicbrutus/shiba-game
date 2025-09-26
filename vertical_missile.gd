extends Area2D

@onready var warning: Sprite2D = $WarningSprite2D

var damage: int = 20
static var bottomY: float = 290

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
		queue_free()

func _process(delta: float) -> void:

	if warning && position.y <= bottomY * 1.2:
		warning.queue_free()

	if warning:
		warning.global_position.y = bottomY
