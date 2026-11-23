class_name Hud
extends Control

@onready var game_over: ColorRect = $GameOver


func _ready() -> void:
	SignalHub.game_over.connect(_on_game_over)

	game_over.hide()


func _on_game_over() -> void:
	game_over.show()


func _on_retry_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
