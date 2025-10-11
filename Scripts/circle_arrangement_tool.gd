@tool
extends Node2D

#const ANCHOR_PREFAB : PackedScene = null #preload("res://Prefabs/carousel_anchor.tscn")

var _radius := 200.0
@export var radius := 200.0 :
	set(value):
		_radius = value
		if Engine.is_editor_hint():
			arrange_children()
	get:
		return _radius

var _arrange_now := false
@export var arrange_now := false :
	set(value):
		_arrange_now = false
		if Engine.is_editor_hint() and value:
			arrange_children()
	get:
		return _radius

func _ready() -> void:
	if Engine.is_editor_hint():
		arrange_children()

func arrange_children() -> void:
	if !Engine.is_editor_hint():
		return
	
	var nodes := get_children()
	if nodes.is_empty():
		return

	var angle_step := TAU / nodes.size()
	for i in range(nodes.size()):
		var anchor := nodes[i]
		if !(anchor is Node2D):
			continue

		if anchor.name != "Anchor":
			var child := anchor
			#anchor = ANCHOR_PREFAB.instantiate()
			anchor = Node2D.new()
			anchor.name = "Anchor"
			add_child(anchor)
			move_child(anchor, i)
			child.reparent(anchor)
			nodes[i] = anchor

		anchor.position = Vector2.RIGHT.rotated(angle_step * i) * radius
		anchor.rotation = angle_step * i

		