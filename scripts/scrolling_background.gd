
extends ColorRect

@export var scroll_speed: float = 30.0

@onready var background1: TextureRect = $TextureRect
@onready var background2: TextureRect = $TextureRect2

func _process(delta: float) -> void:
	background1.position.y += scroll_speed * delta
	background2.position.y += scroll_speed * delta

	if background1.position.y >= 750:
		background1.position.y = background2.position.y - 750

	if background2.position.y >= 750:
		background2.position.y = background1.position.y - 750
