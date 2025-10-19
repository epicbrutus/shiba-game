extends Area2D

var damage: int = 20

var normal_speed: float = 300
var turn_speed: float = 1.75

var speed: float

var LIFESPAN: float = 5
@onready var lifeLeft: float = LIFESPAN

var fly_in_time: float = 1.5
var fly_in_timer: float = 0
var fly_in_speed: float = 50

# var accel_time: float = 0.5
# var accel_timer: float = 0.5

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

func initialize(p_rotation: float, fly_in: bool):
	rotation = p_rotation - PI/2 #probably not right
	if fly_in:
		fly_in_timer = fly_in_time
		# accel_timer = 0
	



func _physics_process(delta: float) -> void:
	var target := player

	if target == null:
		return

	if fly_in_timer > 0:
		speed = lerp(fly_in_speed, normal_speed, (fly_in_time - fly_in_timer) / fly_in_time)
		fly_in_timer -= delta
	else:

		# if accel_timer < accel_time:
		# 	accel_timer += delta

		speed = normal_speed

		var desired_angle := (target.global_position - global_position).angle()
		var angle_diff := wrapf(desired_angle - rotation, -PI, PI)
		rotation += clamp(angle_diff, -turn_speed * delta, turn_speed * delta)

		lifeLeft -= delta

		if lifeLeft <= 0:
			queue_free()

	var forward := Vector2.RIGHT.rotated(rotation)
	global_position += forward * speed * delta	

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
		queue_free()
