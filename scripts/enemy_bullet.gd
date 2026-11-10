extends Area2D

@export var speed: float = 350.0

var direction: Vector2 = Vector2.DOWN

func _process(delta: float) -> void:
	position += direction * speed * delta

	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 6, Color("#ff4444"))


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage()
		queue_free()
