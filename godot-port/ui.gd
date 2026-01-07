extends CanvasLayer

func _ready() -> void:
	var s = Sprite2D.new()
	s.texture = $Sprite2D.texture
	s.scale = $Sprite2D.scale
	s.position.y = $Sprite2D.position.y
	s.position.x = $Sprite2D.position.x + ($Sprite2D.get_rect().size.x * $Sprite2D.scale.x) + 5

	add_child(s)
