extends Area2D

@onready var timer: Timer = $Timer
@onready var death_sound: AudioStreamPlayer = $death_sound
@onready var smash_sound: AudioStreamPlayer = $smash_sound

@export var activated: bool = true

@onready var counter = get_tree().get_first_node_in_group("counter")

#Likely not needed anymore
func initialize(p_counter: RichTextLabel) -> void:
	counter = p_counter

func _ready() -> void:
	if activated:
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Check if the body that entered is the player
	if body is CharacterBody2D:
		if body.getCurrentWeight() >= 3:

			body.change_food(-40)

			if counter:
				print("gyatt ohio")
				counter.set_count()

			disable_gate()
			smash_sound.play()
			await smash_sound.finished
			get_parent().queue_free()
		else:
			death_sound.play()
			death_sound.seek(0.3)
			body.queue_free()
			timer.start(2)
			await timer.timeout
			get_tree().reload_current_scene()

#It clipped before so check back if it does it again
func _physics_process(delta: float) -> void:
	if activated:
		get_parent().position.y -= 1800 * delta;

func disable_gate() -> void:
	$CollisionShape2D.queue_free()
	visible = false
	set_process(false)

func activate():
	activated = true
	body_entered.connect(_on_body_entered)