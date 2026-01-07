extends CanvasLayer

@onready var vidas: Array[Sprite2D] = [$Jogo/Coracao]
@onready var vida_perdida := Sprite2D.new()

func _ready() -> void:
	vida_perdida.texture = load("res://images/heart-empty.png")

func alterar_tempo(tempo: int) -> void:
	if tempo < 60:
		$Jogo/Tempo.text = "00:" + formatar(tempo)
	else:
		@warning_ignore("integer_division")
		var minuto := tempo / 60
		while tempo >= 60: tempo -= 60
		$Jogo/Tempo.text = formatar(minuto) + ":" + formatar(tempo)

func formatar(tempo: int) -> String:
	if tempo < 10:
		return "0" + str(tempo)
	else:
		return str(tempo)

func _on_player_vida_perdida() -> void:
	var i := vidas.size() - 1

	while i >= 0:
		if not vidas[i].texture == vida_perdida.texture:
			vidas[i].texture = vida_perdida.texture
			break
		i -= 1

func desenhar_vidas(qtd: int) -> void:
	var anterior: Sprite2D = vidas[0]
	for i in range(1, qtd):
		print("Desenhando vida " + str(i))
		var coracao = Sprite2D.new()

		coracao.texture = anterior.texture
		coracao.scale = anterior.scale
		coracao.position.y = anterior.position.y
		coracao.position.x = anterior.position.x + (anterior.get_rect().size.x * anterior.scale.x) * 1 + 5

		vidas.push_back(coracao)
		anterior = coracao
		add_child(coracao)
