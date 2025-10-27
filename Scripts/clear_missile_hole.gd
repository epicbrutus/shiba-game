extends Node

@export var gap_size: int = 3
@export var base_event: Node2D
@onready var children: Array = get_children()

func _ready():
	var remove_start: int = randi_range(0, children.size() - gap_size)

	for i in range(gap_size - 1, -1, -1):
		var idx := remove_start + i
		children[idx].queue_free()
		children.remove_at(idx)

	if children.size() > 0:
		var last_child_notifier = children.back().get_node("Cleanup")

		if base_event:
			base_event.event_ender = last_child_notifier
