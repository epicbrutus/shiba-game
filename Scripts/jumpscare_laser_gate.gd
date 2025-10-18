@tool
extends laser_gate

@export var run_forever: bool = false
@export var cycles: int = 1
var current_cycle: int = 1

@export var charge_up_time: float = 1
@export var hold_laser_time: float = 1
@export var cooldown_time: float = 0.1

var phase_time_left: float = 1

@export var bulb_offset: float = 200
var to_positions_speed: float = 300

@onready var charging_thickness: float = thickness/3

var in_position: bool = false
var ending: bool = false
var paused: bool = false

var paused_cycles: Array[int]
var paused_checked: bool = false

func _ready():
	if Engine.is_editor_hint():
		set_process(false)
		set_physics_process(false)
		return


	arrange_children()

	beam.visible = false

	left_bulb.position.x -= bulb_offset
	right_bulb.position.x += bulb_offset

func set_cycles(p_cycles: int):
	cycles = p_cycles

func add_paused_cycle(paused_cycle: int):
	paused_cycles.append(paused_cycle)
	

func _process(delta):
	if ending:
		left_bulb.position.x -= delta * to_positions_speed
		right_bulb.position.x += delta * to_positions_speed

		if right_bulb.position.x >= length/2 + bulb_offset:
			queue_free()

	if in_position:
		return

	left_bulb.position.x += delta * to_positions_speed
	right_bulb.position.x -= delta * to_positions_speed

	if right_bulb.position.x <= length/2:
		right_bulb.position.x = length/2
		left_bulb.position.x = -length/2
		in_position = true

enum Phase {COOLDOWN, CHARGE, HOLD}
@export var phase : Phase = Phase.COOLDOWN
var phase_entered := false

func _physics_process(delta: float) -> void:
	if (in_position):
		if (current_cycle <= cycles || run_forever):

			if !paused_checked:
				for number in paused_cycles:
					if current_cycle == number: #make it so if it's always it repeats paused nums or sumthing (yknow)
						paused = true
				paused_checked = true

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
		elif !ending:
			end_laser()
	

func on_enter_cooldown():
	beam.visible = false

func on_enter_charge():
	if !paused:
		beam.visible = true
		beam.texture.width = charging_thickness

func on_enter_hold():
	if !paused:
		beam.texture.width = thickness
		if !body_entered.is_connected(_on_body_entered):
			body_entered.connect(_on_body_entered)
		for body in get_overlapping_bodies():
			_on_body_entered(body)

func cycle_finished():
	if body_entered.is_connected(_on_body_entered):
		body_entered.disconnect(_on_body_entered)
	beam.visible = false
	current_cycle += 1
	
	phase_time_left = cooldown_time

	paused = false
	paused_checked = false
	phase = Phase.COOLDOWN
	phase_entered = false

func end_laser():
	ending = true
