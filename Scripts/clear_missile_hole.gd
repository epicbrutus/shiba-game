extends Node

@export var gap_size: int = 3
@onready var children: Array = get_children()

func _ready():
	var remove_start: int = randi_range(0, children.size() - 1 - gap_size)

	for i in range(gap_size):
		children[remove_start + i].queue_free()
		print("CLEARED HOLE: " + children[remove_start + i].name)