
extends Area2D

@export var speed: float = 150.0

func _process(delta: float) -> void:
	position.y += speed * delta

	if position.y > get_viewport_rect().size.y + 50:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	print("Enemy touched: ", body.name)

	if body.is_in_group("player"):
		body.take_damage()
		queue_free()
