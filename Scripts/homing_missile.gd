extends Area2D

var damage: int = 20

var speed: float = 300
var turn_speed: float = 1

var LIFESPAN: float = 7
@onready var lifeLeft: float = LIFESPAN

var _player: Node2D = null
var player: Node2D:
	get:
		if not is_instance_valid(_player):
			_player = get_tree().get_first_node_in_group("player")
		return _player
	set(value):
		_player = value


func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	var target := player

	if target == null:
		return

	var direction_to_target = (target.global_position - global_position).normalized()

	var current_direction = Vector2.RIGHT.rotated(rotation)

	var new_direction = current_direction.lerp(direction_to_target, turn_speed * delta)

	rotation = new_direction.angle()
	global_position += new_direction * speed * delta

	lifeLeft -= delta

	if lifeLeft <= 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
		queue_free()
