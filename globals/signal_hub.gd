extends Node

signal game_over
signal brick_landed(y_position: float)
signal brick_dropped(transform: Transform3D)
signal level_up(level: int, spawn_delay: float)


func emit_game_over() -> void:
	GameState.game_over = true
	GameState.score = 0
	game_over.emit()


func emit_brick_landed(y_position: float) -> void:
	GameState.score += 1
	brick_landed.emit(y_position)


func emit_brick_dropped(transform: Transform3D) -> void:
	brick_dropped.emit(transform)


func emit_level_up(level: int, spawn_delay: float) -> void:
	level_up.emit(level, spawn_delay)
