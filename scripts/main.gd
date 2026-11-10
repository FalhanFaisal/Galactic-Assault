extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
const SPECIAL_ENEMY_SCENE = preload("res://scenes/special_enemy.tscn")
const SHOOTING_ENEMY_SCENE = preload("res://scenes/shooting_enemy.tscn")

@export var spawn_interval: float = 1.5
var spawn_timer: float = 0.0
var score: int = 0
var high_score: int = 0
var max_shooting_enemies: int = 0
@onready var explosion_sound: AudioStreamPlayer2D = $AudioStreamPlayer
@onready var background_music: AudioStreamPlayer = $AudioStreamPlayer2

func _process(delta: float) -> void:
	spawn_timer += delta

	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_enemy()

func _ready() -> void:
	load_high_score()
	$HUD/HighScoreLabel.text = "HIGH SCORE: " + str(high_score)
	background_music.finished.connect(_on_music_finished)
	background_music.play()
	
func _on_music_finished() -> void:
	background_music.play()
	
func spawn_enemy() -> void:
	var enemy
	var enemy_type = randf()
	var shooting_enemy_count = get_tree().get_nodes_in_group("shooting_enemies").size()
	var is_shooting_enemy = false

	if enemy_type < 0.10 and shooting_enemy_count < max_shooting_enemies:
		enemy = SHOOTING_ENEMY_SCENE.instantiate()
		is_shooting_enemy = true
	elif enemy_type < 0.30:
		enemy = SPECIAL_ENEMY_SCENE.instantiate()
	else:
		enemy = ENEMY_SCENE.instantiate()

	add_child(enemy)

	var screen_size = get_viewport_rect().size

	if is_shooting_enemy:
		enemy.position = Vector2(
			randf_range(40.0, screen_size.x - 40.0),
			100.0
		)
	else:
		enemy.position = Vector2(
			randf_range(30.0, screen_size.x - 30.0),
			-50.0
		)

func add_score(points: int) -> void:
	score += points
	
	if score > high_score:
		high_score = score
		save_high_score()
		$HUD/HighScoreLabel.text = "HIGH SCORE: " + str(high_score)

	if score <= 200:
		max_shooting_enemies = 0
	elif score <= 400:
		max_shooting_enemies = 3
	elif score <= 800:
		max_shooting_enemies = 4
	elif score <= 1100:
		max_shooting_enemies = 5
	elif score <= 2000:
		max_shooting_enemies = 6
	else:
		max_shooting_enemies = 8

	var score_label = get_tree().current_scene.get_node("HUD/ScoreLabel")
	score_label.text = "Score: " + str(score)

func play_explosion() -> void:
	explosion_sound.play()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not event.is_echo():
		$PauseMenu.visible = true
		get_tree().paused = true
		get_viewport().set_input_as_handled()

func load_high_score() -> void:
	var config = ConfigFile.new()
	var error = config.load("user://high_score.cfg")

	if error == OK:
		high_score = config.get_value("scores", "high_score", 0)
	else:
		high_score = 0

func save_high_score() -> void:
	var config = ConfigFile.new()
	config.set_value("scores", "high_score", high_score)
	config.save("user://high_score.cfg")
