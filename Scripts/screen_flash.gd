extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var game_state: Node

func _ready():
	game_state = get_tree().get_first_node_in_group("GameState")
	if game_state:
		game_state.switch_orientation.connect(_on_switch_orientation)
	
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_switch_orientation(num: int):
	if game_state.score > game_state.boss_every:
		visible = true
		animation_player.play("screen_flash")

func _on_animation_finished(anim_name: String):
	visible = false
