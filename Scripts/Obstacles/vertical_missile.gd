extends Area2D

@onready var warning: Sprite2D = $WarningSprite2D

@onready var starting_pos: Vector2 = global_position
var new_pos_sumtin: Vector2

@export var warning_time: float = 1.5
@export var start_to_screen_time: float = -1

@export var speed: float = 2000

@onready var cam: Camera2D = get_viewport().get_camera_2d();

@export var direction: Vector2

@onready var half_size := cam.get_viewport_rect().size * 0.5
var edge_point: Vector2

var damage: int = 20
@export var bottomY: float = 34


#uses the old starting_pos. Outdated but keeping for reference in case using updated global_pos brings updates.
var warning_pos: Vector2

func _ready() -> void:
	if direction == Vector2.ZERO:
		direction = Utils.get_spawner().direction
	edge_point = half_size * -direction.normalized()
	print("EDGE: " + str(edge_point))
	warning_pos = edge_point + direction * bottomY + (global_position * Vector2(direction.y, direction.x).abs())

	body_entered.connect(_on_body_entered)

	rotation = direction.angle() + PI/2

	print("rotation: " + str(rotation))

	print("Warning pos: " + str(warning_pos))
	print(str(starting_pos * Vector2(direction.y, direction.x)))
	print(str(starting_pos))

	if start_to_screen_time >= 0:
		global_position = start_to_screen_time * speed * -direction + warning_pos
	else:
		global_position = warning_time * speed * -direction + warning_pos

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
		queue_free()

func _process(delta: float) -> void:

	if warning && global_position.length() <= warning_pos.length() * 1.2:
		warning.queue_free()

	if warning:
		var swapped: Vector2 = global_position * Vector2(direction.y, direction.x).abs()

		warning_pos = edge_point + direction * bottomY + swapped #edge_point.normalized() for direction?
		#print(edge_point)

		if global_position.length() < warning_begin_pos(warning_time):
			warning.visible = true
			warning.global_position = warning_pos
		else:
			warning.visible = false

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	#print(global_position)

func warning_begin_pos(p_time: float) -> float:
	return (p_time * speed * -direction + warning_pos).length()
