@tool
extends laser_gate

@export var cycles: int = 1
var current_cycle: int = 1

@export var charge_up_time: float = 1
@export var hold_laser_time: float = 1
@export var cooldown_time: float = 0.1

@onready var charge_up_timer: float = charge_up_time
@onready var hold_laser_timer: float = hold_laser_time
@onready var cooldown_timer: float = cooldown_time

var bulb_offset: float = 30
var to_positions_speed: float = 1

var in_position: bool = false

func _ready():
	arrange_children()

	left_bulb.position.x -= bulb_offset
	right_bulb.position.x += bulb_offset

func _process(delta):
	if in_position:
		return

	left_bulb.position.x += delta * to_positions_speed
	right_bulb.position.x -= delta * to_positions_speed

	if right_bulb.position.x <= length/2:
		in_position = true


func _physics_process(delta: float) -> void:
	if current_cycle <= cycles && in_position:
		if charge_up_timer > 0:
			charge_up_timer -= delta
		elif hold_laser_timer > 0:

			if !body_entered.is_connected(_on_body_entered):
				body_entered.connect(_on_body_entered)

			hold_laser_timer -= delta
		else:
			body_entered.disconnect(_on_body_entered)


