
extends CanvasLayer

@onready var game_over_label: Label = $GameOverLabel
@onready var restart_button: Button = $RestartButton
@onready var main_menu_button: Button = $MainMenuButton

@onready var final_score_label: Label = $FinalScoreLabel
@onready var final_high_score_label: Label = $FinalHighScoreLabel

@onready var ship_1: TextureRect = $LifeIcon1
@onready var ship_2: TextureRect = $LifeIcon2
@onready var ship_3: TextureRect = $LifeIcon3


func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.health_changed.connect(_on_health_changed)

	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

	_on_health_changed(player.health)


func _on_health_changed(new_health: int) -> void:
	ship_1.visible = new_health >= 1
	ship_2.visible = new_health >= 2
	ship_3.visible = new_health >= 3

	if new_health <= 0:
		game_over_label.visible = true
		restart_button.visible = true
		main_menu_button.visible = true

		var main = get_tree().current_scene

		final_score_label.text = "FINAL SCORE: " + str(main.get("score"))
		final_high_score_label.text = "HIGHEST SCORE: " + str(main.get("high_score"))

		final_score_label.visible = true
		final_high_score_label.visible = true


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
