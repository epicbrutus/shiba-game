extends Node2D
class_name Event

@export var event_ender: VisibleOnScreenNotifier2D

var _spawner: Node2D = null
var spawner: Node2D:
	get:
		if not is_instance_valid(_spawner):
			_spawner = get_tree().get_first_node_in_group("spawner")
		return _spawner
	set(value):
		_spawner = value

var cleanup_timer: SceneTreeTimer = null
var CLEANUP_DELAY := 0.5

var been_on_screen: bool = false
var event_over: bool = false

func _ready() -> void:
	if event_ender:
		event_ender.screen_entered.connect(_on_screen_entered)
		event_ender.screen_exited.connect(_on_screen_exited)

func _on_screen_entered() -> void:
	been_on_screen = true
	print("yah yah yah")

func _on_screen_exited() -> void:
	print("ageebada geeb")
	end_event()
	cleanup_timer = get_tree().create_timer(CLEANUP_DELAY)
	cleanup_timer.timeout.connect(_on_cleanup_timeout)

func _on_cleanup_timeout() -> void:
	cleanup_timer = null
	queue_free()

func end_event() -> void:
	event_over = true
	spawner.end_event()

func full_end_event():
	spawner.end_event()
	queue_free()
	