extends Node2D

@export var event_configs: Array[EventConfig] = []

var eventCooldown: float = 4
var eventTimer: float = eventCooldown/3

func _process(delta: float) -> void:
	event_loop(delta)

func event_loop(delta: float):
	
	eventTimer -= delta

	if eventTimer <= 0:
		spawn_event()
		eventTimer = eventCooldown

func spawn_event() -> void:
	var total_chance = 0
	for config in event_configs:
		total_chance += config.chance

	var r = Determinism.randf() * total_chance
	var acc = 0

	for config in event_configs:
		acc += config.chance
		if r < acc:
			var event = config.scene.instantiate()
			get_tree().current_scene.add_child(event)
			event.add_to_group("obstacles")

			return

	print_debug("SPAWNED ATTACK!! (boss 1)")
