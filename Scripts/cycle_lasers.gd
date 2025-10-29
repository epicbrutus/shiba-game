extends Node2D

@export var state_time: float = 1
@onready var state_timer: float = state_time

@onready var direction: int = pow(-1, Determinism.randi_range(0,1))
@onready var children: Array = get_children()

@onready var index: int = randi_range(0, children.size() - 1)

func _ready():
	set_states()

func _physics_process(delta: float) -> void:
	if state_timer <= 0:
		state_timer = state_time
		
		index = wrapi(index + direction, 0, children.size())
		set_states()
	else:
		state_timer -= delta

func set_states():
	for i in range(children.size()):
		if i == index:
			children[i].on_enter_cooldown()
		else:
			if i == wrapi(index + direction, 0, children.size()):
				pass #sumtin special
			children[i].on_enter_hold()