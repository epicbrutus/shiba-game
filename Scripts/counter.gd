extends RichTextLabel

var game_state

func _ready() -> void:
	game_state = get_tree().get_first_node_in_group("GameState")

	game_state.score_changed.connect(_on_score_changed)
	_on_score_changed(game_state.score)  # initial text

func _on_score_changed(v: int) -> void:
	text = "Level:\n" + str(v)
	
func set_count() -> void:
	Utils.get_spawner().reset_gate_timer()
	game_state.add_score(1)