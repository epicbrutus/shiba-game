extends Area2D

@onready var warning: Sprite2D = $WarningSprite2D

@export var warning_time: float = 1.5
@export var start_to_screen_time: float = -1

@onready var move_up: Node = $move_up

var damage: int = 20
static var bottomY: float = 290

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
		if global_position.y < warning_begin_pos(warning_time):
			warning.visible = true
			warning.global_position.y = bottomY
		else:
			warning.visible = false

func warning_begin_pos(p_time: float) -> float:
	return p_time * move_up.Def_Speed * move_up.multiplier
