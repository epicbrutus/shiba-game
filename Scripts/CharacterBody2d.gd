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
	MovementPreset.SKINNY: MovementData.new(600, 0, 3600),
	MovementPreset.NORMAL: MovementData.new(800, 0, 2700),
	MovementPreset.OVERWEIGHT: MovementData.new(1000, 0, 1800),
	MovementPreset.FAT: MovementData.new(1200, 0.0, 1350),
	MovementPreset.OBESE: MovementData.new(1400, 0.0, 800)
}

@export var current_preset: MovementPreset = MovementPreset.NORMAL

@export var speed: float = 300.0
@export var friction: float = 0.0
@export var acceleration: float = 1500.0

@export var weight_label: RichTextLabel
@export var charSprite: Sprite2D
@export var headPivot: Node2D

var EAT_ANIM_DURATION: float = 0.5
var eatAnimTime: float = 0

@onready var state_increase_sound: AudioStreamPlayer = $state_increase_sound
@onready var state_decrease_sound: AudioStreamPlayer = $state_decrease_sound
@onready var eat_sound: AudioStreamPlayer = $eat_sound
@onready var bounce_sound: AudioStreamPlayer = $bounce_sound

@export var foodBar: TextureProgressBar

var photosPath: String = "res://Fat_Levels/"

var max_food: int = 80
var div_by: int = max_food/4
var food_eaten: int = 0

func _ready() -> void:
	# Assign the weight_label if not set via the editor
	change_food(0)
	if weight_label == null:
		# Change the path below to match your scene hierarchy
		weight_label = get_node_or_null("WeightLabel")

func getCurrentWeight() -> int:
	return current_preset

func change_food(amount: int, pos: Vector2 = Vector2(-9999, -9999)) -> void:
	food_eaten = clamp(food_eaten + amount, 0, max_food)
	var to_change_to: MovementPreset = food_eaten / div_by
	set_movement_preset(to_change_to)

	if pos.x != -9999:
		eat_sound.play()
		eatAnimTime = EAT_ANIM_DURATION

		var direction = (pos - headPivot.global_position).normalized()
		headPivot.rotation = direction.angle()
		
		headPivot.scale = Vector2(1.2,1.2)

		if headPivot.rotation < -PI/2 || headPivot.rotation > PI/2:
			headPivot.scale.y = -1.2
		

	if weight_label != null:
		weight_label.text = MovementPreset.keys()[to_change_to]

	if foodBar != null:
		foodBar.value = float(food_eaten) / float(max_food) * 100
	
	set_movement_preset(to_change_to)

func set_new_velocity(newVelocity: Vector2) -> void:
	velocity = newVelocity
	bounce_sound.play()

func set_movement_preset(preset: MovementPreset) -> void:

	if preset in movement_presets:
		if current_preset < preset:
			state_increase_sound.play()
			state_increase_sound.seek(0.3)
		elif current_preset > preset:
			state_decrease_sound.play()
			state_decrease_sound.seek(0.3)

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

var head_pivot_timer := 0.0
var head_pivot_interval := 0.04 # seconds between rotations
var target_head_rotation := 0.0
var head_lerp_time := 0.04
var head_lerp_timer := 0.0

func _process(delta: float) -> void:
	if (eatAnimTime <= 0):
		headPivot.scale = Vector2(1,1)

		head_pivot_timer += delta
		head_lerp_timer += delta

		if head_pivot_timer >= head_pivot_interval:
			target_head_rotation = deg_to_rad(randf_range(-90, -75))
			head_pivot_timer = 0.0
			head_lerp_timer = 0.0

		if head_lerp_timer < head_lerp_time:
			headPivot.rotation = lerp_angle(headPivot.rotation, target_head_rotation, head_lerp_timer / head_lerp_time)
		else:
			headPivot.rotation = target_head_rotation
	else:
		eatAnimTime -= delta

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	return input_vector.normalized()

func jumbo() -> void:
	pass