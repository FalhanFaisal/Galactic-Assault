
extends Area2D

@export var speed: float = 100.0

var health: int = 2
var max_health: int = 2


func _ready() -> void:
	health = randi_range(2, 3)
	max_health = health


func _process(delta: float) -> void:
	position.y += speed * delta

	if position.y > get_viewport_rect().size.y + 50:
		queue_free()


# Draw health bar only
func _draw() -> void:
	draw_health_bar()


func draw_health_bar() -> void:
	var bar_width = 50.0
	var bar_height = 6.0
	var health_percent = float(health) / float(max_health)

	draw_rect(
		Rect2(-bar_width / 2, -55, bar_width, bar_height),
		Color("#333333")
	)

	draw_rect(
		Rect2(-bar_width / 2, -55, bar_width * health_percent, bar_height),
		Color("#00ff00")
	)


func take_damage() -> bool:
	health -= 1
	print("Special enemy health: ", health)
	queue_redraw()

	if health <= 0:
		return true

	return false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage()
		queue_free()
