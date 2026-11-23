class_name Brick
extends RigidBody3D

const TABLE_GROUP: String = "Table"


func _on_sleeping_state_changed() -> void:
	if sleeping:
		if !GameState.game_over:
			SignalHub.emit_brick_landed(position.y)

		if sleeping_state_changed.is_connected(_on_sleeping_state_changed):
			sleeping_state_changed.disconnect(_on_sleeping_state_changed)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(TABLE_GROUP) && !GameState.game_over:
		SignalHub.emit_game_over()
