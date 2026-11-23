class_name Hud
extends Control

@onready var game_over: ColorRect = $GameOver
@onready var score_label: Label = $ColorRect/MarginContainer/ScoreLabel
@onready var level_label: Label = $ColorRect/MarginContainer/HBoxContainer/LevelLabel
@onready var spawn_time_label: Label = $ColorRect/MarginContainer/HBoxContainer/SpawnTimeLabel

var spawn_remaining_time: float
var spawn_time: float


func _enter_tree() -> void:
	SignalHub.game_over.connect(_on_game_over)
	SignalHub.brick_landed.connect(_on_brick_landed)
	SignalHub.level_up.connect(_on_level_up)


func _ready() -> void:
	game_over.hide()

	score_label.text = str(GameState.score).pad_zeros(3)
	level_label.text = "L: 1"
	spawn_time_label.text = "7.2s"


func _on_game_over() -> void:
	game_over.show()


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_brick_landed(_y: float) -> void:
	score_label.text = str(GameState.score).pad_zeros(3)

	spawn_remaining_time = spawn_time
	spawn_time_label.text = "%.1fs" % spawn_time


func _on_level_up(level: int, spawn_delay: float) -> void:
	spawn_time = spawn_delay
	spawn_remaining_time = spawn_delay

	level_label.text = "L: " + str(level)
	spawn_time_label.text = "%.1fs" % spawn_delay


func _on_timer_timeout() -> void:
	spawn_remaining_time = clampf(spawn_remaining_time - 0.1, 0, INF)
	spawn_time_label.text = "%.1fs" % spawn_remaining_time
