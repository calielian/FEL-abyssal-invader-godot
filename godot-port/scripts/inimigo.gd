extends Area2D

@export var sprites: Array[Texture2D]

func _ready() -> void:
	$Sprite2D.texture = sprites.pick_random()

func _on_screen_exited() -> void:
	queue_free()
