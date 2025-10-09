extends Node2D

@export var bulletPrefab: PackedScene

@onready var on_screen_notifier = $VisibleOnScreenNotifier2D
var canFire: bool = false

var BULLET_COOLDOWN: float = 0.3
@onready var bulletTimer: float = BULLET_COOLDOWN

@onready var gunSprite: Sprite2D = $gunSprite

var _player: Node2D = null
var player: Node2D:
	get:
		if not is_instance_valid(_player):
			_player = get_tree().get_first_node_in_group("player")
		return _player
	set(value):
		_player = value

func _ready() -> void:
	on_screen_notifier.screen_entered.connect(_on_screen_entered)
	on_screen_notifier.screen_exited.connect(_on_screen_exited)

func _process(delta):
	if canFire:
		bulletTimer -= delta

	if bulletTimer <= 0:

		var target := player

		if target == null:
			return

		var bullet = bulletPrefab.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position

		var direction = (target.global_position - global_position).normalized()
		bullet.initialize(direction)

		bulletTimer = BULLET_COOLDOWN

func _on_screen_entered() -> void:
	canFire = true

func _on_screen_exited() -> void:
	canFire = false
