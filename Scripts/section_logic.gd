extends Node2D

@export var spawner: Node2D
@export var orientation_index: int = 0

func _ready():
    var game_state = get_tree().get_first_node_in_group("GameState")
    if game_state:
        game_state.switch_orientation.connect(_on_switch_orientation)

    change_state(can_process())

func _on_switch_orientation(orientation: int):
    change_state(orientation == orientation_index)

func change_state(p_state: bool):
    if not spawner:
        return

    if p_state == true:
        process_mode = Node.PROCESS_MODE_INHERIT
        if "spawner" not in spawner.get_groups():
            print("i did it")
            spawner.add_to_group("spawner")
        visible = true
    else:
        process_mode = Node.PROCESS_MODE_DISABLED
        if "spawner" in spawner.get_groups():
            spawner.remove_from_group("spawner")
        visible = false