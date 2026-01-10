extends CanvasLayer

@onready var vidas: Array[Sprite2D] = [$Jogo/Coracao]
@onready var vida_perdida := Sprite2D.new()
@onready var vida_cheia := Sprite2D.new()

signal iniciar_jogo
signal retomar
signal pausado
signal nova_wave

var sair := false
var continuar_butao: Button
var sair_butao: Button

var wave_time := 30

const CONFIG := "user://score.cfg"

var score := 0

func _ready() -> void:
	vida_perdida.texture = load("res://images/heart-empty.png")
	vida_cheia.texture =  load("res://images/heart-full.png")
	
	continuar_butao = $MainMenu/Iniciar
	sair_butao = $MainMenu/Sair

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("alterar_opcao"):
		if sair:
			continuar_butao.grab_focus()
		else:
			sair_butao.grab_focus()

	if Input.is_action_just_pressed("selecionar_opcao"):
		if not sair: continuar_butao.pressed.emit()
		else: sair_butao.pressed.emit()

func alterar_tempo(tempo: int) -> void:
	wave_time -= 1
	
	if wave_time == 0:
		nova_wave.emit()
		wave_time = 30
	
	if tempo < 60:
		$Jogo/Tempo.text = "00:" + formatar(tempo)
	else:
		@warning_ignore("integer_division")
		var minuto := tempo / 60
		while tempo >= 60: tempo -= 60
		$Jogo/Tempo.text = formatar(minuto) + ":" + formatar(tempo)

func alterar_wave(wave: int) -> void:
	$Jogo/Wave.text = "Wave " + str(wave)

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
		var coracao = Sprite2D.new()

		coracao.texture = vida_cheia.texture
		coracao.scale = anterior.scale
		coracao.position.y = anterior.position.y
		coracao.position.x = anterior.position.x + (anterior.get_rect().size.x * anterior.scale.x) + 5

		vidas.push_back(coracao)
		coracao.visible = true
		anterior = coracao
		$Jogo.add_child(coracao)

func atualizar_pontuacao(pontuacao: int, high_score: int) -> void:
	score = high_score
	$Jogo/Pontuacao.text = str(pontuacao)

func trocar_visibilidade(node_mestre: Node) -> void:
	for node in node_mestre.get_children():
		node.visible = not node.visible

func _on_iniciar_mouse_entered() -> void:
	$MainMenu/OpcaoSelecionada.position = $MainMenu/MarcadorIniciar.position
	sair = false

func _on_sair_mouse_entered() -> void:
	$MainMenu/OpcaoSelecionada.position = $MainMenu/MarcadorSair.position
	sair = true

func _on_iniciar_pressed() -> void:
	iniciar_jogo.emit()
	trocar_visibilidade($MainMenu)
	trocar_visibilidade($Jogo)
	desenhar_vidas(3)
	set_process(false)

func _on_sair_pressed() -> void:
	get_tree().quit()

func pause() -> void:
	pausado.emit()
	trocar_visibilidade($Jogo)
	trocar_visibilidade($Pause)
	
	$Pause/HighScore.text = "[i]High Score: " + str(score) + "[/i]"
	
	continuar_butao = $Pause/Voltar
	sair_butao = $Pause/Sair
	
	set_process(true)

func _on_voltar_pressed() -> void:
	trocar_visibilidade($Pause)
	trocar_visibilidade($Jogo)
	retomar.emit()

	set_process(false)

func _on_sair_pause_pressed() -> void:
	var config := ConfigFile.new()
	config.load(CONFIG)
	config.set_value("player", "high_score", score)
	config.save(CONFIG)

	get_tree().quit()

func _on_voltar_mouse_entered() -> void:
	$Pause/OpcaoSelecionada.position = $Pause/MarcadorVoltar.position
	sair = false

func _on_sair_pause_mouse_entered() -> void:
	$Pause/OpcaoSelecionada.position = $Pause/MarcadorSair.position
	sair = true

func game_over() -> void:
	pausado.emit()
	trocar_visibilidade($GameOver)
	
	vidas[0].texture = vida_perdida.texture
	
	$GameOver/HighScore.text = "[i]High Score: " + str(score) + "[/i]"
	
	continuar_butao = $GameOver/Recomecar
	sair_butao = $GameOver/Sair
	
	for timer: TimerPausavel in get_parent().timers:
		timer.pausar()
	
	set_process(true)

func _on_sair_game_over_mouse_entered() -> void:
	$GameOver/OpcaoSelecionada.position = $GameOver/MarcadorSair.position
	sair = true

func _on_recomecar_pressed() -> void:
	for timer: TimerPausavel in get_parent().timers:
		timer._reset()
	
	for coracao in vidas:
		coracao.texture = vida_cheia.texture
	
	desenhar_vidas(3)

	iniciar_jogo.emit()
	trocar_visibilidade($GameOver)
	set_process(false)

func _on_recomecar_mouse_entered() -> void:
	$GameOver/OpcaoSelecionada.position = $GameOver/MarcadorRecomecar.position
	sair = false
