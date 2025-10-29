extends Node

@export var cycles: int = 1
@export var gap_size: int = 2
@onready var children: Array = get_children()

func _ready():
	for child in children:
		child.set_cycles(cycles)

	for i in range(cycles):
		var pause_start: int = Determinism.randi_range(0, children.size() - 1 - gap_size)

		for i2 in range(gap_size):
			children[pause_start + i2].add_paused_cycle(i + 1)

func _process(delta: float) -> void:
	if get_child_count() == 0:
		get_parent().full_end_event()