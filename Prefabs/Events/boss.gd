extends Event

@export var gate: Area2D
@export var boss_logic: Node2D

func gate_action():
	gate.activate()

func end_event() -> void:
	super.end_event()
	boss_logic.queue_free()

