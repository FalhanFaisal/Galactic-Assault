extends AudioStreamPlayer

const MUSIC = preload("res://assets/sounds/audiopapkin-ambient-soundscapes-007-space-atmosphere-304974.mp3")

func _ready() -> void:
	stream = MUSIC
	bus = "Music"
	finished.connect(_on_music_finished)
	play()

func _on_music_finished() -> void:
	play()
