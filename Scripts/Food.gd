extends Area2D

static var SMALL_FOODS = ["res://Food_Photos/Small_Foods/chip.png"]
static var MEDIUM_FOODS = ["res://Food_Photos/Medium_Foods/donut.png"]
static var LARGE_FOODS = ["res://Food_Photos/Large_Foods/cake.png"]
static var BAD_FOODS = ["res://Food_Photos/Bad_Foods/brocolli.png"]

enum FoodType {
    SMALL,
    MEDIUM,
    LARGE,
    BAD
}

class FoodData:
    var value: int
    var image_list: Array
    var chance: float

    func _init(p_value: int, p_image_list: Array, p_chance:float):
        value = p_value
        image_list = p_image_list
        chance = p_chance

static var food_presets = {
    FoodType.SMALL: FoodData.new(10, SMALL_FOODS, 0.8), 
    FoodType.MEDIUM: FoodData.new(20, MEDIUM_FOODS, 0.2),
    FoodType.LARGE: FoodData.new(40, LARGE_FOODS, 0.03),
    FoodType.BAD: FoodData.new(-20, BAD_FOODS, 0.5),
}

var value: int;
@export var sprite: Sprite2D;

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func initialize(food_type: FoodType) -> void:
    var data = food_presets[food_type]
    value = data.value

    if not data.image_list.is_empty():
        var photo_path = data.image_list.pick_random()
        sprite.texture = load(photo_path)

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