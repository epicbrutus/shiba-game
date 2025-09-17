extends Area2D

const Utils = preload("res://Utils.gd")

enum FoodType {
	SMALL,
	MEDIUM,
	LARGE,
	BAD
}

class FoodData:
	var value: int
	var sprite_path: String
	var photosPath: String = "res://Food_Photos"
	var chance: float

	func _init(p_value: int, p_sprite_path: String, p_chance:float):
		value = p_value
		sprite_path = photosPath + "/" + p_sprite_path
		chance = p_chance

static var food_presets = {
	FoodType.SMALL: FoodData.new(2, "Small_Foods", 0.5), 
	FoodType.MEDIUM: FoodData.new(15, "Medium_Foods", 0.2),
	FoodType.LARGE: FoodData.new(30, "Large_Foods", 0.1),
	FoodType.BAD: FoodData.new(-20, "Bad_Foods", 0.2),
}

var value: int;
@export var sprite: Sprite2D;

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func initialize(food_type: FoodType) -> void:
	var data = food_presets[food_type]
	value = data.value

	var photo: String = Utils.get_random_photo_from_folder(data.sprite_path)
	print(photo)
	sprite.texture = load(photo)

	# Set consistent size (e.g., 64x64 pixels)
	var desired_size = Vector2(20, 20)
	var tex_size = sprite.texture.get_size()
	sprite.scale = desired_size / tex_size


func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		# Call the player's eat food method
		body.change_food(value)
		
		# Make the food disappear
		get_parent().queue_free()

func _process(delta: float) -> void:
	position.y -= 40 * delta;
