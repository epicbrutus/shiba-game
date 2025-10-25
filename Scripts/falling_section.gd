extends Node2D

@export var spawner: Node2D

func change_state(p_state: bool):
    if p_state == true:
        process_mode = Node.PROCESS_MODE_DISABLED
    else:
        process_mode = Node.PROCESS_MODE_INHERIT
