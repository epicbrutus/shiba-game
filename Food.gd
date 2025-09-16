extends Area2D

enum FoodType {
	DONUT,
	BROCOLLI
}

class FoodData:
	var value: int
	var sprite_path: String
	var photosPath: String = "res://photos/"

	func _init(p_value: int, p_sprite_path: String):
		value = p_value
		sprite_path = photosPath + p_sprite_path

var food_presets = {
	FoodType.DONUT: FoodData.new(20, "donut.png"),
	FoodType.BROCOLLI: FoodData.new(-20, "brocolli.png"),
}

var value: int;
@export var sprite: Sprite2D;

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func initialize(food_type: FoodType) -> void:
	var data = food_presets[food_type]
	value = data.value
	sprite.texture = load(data.sprite_path)

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
