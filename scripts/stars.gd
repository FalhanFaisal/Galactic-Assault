extends Node2D

@export var star_count: int = 120
@export var star_speed: float = 40.0

var stars: Array[Vector2] = []

func _ready() -> void:
	var screen_size = get_viewport_rect().size

	for i in range(star_count):
		stars.append(Vector2(
			randf_range(0.0, screen_size.x),
			randf_range(0.0, screen_size.y)
		))

func _process(delta: float) -> void:
	var screen_size = get_viewport_rect().size

	for i in range(stars.size()):
		stars[i].y += star_speed * delta

		if stars[i].y > screen_size.y:
			stars[i].y = 0
			stars[i].x = randf_range(0.0, screen_size.x)

	queue_redraw()

func _draw() -> void:
	for star in stars:
		draw_circle(star, 1.5, Color("#dceeff"))
