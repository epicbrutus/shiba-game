extends Node2D
class_name Event

var _event_ender: VisibleOnScreenNotifier2D
@export var event_ender: VisibleOnScreenNotifier2D:
	set(value):
		_event_ender = value
		if _event_ender and is_inside_tree():
			event_ender.screen_entered.connect(_on_screen_entered)
			event_ender.screen_exited.connect(_on_screen_exited)
			event_ender.tree_exited.connect(_on_screen_exited)
	get:
		return _event_ender


var _spawner: Node2D = null
var spawner: Node2D:
	get:
		if not is_instance_valid(_spawner):
			_spawner = Utils.get_spawner()
		return _spawner
	set(value):
		_spawner = value

var cleanup_timer: SceneTreeTimer = null
var CLEANUP_DELAY := 0.5

var been_on_screen: bool = false
var event_over: bool = false

func _ready() -> void:
	if event_ender and !event_ender.screen_entered.is_connected(_on_screen_entered):
		event_ender.screen_entered.connect(_on_screen_entered)
		event_ender.screen_exited.connect(_on_screen_exited)
		event_ender.tree_exited.connect(_on_screen_exited)

func _on_screen_entered() -> void:
	been_on_screen = true
	print("yah yah yah")

func _on_screen_exited() -> void:
	if !event_over:
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
	
