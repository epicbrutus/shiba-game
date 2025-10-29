extends Area2D

var damage: int = 15
@export var spin_direction: int = 1
@export var spin_direction_locked: bool = false

@onready var left_blade: Sprite2D = $Left_Blade
@onready var right_blade: Sprite2D = $Right_Blade

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	if !spin_direction_locked:
		spin_direction = pow(-1, Determinism.randi_range(0,1))

	if spin_direction < 0:
		left_blade.scale.y *= -1
		right_blade.scale.y *= -1

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)

func _physics_process(delta: float) -> void:
	rotation += -3 * delta * spin_direction
