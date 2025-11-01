extends ColorRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var game_state: Node

func _ready():
	game_state = get_tree().get_first_node_in_group("GameState")
	if game_state:
		game_state.score_changed.connect(_on_score_change)
	
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_score_change(num: int):
	print("sdoif")
	print(num)
	#if num > 1:
	visible = true
	if (num - 1) % game_state.boss_every == 0:
		animation_player.play("screen_flash")
	else:
		animation_player.play("mini_screen_flash")
		print("moomefeomf")

func _on_animation_finished(anim_name: String):
	visible = false
