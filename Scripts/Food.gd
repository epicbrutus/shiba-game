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
    var color: Color

    func _init(p_value: int, p_image_list: Array, p_chance:float, p_color:Color):
        value = p_value
        image_list = p_image_list
        chance = p_chance
        color = p_color

static var food_presets = {
    FoodType.SMALL: FoodData.new(5, SMALL_FOODS, 0.8, Color.WHITE), 
    FoodType.MEDIUM: FoodData.new(10, MEDIUM_FOODS, 0.2, Color.BLUE),
    FoodType.LARGE: FoodData.new(20, LARGE_FOODS, 0.03, Color.GOLD),
    FoodType.BAD: FoodData.new(-10, BAD_FOODS, 0.3, Color.RED),
}

var value: int;
@export var sprite: Sprite2D;
@onready var particles: GPUParticles2D

func _ready() -> void:
    body_entered.connect(_on_body_entered)

func initialize(food_type: FoodType) -> void:
    var data = food_presets[food_type]
    value = data.value

    if not data.image_list.is_empty():
        var photo_path = data.image_list.pick_random()
        sprite.texture = load(photo_path)

        # Set consistent size (e.g., 64x64 pixels)
        var desired_size = Vector2(74, 74)
        var tex_size = sprite.texture.get_size()
        sprite.scale = desired_size / tex_size

    particles = $GPUParticles2D

    if particles and particles.process_material:
        #print("running")
        particles.process_material.color = data.color



func _on_body_entered(body: Node2D) -> void:
    # Check if the body that entered is the player
    if body is CharacterBody2D:
        # Call the player's eat food method
        body.change_food(value, global_position)
        
        # Make the food disappear
        get_parent().queue_free()