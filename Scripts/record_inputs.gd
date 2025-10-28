extends Node
class_name MovementRecorder

enum Mode { IDLE, RECORD, PLAYBACK }

var mode: Mode = Mode.IDLE
var frames: Array[Vector2] = []
var _frame_idx := 0

func _ready() -> void:
    self.pause_mode = Node.PauseMode.PROCESS
