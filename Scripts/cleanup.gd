extends VisibleOnScreenNotifier2D

var been_on_screen: bool = false
var cleanup_timer: SceneTreeTimer = null
@export var disabled := false
@export var CLEANUP_DELAY := 2

func _ready() -> void:
	if disabled:
		return
	screen_entered.connect(_on_screen_entered)
	screen_exited.connect(_on_screen_exited)

func _on_screen_entered() -> void:
	been_on_screen = true
	if cleanup_timer:
		cleanup_timer.timeout.disconnect(_on_cleanup_timeout)

func _on_screen_exited() -> void:
	if !been_on_screen:
		return

	if cleanup_timer:
		return

	cleanup_timer = get_tree().create_timer(CLEANUP_DELAY)
	cleanup_timer.timeout.connect(_on_cleanup_timeout)

func _on_cleanup_timeout() -> void:
	cleanup_timer = null
	#print_debug("DELETED: " +  str(get_parent().name))
	get_parent().queue_free()