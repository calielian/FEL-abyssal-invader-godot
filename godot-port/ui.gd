extends CanvasLayer

func _ready() -> void:
	var s = Sprite2D.new()
	s.texture = $Sprite2D.texture
	s.scale = $Sprite2D.scale
	s.position.y = $Sprite2D.position.y
	s.position.x = $Sprite2D.position.x + ($Sprite2D.get_rect().size.x * $Sprite2D.scale.x) + 5

	add_child(s)

func alterar_tempo(tempo: int) -> void:
	if tempo < 60:
		$Tempo.text = "00:" + formatar(tempo)
	else:
		var minuto := tempo / 60
		while tempo >= 60: tempo -= 60
		$Tempo.text = formatar(minuto) + ":" + formatar(tempo)

func formatar(tempo: int) -> String:
	if tempo < 10:
		return "0" + str(tempo)
	else:
		return str(tempo)
