extends Event

@export var gate: Area2D

func gate_action():
	gate.activate()
