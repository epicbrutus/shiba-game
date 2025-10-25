extends Node2D

@export var spawner: Node2D

func _ready():
    change_state(can_process())

func change_state(p_state: bool):
    if not spawner:
        return

    if p_state == true:
        process_mode = Node.PROCESS_MODE_INHERIT
        if "spawner" not in spawner.get_groups():
            add_to_group("spawner")
    else:
        process_mode = Node.PROCESS_MODE_DISABLED
        if "spawner" in spawner.get_groups():
            remove_from_group("spawner")