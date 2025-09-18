extends CharacterBody2D

enum MovementPreset {
	SKINNY,
	NORMAL,
	OVERWEIGHT,
	FAT,
	OBESE
}

class MovementData:
	var speed: float
	var friction: float
	var acceleration: float
	
	func _init(p_speed: float, p_friction: float, p_acceleration: float):
		speed = p_speed
		friction = p_friction
		acceleration = p_acceleration

var movement_presets = {
	MovementPreset.SKINNY: MovementData.new(400, 0, 2700),
	MovementPreset.NORMAL: MovementData.new(600, 0, 1800),
	MovementPreset.OVERWEIGHT: MovementData.new(800, 0, 1350),
	MovementPreset.FAT: MovementData.new(1000, 0.0, 800),
	MovementPreset.OBESE: MovementData.new(1200, 0.0, 400)
}

@export var current_preset: MovementPreset = MovementPreset.NORMAL

@export var speed: float = 300.0
@export var friction: float = 0.0
@export var acceleration: float = 1500.0

@export var weight_label: RichTextLabel
@export var charSprite: Sprite2D

@export var foodBar: TextureProgressBar

var photosPath: String = "res://Fat_Levels/"

var max_food: int = 80
var div_by: int = max_food/4
var food_eaten: int = 0

func _ready() -> void:
	# Assign the weight_label if not set via the editor
	if weight_label == null:
		# Change the path below to match your scene hierarchy
		weight_label = get_node_or_null("WeightLabel")

func getCurrentWeight() -> int:
	return current_preset

func change_food(amount: int) -> void:
	food_eaten = clamp(food_eaten + amount, 0, max_food)
	var to_change_to: MovementPreset = food_eaten / div_by
	set_movement_preset(to_change_to)
	if weight_label != null:
		weight_label.text = MovementPreset.keys()[to_change_to]

	if foodBar != null:
		foodBar.value = float(food_eaten) / float(max_food) * 100
	
	set_movement_preset(to_change_to)

func set_new_velocity(newVelocity: Vector2) -> void:
	velocity = newVelocity

func set_movement_preset(preset: MovementPreset) -> void:
	if preset in movement_presets:
		var data = movement_presets[preset]
		speed = data.speed
		friction = data.friction
		acceleration = data.acceleration
		current_preset = preset

		var presetName: String = MovementPreset.keys()[preset]
		charSprite.texture = load(photosPath + presetName + ".png")

func _physics_process(delta: float) -> void:
	var input_vector = get_input_vector()
	
	if input_vector != Vector2.ZERO:
		# Apply acceleration towards input direction
		velocity = velocity.move_toward(input_vector * speed, acceleration * delta)
	else:
		# Apply friction when no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
	if is_on_wall():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var normal = collision.get_normal()
			
			# Reduce velocity component along the normal
			velocity = velocity - normal * velocity.dot(normal)

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return input_vector.normalized()

func jumbo() -> void:
	pass