extends Node

@export var recording = false

func _ready():
    if recording:
        RecordInputs.start_recording()
    elif RecordInputs.load():
        RecordInputs.start_playback()