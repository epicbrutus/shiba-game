extends Area2D

@onready var warning: Sprite2D = $WarningSprite2D

@onready var starting_pos: Vector2 = global_position
var new_pos_sumtin: Vector2

@export var warning_time: float = 1.5
@export var start_to_screen_time: float = -1

@export var speed: float = 2000

@onready var cam: Camera2D = get_viewport().get_camera_2d();

var direction: Vector2 = Vector2.UP

@onready var half_size := cam.get_viewport_rect().size * 0.5
@onready var edge_point := half_size * direction.normalized()

var damage: int = 20
@export var bottomY: float = 34

func _ready() -> void:
	body_entered.connect(_on_body_entered)


	if start_to_screen_time >= 0:
		global_position.y = warning_begin_pos(start_to_screen_time)
	else:
		global_position.y = warning_begin_pos(warning_time)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
		queue_free()

func _process(delta: float) -> void:

	if warning && global_position.y <= bottomY * 1.2:
		warning.queue_free()

	if warning:
		var swapped: Vector2 = starting_pos * Vector2(direction.y, direction.x)

		var warning_pos: Vector2 = edge_point + edge_point.normalized() * bottomY

		if global_position.y < warning_begin_pos(warning_time):
			warning.visible = true
			warning.global_position.y = bottomY
		else:
			warning.visible = false

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func warning_begin_pos(p_time: float) -> float:
	return p_time * speed
