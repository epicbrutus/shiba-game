@tool
extends Node2D

@export var anchor_script: Script = preload("res://Scripts/anchor.gd")

const ANCHOR_PREFIX := "Anchor"

var _radius := 200.0
@export var radius := 200.0:
    set(value):
        _radius = value
        if Engine.is_editor_hint():
            arrange_children()
    get:
        return _radius

var _arrange_now := false
@export var arrange_now := false:
    set(value):
        _arrange_now = value
        if Engine.is_editor_hint() and value:
            arrange_children()

            set_deferred("arrange_now", false)
    get:
        return _arrange_now

func _ready() -> void:
    if Engine.is_editor_hint():
        arrange_children()

func arrange_children() -> void:
    if !Engine.is_editor_hint():
        return

    var root_owner := owner
    var snapshot := get_children()
    if snapshot.is_empty():
        return

    var anchors: Array[Node2D] = []
    var payloads: Array[Node2D] = []

    # anchor per child
    for child in snapshot:
        if !(child is Node2D):
            continue

        var anchor := child as Node2D
        if anchor.name.begins_with(ANCHOR_PREFIX):
            anchors.append(anchor)
            if anchor.owner == null and root_owner:
                anchor.owner = root_owner
            if anchor_script and anchor.get_script() != anchor_script:
                anchor.set_script(anchor_script)
            if anchor.get_child_count() > 0:
                var payload := anchor.get_child(0)
                if payload is Node2D:
                    payloads.append(payload)
            continue

        # put child in new anchor
        var new_anchor := Node2D.new()
        new_anchor.name = ANCHOR_PREFIX
        add_child(new_anchor)
        if root_owner:
            new_anchor.owner = root_owner
        if anchor_script:
            new_anchor.set_script(anchor_script)
        move_child(new_anchor, anchors.size())
        child.reparent(new_anchor)

        anchors.append(new_anchor)
        payloads.append(child)

    if anchors.is_empty():
        return

    # give each anchor a unique name
    for i in range(anchors.size()):
        var anchor := anchors[i]
        anchor.name = "%s_%d" % [ANCHOR_PREFIX, i]

    # arrange in circle
    var step := TAU / float(anchors.size())
    for i in range(anchors.size()):
        var anchor := anchors[i]
        anchor.position = Vector2.RIGHT.rotated(step * i) * _radius
        anchor.rotation = 0 #step * i

        # if anchor.get_child_count() > 0:
        #     var payload := anchor.get_child(0)
        #     if payload is Node2D:
        #         (payload as Node2D).rotation = 0.0