
extends Area2D

const ENEMY_BULLET_SCENE = preload("res://scenes/enemy_bullet.tscn")

@export var speed: float = 180.0

var direction: float = 1.0
var health: int = 5

@export var shoot_interval: float = 1.5
var shoot_timer: float = 0.0


func _process(delta: float) -> void:
	position.x += direction * speed * delta

	var screen_width = get_viewport_rect().size.x

	if position.x >= screen_width - 40:
		direction = -1.0

	if position.x <= 40:
		direction = 1.0

	shoot_timer -= delta

	if shoot_timer <= 0.0:
		shoot_at_player()
		shoot_timer = shoot_interval


func take_damage() -> bool:
	health -= 1
	print("Shooting enemy health: ", health)

	return health <= 0


func shoot_at_player() -> void:
	var players = get_tree().get_nodes_in_group("player")
	var player = null

	for node in players:
		if node is CharacterBody2D:
			player = node
			break

	if player == null:
		return

	var bullet = ENEMY_BULLET_SCENE.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = global_position
	bullet.direction = (player.global_position - global_position).normalized()
