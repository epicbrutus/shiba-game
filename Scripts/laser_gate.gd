extends Area2D

var damage: int = 20

static var MIN_LENGTH: int = 300
static var MAX_LENGTH: int = 600

var length: int
var thickness: int = 30

@onready var left_bulb: Sprite2D = $left_bulb
@onready var right_bulb: Sprite2D = $right_bulb

@onready var beam: Sprite2D = $beam

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	length = randi_range(MIN_LENGTH, MAX_LENGTH)
	rotation = deg_to_rad(randi_range(-45, 45))


	left_bulb.position.x = -length/2
	right_bulb.position.x = length/2

	beam.texture = beam.texture.duplicate()
	beam.texture.width = thickness
	beam.texture.height = length

	var rect_shape = RectangleShape2D.new()
	rect_shape.size = Vector2(length, thickness)
	collision_shape.shape = rect_shape

	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		body.change_food(-damage)
