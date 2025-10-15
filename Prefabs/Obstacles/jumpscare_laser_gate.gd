@tool
extends laser_gate

@export var cycles: int = 1
var current_cycle: int = 1

@export var charge_up_time: float = 1
@export var hold_laser_time: float = 1
@export var cooldown_time: float = 0.1

var phase_time_left: float = 1

var bulb_offset: float = 30
var to_positions_speed: float = 30

@onready var charging_thickness: float = thickness/3

var in_position: bool = false

func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
		return


	arrange_children()

	beam.visible = false

	left_bulb.position.x -= bulb_offset
	right_bulb.position.x += bulb_offset

func _process(delta):
	if in_position:
		return

	left_bulb.position.x += delta * to_positions_speed
	right_bulb.position.x -= delta * to_positions_speed

	if right_bulb.position.x <= length/2:
		in_position = true

enum Phase {COOLDOWN, CHARGE, HOLD}
var phase := Phase.COOLDOWN
var phase_entered := false

func _physics_process(delta: float) -> void:
	if current_cycle <= cycles && in_position:
		match phase:
			Phase.COOLDOWN:
				if !phase_entered:
					phase_entered = true
					on_enter_cooldown()
				phase_time_left -= delta
				if phase_time_left <= 0:
					phase = Phase.CHARGE
					phase_time_left = charge_up_time
					phase_entered = false

			Phase.CHARGE:
				if !phase_entered:
					phase_entered = true
					on_enter_charge()
				phase_time_left -= delta
				if phase_time_left <= 0:
					phase = Phase.HOLD
					phase_time_left = hold_laser_time
					phase_entered = false
			Phase.HOLD:
				if !phase_entered:
					phase_entered = true
					on_enter_hold()
				phase_time_left -= delta
				if phase_time_left <= 0:
					cycle_finished()
		
func on_enter_cooldown():
	beam.visible = false

func on_enter_charge():
	beam.visible = true
	beam.texture.width = charging_thickness

func on_enter_hold():
	beam.texture.width = thickness
	if !body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	for body in get_overlapping_bodies():
		_on_body_entered(body)

func cycle_finished():
	body_entered.disconnect(_on_body_entered)
	beam.visible = false
	current_cycle += 1

	phase_time_left = cooldown_time

	phase = Phase.COOLDOWN
	phase_entered = false

