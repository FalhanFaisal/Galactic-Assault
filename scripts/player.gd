
extends CharacterBody2D

const BULLET_SCENE = preload("res://scenes/bullet.tscn")

@export var speed: float = 400.0
@export var shoot_cooldown: float = 0.25

var shoot_timer: float = 0.0

signal health_changed(new_health: int)

@onready var laser_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player_sprite: Sprite2D = $Sprite2D

var health: int = 3

@export var invulnerability_duration: float = 1.0
var invulnerability_timer: float = 0.0

var is_damaged: bool = false
var damage_flash_timer: float = 0.0


func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	# Keyboard movement
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	# Normalize diagonal movement
	direction = direction.normalized()

	# Apply movement
	velocity = direction * speed
	move_and_slide()

	# Keep player inside the screen
	var screen_size := get_viewport_rect().size

	global_position.x = clampf(global_position.x, 35.0, screen_size.x - 35.0)
	global_position.y = clampf(global_position.y, 35.0, screen_size.y - 35.0)

	# Shooting
	shoot_timer -= delta

	if Input.is_action_pressed("shoot") and shoot_timer <= 0.0:
		var bullet = BULLET_SCENE.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position + Vector2(0, -40)

		laser_sound.play()
		shoot_timer = shoot_cooldown


# Draw shield effect only
func _draw() -> void:
	if invulnerability_timer > 0.0:
		draw_arc(
			Vector2.ZERO,
			53.0,
			0.0,
			TAU,
			64,
			Color("#00ccff"),
			3.0
		)


func take_damage() -> void:
	if invulnerability_timer > 0.0:
		return

	invulnerability_timer = invulnerability_duration

	health -= 1
	print("Player health: ", health)
	health_changed.emit(health)

	# Red flash when damaged
	is_damaged = true
	damage_flash_timer = 0.2
	player_sprite.modulate = Color("#ff5555")

	queue_redraw()

	if health <= 0:
		print("GAME OVER")
		queue_free()


func _process(delta: float) -> void:
	if invulnerability_timer > 0.0:
		invulnerability_timer -= delta
		queue_redraw()

	if is_damaged:
		damage_flash_timer -= delta

		if damage_flash_timer <= 0.0:
			is_damaged = false
			player_sprite.modulate = Color.WHITE

		queue_redraw()
