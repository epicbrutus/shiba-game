extends Node

enum Mode { IDLE, RECORD, PLAYBACK }

var mode: Mode = Mode.IDLE
var frames: Array[Vector2] = []
var _frame_idx := 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	match mode:
		Mode.RECORD:
			frames.append(_sample_vector())
		Mode.PLAYBACK:
			if _frame_idx < frames.size() - 1:
				_frame_idx += 1

func _sample_vector() -> Vector2:
	var v := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	return v.normalized()

func get_vector() -> Vector2:
	if frames.is_empty():
		return Vector2.ZERO
	return frames[min(_frame_idx, frames.size() - 1)]

func start_recording() -> void:
	frames.clear()
	_frame_idx = 0
	mode = Mode.RECORD

func stop_recording() -> void:
	mode = Mode.IDLE

func start_playback() -> void:
	mode = Mode.PLAYBACK

func stop_playback() -> void:
	mode = Mode.IDLE

func save(path: String = "res://recordings/move_rec.json") -> void:
	var data: Array = []
	data.resize(frames.size())
	for i in frames.size():
		var v := frames[i]
		data[i] = [v.x, v.y]
	var fa := FileAccess.open(path, FileAccess.WRITE)
	if fa:
		fa.store_string(JSON.stringify({"frames":data}))
		fa.close()

func load(path: String = "res://recordings/move_rec.json") -> bool:
	var fa := FileAccess.open(path, FileAccess.READ)
	if not fa:
		return false
	var parsed: Variant = JSON.parse_string(fa.get_as_text())
	fa.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return false
	frames.clear()
	for a in parsed.get("frames", []):
		frames.append(Vector2(a[0], a[1]))
	_frame_idx = 0
	return true