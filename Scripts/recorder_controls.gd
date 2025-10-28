extends Node

func _unhandled_input(e: InputEvent) -> void:
    if e.is_action_pressed("ui_page_up"):
        RecordInputs.start_recording()
    elif e.is_action_pressed("ui_page_down"):
        RecordInputs.stop_recording()
        RecordInputs.save_to_file()

    elif e.is_action_pressed("ui_home"):
        if RecordInputs.load_from_file():
            RecordInputs.start_playback()
    elif e.is_action_pressed("ui_end"):
        RecordInputs.stop_playback()