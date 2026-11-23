class_name Spawner
extends Node3D

@onready var pivot: Node3D = $Pivot
@onready var brick_mesh: MeshInstance3D = $Pivot/BrickMesh
@onready var timer: Timer = $Timer

const ROTATION_SPEED: float = 2.0
const MOVEMENT_SPEED: float = 2.0
const MOVEMENT_LIMIT: float = 2.0
const LIFT_DURATION: float = 0.3
const SPAWN_PLACEMENT_LIMIT: float = 1.7

var spawn_delay: float = 4
var start_y: float = 0.0
var highest_y: float = 0.0

var lift_tween: Tween


func _ready() -> void:
	start_y = position.y

	brick_mesh.hide()

	SignalHub.brick_landed.connect(_on_brick_landed)
	SignalHub.game_over.connect(_on_game_over)

	_on_brick_landed(0)


func _process(delta: float) -> void:
	if brick_mesh.visible:
		handle_rotation(delta)
		handle_movement(delta)


func handle_rotation(delta: float) -> void:
	var rotation_input: float = Input.get_axis("rotate_counterclockwise", "rotate_clockwise")

	pivot.rotate_y(rotation_input * ROTATION_SPEED * delta)


func handle_movement(delta: float) -> void:
	var movement_input_x: float = Input.get_axis("move_left", "move_right")
	var movement_input_z: float = Input.get_axis("move_back", "move_forward")

	var movement_delta = Vector3(movement_input_x, 0, movement_input_z) * MOVEMENT_SPEED * delta
	var new_position = pivot.global_position + movement_delta

	new_position.x = clampf(new_position.x, -MOVEMENT_LIMIT, MOVEMENT_LIMIT)
	new_position.z = clampf(new_position.z, -MOVEMENT_LIMIT, MOVEMENT_LIMIT)

	pivot.global_position = new_position


func reposition_pivot() -> void:
	pivot.rotation_degrees.y = randf_range(0, 360)

	pivot.position.x = randf_range(-SPAWN_PLACEMENT_LIMIT, SPAWN_PLACEMENT_LIMIT)
	pivot.position.z = randf_range(-SPAWN_PLACEMENT_LIMIT, SPAWN_PLACEMENT_LIMIT)


func raise_spawner(y_position: float) -> void:
	if y_position > highest_y:
		highest_y = y_position

	if lift_tween:
		lift_tween.kill()

	lift_tween = create_tween()
	lift_tween.set_trans(Tween.TRANS_CUBIC)
	lift_tween.set_ease(Tween.EASE_OUT)
	lift_tween.tween_property(self, "position:y", start_y + highest_y, LIFT_DURATION)


func drop_brick() -> void:
	SignalHub.emit_brick_dropped(brick_mesh.global_transform)
	brick_mesh.hide()


func start_timer() -> void:
	timer.wait_time = spawn_delay
	timer.start()


func _on_brick_landed(y_position: float) -> void:
	raise_spawner(y_position)
	reposition_pivot()
	brick_mesh.show()
	start_timer()


func _on_game_over() -> void:
	print("spawner: game over")


func _on_timer_timeout() -> void:
	drop_brick()
