extends Control

func _ready() -> void:
	$PlayButton.pressed.connect(_on_play_button_pressed)
	$SettingsButton.pressed.connect(_on_settings_button_pressed)
	$QuitButton.pressed.connect(_on_quit_button_pressed)
	
	var config = ConfigFile.new()
	config.load("user://high_score.cfg")
	var high_score = config.get_value("scores", "high_score", 0)
	$HighScoreLabel.text = "HIGH SCORE: " + str(high_score)

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")
