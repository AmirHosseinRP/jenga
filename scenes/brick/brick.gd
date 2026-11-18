class_name Brick
extends RigidBody3D

const TABLE_GROUP: String = "Table"


func _on_sleeping_state_changed() -> void:
	if sleeping:
		print("rest")


func _on_body_entered(body: Node) -> void:
	if body.is_in_group(TABLE_GROUP):
		print("lost")
