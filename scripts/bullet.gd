extends Area2D

@export var speed: float = 700.0

func _process(delta: float) -> void:
	position.y -= speed * delta

	if position.y < -20:
		queue_free()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 5, Color("#00ffff"))

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		var enemy_destroyed = true
		var points = 10

		if area.has_method("take_damage"):
			points = 20
			enemy_destroyed = area.take_damage()

		if enemy_destroyed:
			get_tree().current_scene.add_score(points)
			get_tree().current_scene.play_explosion()
			area.queue_free()

		queue_free()
