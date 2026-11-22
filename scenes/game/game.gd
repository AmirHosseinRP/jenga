extends Node

const BRICK_SCENE: PackedScene = preload("res://scenes/brick/brick.tscn")


func _ready() -> void:
	SignalHub.brick_dropped.connect(_on_brick_dropped)


func _on_brick_dropped(transform: Transform3D) -> void:
	var brick: Brick = BRICK_SCENE.instantiate()
	brick.transform = transform
	add_child(brick)
