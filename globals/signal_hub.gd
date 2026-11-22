extends Node

signal game_over
signal brick_landed(y_position: float)
signal brick_dropped(transform: Transform3D)


func emit_game_over() -> void:
	game_over.emit()


func emit_brick_landed(y_position: float) -> void:
	brick_landed.emit(y_position)


func emit_brick_dropped(transform: Transform3D) -> void:
	brick_dropped.emit(transform)
