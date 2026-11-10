extends Control

func _ready() -> void:
	$ResumeButton.pressed.connect(_on_resume_pressed)
	$SettingsButton.pressed.connect(_on_settings_pressed)
	$MainMenuButton.pressed.connect(_on_main_menu_pressed)
	$Settings.back_pressed.connect(_on_settings_back_pressed)

func _on_resume_pressed() -> void:
	visible = false
	get_tree().paused = false



func _on_settings_pressed() -> void:
	$PauseTitle.visible = false
	$ResumeButton.visible = false
	$SettingsButton.visible = false
	$MainMenuButton.visible = false

	# Keep the Settings title centered

	var title: Label = $Settings/SettingsTitle
	title.position = Vector2(0, 145)
	title.size = Vector2(1280, 67)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	$Settings.visible = true


func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_settings_back_pressed() -> void:
	$Settings.visible = false
	$PauseTitle.visible = true
	$ResumeButton.visible = true
	$SettingsButton.visible = true
	$MainMenuButton.visible = true
