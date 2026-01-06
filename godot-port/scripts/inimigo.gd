extends Area2D

func _ready() -> void:
	var sprite := "res://images/enemies/enemy-{}.png".format(randi_range(1, 8), "{}")
	$Sprite2D.texture = sprite

func _on_screen_exited() -> void:
	queue_free()
