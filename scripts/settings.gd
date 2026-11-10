
extends Control

signal back_pressed

@onready var music_slider: HSlider = $MusicSlider
@onready var sound_slider: HSlider = $SoundSlider
@onready var reset_score_button: Button = $ResetScoreButton


func _ready() -> void:
	var music_bus = AudioServer.get_bus_index("Music")
	var sound_bus = AudioServer.get_bus_index("SFX")

	if AudioServer.is_bus_mute(music_bus):
		music_slider.value = 0
	else:
		music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus)) * 100.0

	if AudioServer.is_bus_mute(sound_bus):
		sound_slider.value = 0
	else:
		sound_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sound_bus)) * 100.0

	music_slider.value_changed.connect(_on_music_slider_changed)
	sound_slider.value_changed.connect(_on_sound_slider_changed)
	$BackButton.pressed.connect(_on_back_button_pressed)

	# Reset button only in Main Menu Settings
	if get_parent().name == "PauseMenu":
		reset_score_button.visible = false
	else:
		reset_score_button.pressed.connect(_on_reset_score_pressed)


func _on_music_slider_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(value / 100.0, 0.001)))
	AudioServer.set_bus_mute(bus_index, value <= 0.0)


func _on_sound_slider_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(maxf(value / 100.0, 0.001)))
	AudioServer.set_bus_mute(bus_index, value <= 0.0)


func _on_reset_score_pressed() -> void:
	$ResetConfirmationDialog.popup_centered()


func _on_reset_confirmation_dialog_confirmed() -> void:
	var config = ConfigFile.new()
	config.set_value("scores", "high_score", 0)
	config.save("user://high_score.cfg")

	print("High score reset to 0")

func _on_back_button_pressed() -> void:
	if get_parent().name == "PauseMenu":
		back_pressed.emit()
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
