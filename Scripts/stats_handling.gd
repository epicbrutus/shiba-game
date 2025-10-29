extends Control

const FoodScript := preload("res://Scripts/Food.gd")

var food_counts = {
	FoodScript.FoodType.SMALL: 0,
	FoodScript.FoodType.MEDIUM: 0,
	FoodScript.FoodType.LARGE: 0,
	FoodScript.FoodType.BAD: 0
}

var food_labels = {}

func _ready():
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
