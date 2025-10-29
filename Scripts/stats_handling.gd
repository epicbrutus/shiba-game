extends Control

const FoodScript := preload("res://Scripts/Food.gd")
@onready var game_state = get_tree().get_first_node_in_group("GameState")

var food_counts = {
	FoodScript.FoodType.SMALL: 0,
	FoodScript.FoodType.MEDIUM: 0,
	FoodScript.FoodType.LARGE: 0,
	FoodScript.FoodType.BAD: 0
}

var food_labels = {}

var start_time: int = 0
var end_time: int = 0

var weight_gained: int = 0
var weight_lost: int = 0

func _ready():
	start_time = Time.get_ticks_msec()
	food_labels = {
		FoodScript.FoodType.SMALL: %small_food_counter,
		FoodScript.FoodType.MEDIUM: %medium_food_counter,
		FoodScript.FoodType.LARGE: %large_food_counter,
		FoodScript.FoodType.BAD: %bad_food_counter
	}

func add_food(type_id: int):
	food_counts[type_id] += 1
	update_food_counter(type_id)

func get_label(type_id: int) -> String:
	return FoodScript.FoodType.keys()[type_id]

func update_food_counter(type_id: int):
	var the_label = food_labels[type_id]

	the_label.text = get_label(type_id).capitalize() + ": " + str(food_counts[type_id])

func format_time_hmmss(elapsed_ms: int) -> String:
	var total_seconds: int = elapsed_ms / 1000
	var hours: int = total_seconds / 3600
	var minutes: int = (total_seconds % 3600) / 60
	var seconds: int = total_seconds % 60
	return "%d:%02d:%02d" % [hours, minutes, seconds]

func end_game():
	var current_level: int = game_state.score

	visible = true

	%survived_for_counter.text = "Survived for: " + calculate_elapsed_time()
	%lost_on_counter.text = "Lost on level " + str(current_level)
	%bosses_beaten_counter.text = "Bosses beaten: " + str((current_level - 1)/3)

	%weight_gained_counter.text = "Weight gained:\n" + str(weight_gained)
	%weight_lost_counter.text = "Weight lost:\n" + str(weight_lost)

func record_end_time():
	end_time = Time.get_ticks_msec()

func calculate_elapsed_time() -> String:
	var elapsed_ms: int = end_time - start_time
	var time_str: String = format_time_hmmss(elapsed_ms)

	return time_str

func report_weight_change(change: int):
	if change < 0:
		weight_lost += abs(change)
	else:
		weight_gained += change


func _on_main_menu_pressed() -> void:
	var main_scene = ProjectSettings.get_setting("application/run/main_scene")
	get_tree().change_scene_to_file(main_scene)


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
