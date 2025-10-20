extends Node2D

@export var hide_until_point: bool = false
@export var reverse_order: bool = false
@export var cutoff_point: Node
@export var to_track: VisibleOnScreenNotifier2D

@export var turn_speed: float = 0.5

@onready var children: Array = get_children()
var cutoff_children: Array

func _ready():
    if to_track:
        to_track.screen_entered.connect(show_cutoff)

        var node2d_children: Array[Node2D] = []
        for child in children:
            if child is Node2D:
                node2d_children.append(child)
        children = node2d_children

        var reached_cutoff_point: bool = false
        for i in range(children.size()):
            var index: int = i

            if reverse_order:
                index = children.size() - 1 - i

            if children[index] == cutoff_point:
                reached_cutoff_point = true
            
            if reached_cutoff_point:
                cutoff_children.append(children[index])

        for child in cutoff_children:
            child.process_mode = PROCESS_MODE_DISABLED
            child.visible = false

            print(child.name + " is invisible")
            



func _physics_process(delta: float) -> void:
    rotation += delta * turn_speed


func show_cutoff():
    for child in cutoff_children:
        child.process_mode = PROCESS_MODE_INHERIT
        child.visible = true

        #to_track.screen_entered.disconnect(show_cutoff)